//
//  BKNTransitioningDelegate.h
//  Silly Transitions
//
//  Created by Brian Nickel on 4/9/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BKNSillyTransition;

@interface BKNTransitioningDelegate : NSObject <UINavigationControllerDelegate>
- (UIScreenEdgePanGestureRecognizer *)panGestureRecognizerForLeftEdgeOfViewController:(UIViewController *)viewController;
@end

@protocol BKNSillyTransition <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>
- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)cancelInteractiveTransition;
- (void)finishInteractiveTransition;
- (void)addPopGestureRecognizersToViewController:(UIViewController *)viewController transitioningDelegate:(BKNTransitioningDelegate *)transitioningDelegate;
@end

