//
//  SCNumberManager.h
//  Sum Challenge
//
//  Created by Tom Baranes on 27/05/14.
//  Copyright (c) 2014 Tom Baranes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCNumberManager : NSObject

@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger nb1;
@property (nonatomic) NSInteger nb2;
@property (nonatomic) NSInteger resultExpected;
@property (nonatomic) CGFloat circleAnimationDuration;

- (void)resetNumbers;
- (void)createValidNumbers;
- (BOOL)isTheGoodNumber:(NSInteger)numberSelected;
- (NSInteger)generateRandomNumberWithOldNumber:(NSInteger)oldNumber;

@end
