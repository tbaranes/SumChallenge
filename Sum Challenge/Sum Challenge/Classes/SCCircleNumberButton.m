//
//  SCCircleNumberButton.m
//  Sum Challenge
//
//  Created by Tom Baranes on 27/05/14.
//  Copyright (c) 2014 Tom Baranes. All rights reserved.
//

#import "SCCircleNumberButton.h"

@interface SCCircleNumberButton ()

@end

@implementation SCCircleNumberButton

#pragma mark - Button life

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_circle"]];
		[self setBackgroundImage:[imageView image] forState:UIControlStateNormal];
		[self setTitleColor:[UIColor greenSumChallenge] forState:UIControlStateNormal];
		[self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0f]];
		[self.titleLabel setTextAlignment: NSTextAlignmentCenter];
		[self setBackgroundColor:[UIColor clearColor]];
		[self setFrame:frame];
	}
	return self;
}

- (void)resetButtonWithTitle:(NSString *)title {
	NSInteger totHeight = -floorf(CGRectGetHeight([self bounds]));
	CGRect frame = [self frame];
	frame.origin.y = totHeight;
	[self setFrame:frame];
	[self setAlpha:1.f];
	[self setTitle:title forState:UIControlStateNormal];
	
	[self.layer removeAllAnimations];
}

@end
