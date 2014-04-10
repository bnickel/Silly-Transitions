//
//  _BKNFadeTransition.h
//  Silly Transitions
//
//  Created by Brian Nickel on 4/10/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import "BKNTransitioningDelegate.h"
#import "BKNPercentDrivenInteractiveTransition.h"

typedef NS_ENUM(NSInteger, BKNFadeTransitionDirection) {
    BKNFadeTransitionLeft,
    BKNFadeTransitionRight
};

@interface _BKNFadeTransition : BKNPercentDrivenInteractiveTransition <BKNSillyTransition>

- (instancetype)initWithDirection:(BKNFadeTransitionDirection)direction;
- (instancetype)initWithNavigationOperation:(UINavigationControllerOperation)operation;

@property (nonatomic, readonly) BKNFadeTransitionDirection direction;

@end