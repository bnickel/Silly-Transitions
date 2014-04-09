//
//  _BKNStarTransition.h
//  Silly Transitions
//
//  Created by Brian Nickel on 4/9/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import "BKNTransitioningDelegate.h"

typedef NS_ENUM(NSInteger, BKNStarTransitionDirection) {
    BKNStarTransitionIn,
    BKNStarTransitionOut
};

@interface _BKNStarTransition : UIPercentDrivenInteractiveTransition <BKNSillyTransition>

- (instancetype)initWithDirection:(BKNStarTransitionDirection)direction;
- (instancetype)initWithNavigationOperation:(UINavigationControllerOperation)operation;

@property (nonatomic, readonly) BKNStarTransitionDirection direction;

@end
