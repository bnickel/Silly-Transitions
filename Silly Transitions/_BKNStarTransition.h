//
//  _BKNStarTransition.h
//  Silly Transitions
//
//  Created by Brian Nickel on 4/9/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BKNStarTransitionDirection) {
    BKNStarTransitionIn,
    BKNStarTransitionOut
};

@interface _BKNStarTransition : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithDirection:(BKNStarTransitionDirection)direction;
- (instancetype)initWithNavigationOperation:(UINavigationControllerOperation)operation;

@property (nonatomic, readonly) BKNStarTransitionDirection direction;

@end
