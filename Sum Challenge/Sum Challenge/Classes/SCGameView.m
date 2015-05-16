//
//  SCGameView.m
//  Sum Challenge
//
//  Created by Tom Baranes on 27/05/14.
//  Copyright (c) 2014 Tom Baranes. All rights reserved.
//

#import "SCGameView.h"
#import "SCNumberManager.h"
#import "SCCircleNumberButton.h"

@interface SCGameView ()

@property (strong, nonatomic) SCNumberManager *numberManager;
@property (nonatomic) NSInteger lifesLost;

@property (nonatomic) BOOL isGameOver;
@property (nonatomic) BOOL isFirstLaunch;

@property (strong, nonatomic) NSArray *inGameButtons;
@property (strong, nonatomic) NSArray *separatorViews;

@end

@implementation SCGameView

#pragma mark - Life cycle

- (void)awakeFromNib {
	[super awakeFromNib];
	self.numberManager = [SCNumberManager new];
	[self setIsFirstLaunch:YES];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	if (!self.separatorViews) {
		[self setupUI];
	}
}

- (void)setupUI {
	// Create separator
	NSMutableArray *separators = [NSMutableArray array];
	NSInteger width = floorf(CGRectGetWidth([self bounds])) / NB_GAME_COLUMN - 2;
	CGRect frame = CGRectMake(0, floorf(CGRectGetMaxY([self bounds])) - 1, width, 1);
	for (NSUInteger i = 0; i <= NB_GAME_COLUMN; ++i) {
		UIView *separatorView = [[UIView alloc] initWithFrame:frame];
		[separatorView setBackgroundColor:[UIColor greenSumChallenge]];
		[separatorView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];		
		[self addSubview:separatorView];
		[separators addObject:separatorView];		
		frame.origin.x += width + 2;
	}
	self.separatorViews = [separators copy];
	[self createButtonsGame];
}

- (void)createButtonsGame {
	NSInteger width = floorf(CGRectGetWidth([self bounds])) / NB_GAME_COLUMN - 2;
	NSMutableArray *gameButtons = [NSMutableArray array];
	CGRect frame = CGRectMake(-width, -width, width - 5, width - 5);
	for (NSUInteger i = 0; i <= NB_GAME_COLUMN; ++i) {
		SCCircleNumberButton *gameButton = [[SCCircleNumberButton alloc] initWithFrame:frame];
		[gameButton addTarget:self action:@selector(numberPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:gameButton];
		[gameButtons addObject:gameButton];
		frame.origin.x += width + 2;
	}
	self.inGameButtons = [gameButtons copy];
}

#pragma mark - Running game

- (void)launchGame {
	[self resetLifes];
	[self.numberManager resetNumbers];
	[self.delegate newOperation:[self.numberManager nb1] nb2:[self.numberManager nb2]];

	if (self.isFirstLaunch) {
		for (SCCircleNumberButton *btn in self.inGameButtons) {
			[self launchAnimationButton:btn];
		}
		[self setIsFirstLaunch:NO];
	}

	[self setIsGameOver:NO];
}

#pragma mark - IBAction

- (IBAction)numberPressed:(SCCircleNumberButton *)sender {
	NSInteger numberPressed = [[sender.titleLabel text] intValue];
	if (![self.numberManager isTheGoodNumber:numberPressed]) {
		[self gameOverWithBadNumber:[[sender titleForState:UIControlStateNormal] intValue]];
	} else {
		[self resetLifes];
		[self.numberManager createValidNumbers];
		[self.delegate newOperation:[self.numberManager nb1] nb2:[self.numberManager nb2]];
		[self removeCircleButton:sender];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    for (SCCircleNumberButton *button in self.inGameButtons) {
        if ([button.layer.presentationLayer hitTest:touchLocation]) {
			[self numberPressed:button];
            break;
        }
    }
}

#pragma mark - Circle management

- (void)launchAnimationButton:(SCCircleNumberButton *)btn {
	[self resetBtn:btn];
	
	NSInteger newY = (floorf(CGRectGetHeight([self bounds])) + floorf(CGRectGetHeight([btn bounds])));
	NSInteger duration = [self.numberManager circleAnimationDuration];
	CGFloat delay = ((float)rand() / RAND_MAX) * 2;
	[UIView animateWithDuration:duration delay:delay
						options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationCurveLinear
					 animations:^{
						 [btn setFrame:CGRectOffset([btn frame], 0, newY)];
					 } completion:^(BOOL finished){
						 if (!self.isGameOver && [self.numberManager isTheGoodNumber:[btn.titleLabel.text intValue]]) {
							 [self lostLife];
						 }
						 
						 [self launchAnimationButton:btn];
					 }];
}

- (void)removeCircleButton:(SCCircleNumberButton *)btn {
	[UIView animateWithDuration:1.f animations:^{
		[btn setAlpha:0.f];
	} completion:^(BOOL finished) {
		[self resetBtn:btn];
	}];
}

- (void)resetBtn:(SCCircleNumberButton *)btn {
	NSInteger oldNumber = [[btn titleForState:UIControlStateNormal] intValue];
	NSString *btnText = [NSString stringWithFormat:@"%d", [self.numberManager generateRandomNumberWithOldNumber:oldNumber]];
	[btn resetButtonWithTitle:btnText];
}

#pragma mark - Life management

- (void)animatedLifeView:(UIView *)view newColor:(UIColor *)color  {
	[UIView animateWithDuration:0.3f animations:^{
		CGRect frame = [view frame];
		frame.origin.x += frame.size.width / 2;
		frame.size.width = 0;
		[view setFrame:frame];
	} completion:^(BOOL finished){
		[view setBackgroundColor:color];
		[UIView animateWithDuration:0.3f animations:^{
			CGRect frame = [view frame];
			NSInteger width = floorf(CGRectGetWidth([self bounds])) / NB_GAME_COLUMN - 2;
			frame.origin.x = (width * [self.separatorViews indexOfObject:view]) + [self.separatorViews indexOfObject:view] * 2;
			frame.size.width = width;
			[view setFrame:frame];
		}];
	}];
}

- (void)resetLifes {
	for (UIView *view in self.separatorViews) {
		[self animatedLifeView:view newColor:[UIColor greenSumChallenge]];
	}
	self.lifesLost = 0;
}

- (void)lostLife {
	self.lifesLost++;
	if (self.lifesLost <= NB_GAME_COLUMN) {
		UIView *view = [self.separatorViews objectAtIndex:self.lifesLost - 1];
		[self animatedLifeView:view newColor:[UIColor redSumChallenge]];
	}
	
	if (!self.isGameOver && self.lifesLost == NB_GAME_COLUMN) {
		[self gameOver];
	}
}

#pragma mark - End game

- (void)gameOverWithBadNumber:(NSInteger)badNumber {
	[self setIsGameOver:YES];
	[self.delegate gameOverWithScore:[self.numberManager score] badNumberPressed:badNumber];
}

- (void)gameOver {
	[self setIsGameOver:YES];
	[self.delegate gameOverWithScore:[self.numberManager score] resultExpected:[self.numberManager resultExpected]];
}

@end
