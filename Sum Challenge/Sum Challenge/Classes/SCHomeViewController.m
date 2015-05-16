//
//  SCHomeViewController.m
//  Sum Challenge
//
//  Created by Tom Baranes on 27/05/14.
//  Copyright (c) 2014 Tom Baranes. All rights reserved.
//

#import <iAd/iAd.h>
#import "SCHomeViewController.h"

@interface SCHomeViewController ()

@property (nonatomic) BOOL gameCenterEnabled;
@property (nonatomic, strong) NSString *leaderboardIdentifier;

@end

@implementation SCHomeViewController

#pragma mark - Cycle life

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view convertLocalizebleStrings];
	[self setupUI];
	[self setupBestScore];
	[self authenticateLocalPlayer];
	
	[self.viewGame setDelegate:self];	
    self.canDisplayBannerAds = YES;
}

#pragma mark - Setup

- (void)setupUI {
	[self.labelYourScore setHidden:YES];	
	
	// Colors
	[self.btnRanking setTitleColor:[UIColor greenSumChallenge] forState:UIControlStateNormal];
	[self.btnLaunchGame setTitleColor:[UIColor greenSumChallenge] forState:UIControlStateNormal];
	
	[self.labelBestScore setTextColor:[UIColor greenSumChallenge]];
	[self.labelYourScore setTextColor:[UIColor greenSumChallenge]];
	[self.labelFirstNumber setTextColor:[UIColor greenSumChallenge]];
	[self.labelOperationSign setTextColor:[UIColor greenSumChallenge]];
	[self.labelSecondNumber setTextColor:[UIColor greenSumChallenge]];
	[self.labelEqualSign setTextColor:[UIColor greenSumChallenge]];
	[self.labelResult setTextColor:[UIColor greenSumChallenge]];

}

- (void)setupBestScore {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *bestScore = [userDefaults objectForKey:keyUserDefaultBestScore];

	[self.labelBestScore setHidden:!bestScore];
	if (bestScore) {
		[self.labelBestScore setText:[NSLocalizedString(@"home.title.best_score", nil) stringByAppendingString:bestScore]];
	}
}

#pragma mark - IBAction

- (IBAction)rankingPressed:(id)sender {
	[self showLeaderboard];
}

- (IBAction)launchGamePressed:(id)sender {
	[self.labelResult setText:@"?"];
	[self.labelResult setTextColor:[UIColor greenSumChallenge]];

	[self shouldBeDisplayedMenu:NO];
	[self.viewGame launchGame];
}

#pragma mark - Menu management

- (void)shouldBeDisplayedMenu:(BOOL)shouldBeDisplayedMenu {
	self.canDisplayBannerAds = shouldBeDisplayedMenu;
	CGRect frame = [self.viewMenu frame];
	if (shouldBeDisplayedMenu) {
		frame.origin.y = -floorf(CGRectGetHeight([self.viewMenu bounds]));
		[self.viewMenu setFrame:frame];
	}
	[UIView animateWithDuration:1.f animations:^{
		CGRect newFrame = frame;
		newFrame.origin.y = shouldBeDisplayedMenu ? 0 : -floorf(CGRectGetHeight([self.viewMenu bounds]));
		[self.viewMenu setFrame:newFrame];
	}];
}

#pragma mark - SCGameDelegate 

- (void)newOperation:(NSInteger)oldResultExpected nb2:(NSInteger)nb2 {
	[self.labelResult setText:[NSString stringWithFormat:@"%ld", (long)oldResultExpected]];
	[self.labelFirstNumber setText:@""];
	
	CGRect oldFrame = [self.labelResult frame];
	[UIView animateWithDuration:0.5f animations:^{
		[self.labelResult setFrame:[self.labelFirstNumber frame]];
	} completion:^(BOOL finished) {
		[self.labelFirstNumber setText:[self.labelResult text]];
		[self.labelSecondNumber setText:[NSString stringWithFormat:@"%ld", (long)nb2]];
		[self.labelResult setFrame:oldFrame];
		[self.labelResult setText:@"?"];
	}];
}

#pragma mark - End Game management

- (void)gameOverWithScore:(NSInteger)score badNumberPressed:(NSInteger)badNumber {
	NSString *result = [NSString stringWithFormat:@"%d", badNumber];
	[self.labelResult setTextColor:[UIColor redSumChallenge]];
	[self.labelResult setText:result];
	[self manageScore:score];
	[self shouldBeDisplayedMenu:YES];
}

- (void)gameOverWithScore:(NSInteger)score resultExpected:(NSInteger)resultExpected {
	NSString *result = [NSString stringWithFormat:@"%ld", (long)resultExpected];
	[self.labelResult setText:result];
	[self manageScore:score];
	[self shouldBeDisplayedMenu:YES];
}

- (void)manageScore:(NSInteger)score {
	NSString *myScore = [NSString stringWithFormat:@"%ld", (long)score];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *bestScore = [userDefaults objectForKey:keyUserDefaultBestScore];
	if (score > [bestScore intValue]) {
		[self reportScore:score];
		[userDefaults setValue:[NSString stringWithFormat:@"%d", score] forKey:keyUserDefaultBestScore];
		[self.labelBestScore setText:[NSLocalizedString(@"home.title.best_score", nil)  stringByAppendingString:myScore]];
	}
	
	[self.labelYourScore setHidden:NO];
	[self.labelYourScore setText:[NSLocalizedString(@"home.title.your_score", nil) stringByAppendingString:myScore]];
}

#pragma mark - Game center

- (void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
	
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        } else {
            if ([GKLocalPlayer localPlayer].authenticated) {
                self.gameCenterEnabled = YES;
                
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    if (!error) {
                        self.leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            } else {
                self.gameCenterEnabled = NO;
            }
        }
    };
}

- (void)showLeaderboard {
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    gcViewController.gameCenterDelegate = self;
	gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
	gcViewController.leaderboardIdentifier = self.leaderboardIdentifier;
    [self presentViewController:gcViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)reportScore:(NSInteger)score {
	if (!self.gameCenterEnabled) {
		return;
	}
	
    GKScore *gameCenterScore = [[GKScore alloc] initWithLeaderboardIdentifier:self.leaderboardIdentifier];
    [gameCenterScore setValue:score];
    [GKScore reportScores:@[gameCenterScore] withCompletionHandler:nil];
}

@end

