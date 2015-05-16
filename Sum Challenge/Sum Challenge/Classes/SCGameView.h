//
//  SCGameView.h
//  Sum Challenge
//
//  Created by Tom Baranes on 27/05/14.
//  Copyright (c) 2014 Tom Baranes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCGameDelegate <NSObject>

- (void)newOperation:(NSInteger)oldResultExpected nb2:(NSInteger)nb2;
- (void)gameOverWithScore:(NSInteger)score resultExpected:(NSInteger)resultExpected;
- (void)gameOverWithScore:(NSInteger)score badNumberPressed:(NSInteger)badNumber;

@end

@interface SCGameView : UIView

@property (weak, nonatomic) id<SCGameDelegate> delegate;

- (IBAction)launchGame;

@end
