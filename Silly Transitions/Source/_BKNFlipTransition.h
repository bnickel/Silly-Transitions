//
//  _BKNFlipTransition.h
//  Silly Transitions
//
//  Created by Brian Nickel on 4/10/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import "BKNTransitioningDelegate.h"
#import "BKNPercentDrivenInteractiveTransition.h"

typedef NS_ENUM(NSInteger, BKNFlipTransitionDirection) {
    BKNFlipTransitionLeft,
    BKNFlipTransitionRight
};

@interface _BKNFlipTransition : BKNPercentDrivenInteractiveTransition <BKNSillyTransition>

- (instancetype)initWithDirection:(BKNFlipTransitionDirection)direction;
- (instancetype)initWithNavigationOperation:(UINavigationControllerOperation)operation;

@property (nonatomic, readonly) BKNFlipTransitionDirection direction;

@end