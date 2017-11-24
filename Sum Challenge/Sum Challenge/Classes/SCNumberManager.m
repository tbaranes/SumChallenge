//
//  SCNumberManager.m
//  Sum Challenge
//
//  Created by Tom Baranes on 27/05/14.
//  Copyright (c) 2014 Tom Baranes. All rights reserved.
//

#import "SCNumberManager.h"

@interface SCNumberManager ()

@property (strong, nonatomic) NSMutableArray *currentNumbersUsed;

@property (nonatomic) NSInteger maxNumberRange;
@property (nonatomic) NSInteger minNumberRange;

@end

@implementation SCNumberManager

#pragma mark - Life cycle

- (id)init {
	self = [super init];
	if (self) {
		self.currentNumbersUsed = [NSMutableArray array];
	}
	return self;
}

- (void)resetNumbers {
	self.nb1 = 0;
	self.nb2 = 0;
	self.score = 0;
	self.resultExpected = 0;
	self.maxNumberRange = MAX_NUMBER_RANGE_AT_START;
	self.minNumberRange = MIN_NUMBER_RANGE_AT_START;
	self.circleAnimationDuration = CIRCLE_ANIMATION_DURATION_MAX;
	[self.currentNumbersUsed removeAllObjects];
	[self createValidNumbers];
}

#pragma mark - Helper

- (void)createValidNumbers {
	self.score += self.resultExpected;
	self.maxNumberRange++;
	self.minNumberRange++;
		
	self.nb1 = self.resultExpected;
	self.nb2 = arc4random() % (self.maxNumberRange - self.minNumberRange) + self.minNumberRange;
	self.resultExpected = self.nb1 + self.nb2;
	
	self.circleAnimationDuration -= CIRCLE_ANIMATION_DURATION_DEC;
	self.circleAnimationDuration = self.circleAnimationDuration < CIRCLE_ANIMATION_DURATION_MIN ? CIRCLE_ANIMATION_DURATION_MIN : self.circleAnimationDuration;
}

#pragma mark - Number generation

- (NSInteger)randomNumber {
	NSInteger number = self.resultExpected;
	NSInteger random = (arc4random() % 2) == 1;
	if (![self.currentNumbersUsed containsObject:@(number)] && !random) {
		number = self.resultExpected;
	} else if (self.resultExpected - self.maxNumberRange <= 0) {
		number = arc4random() % (self.maxNumberRange - self.minNumberRange) + self.minNumberRange;
	} else {
		number = arc4random() % (self.resultExpected + self.maxNumberRange) + (self.resultExpected - self.maxNumberRange);
	}
	return number;
}

- (NSInteger)generateRandomNumberWithOldNumber:(NSInteger)oldNumber {
	[self erasedNumber:oldNumber];
	
	NSInteger number = [self randomNumber];
	while ([self.currentNumbersUsed containsObject:@(number)]) {
		number = [self randomNumber];
	}
		
	[self.currentNumbersUsed addObject:@(number)];
	return number;
}

#pragma mark - Manager

- (void)erasedNumber:(NSInteger)number {
	if ([self.currentNumbersUsed containsObject:@(number)]) {
		[self.currentNumbersUsed removeObject:@(number)];
	}
}

- (BOOL)isTheGoodNumber:(NSInteger)numberSelected {
	return numberSelected == self.resultExpected;
}

@end
