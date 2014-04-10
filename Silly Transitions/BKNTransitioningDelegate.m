//
//  BKNTransitioningDelegate.m
//  Silly Transitions
//
//  Created by Brian Nickel on 4/9/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import "BKNTransitioningDelegate.h"
#import "UIViewController+SillyTransitions.h"
#import "UIGestureRecognizer+SillyTransitions.h"
#import "_BKNStarTransition.h"
#import "_BKNFlipTransition.h"
#import "_BKNFadeTransition.h"

@interface BKNTransitioningDelegate()
@property (nonatomic, strong) id<BKNSillyTransition> currentTransition;
@property (nonatomic, assign) BOOL isInteractive;
@property (nonatomic, assign) BOOL shouldCompleteCurrentInteractiveTransition;
@end

@implementation BKNTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    BOOL shouldAddGestureRecognizers = NO;
    BKNSillyTransitionType type;
    switch (operation) {
        case UINavigationControllerOperationPush:
            type = toVC.BKN_introTransitionType;
            shouldAddGestureRecognizers = YES;
            break;
            
        case UINavigationControllerOperationPop:
            type = fromVC.BKN_introTransitionType;
            break;
            
        case UINavigationControllerOperationNone:
            type = BKNSillyTransitionTypeNone;
            break;
    }
    
    switch (type) {
        case BKNSillyTransitionTypeNone:
            self.currentTransition = nil;
            break;
            
        case BKNSillyTransitionTypeStar:
            self.currentTransition = [[_BKNStarTransition alloc] initWithNavigationOperation:operation];
            break;
            
        case BKNSillyTransitionTypeFlip:
            self.currentTransition = [[_BKNFlipTransition alloc] initWithNavigationOperation:operation];
            break;
            
        case BKNSillyTransitionTypeFade:
            self.currentTransition = [[_BKNFadeTransition alloc] initWithNavigationOperation:operation];
            break;
    }
    
    if (shouldAddGestureRecognizers) {
        [self.currentTransition addPopGestureRecognizersToViewController:toVC transitioningDelegate:self];
    }
    
    return self.currentTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (self.isInteractive && animationController == self.currentTransition) {
        return self.currentTransition;
    }
    
    return nil;
}

- (UIScreenEdgePanGestureRecognizer *)panGestureRecognizerForLeftEdgeOfViewController:(UIViewController *)viewController
{
    UIScreenEdgePanGestureRecognizer *panGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGestureRecognizer.BKN_viewController = viewController;
    panGestureRecognizer.edges = UIRectEdgeLeft;
    return panGestureRecognizer;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    
    CGPoint point = [sender translationInView:sender.view];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            self.isInteractive = YES;
            [sender.BKN_viewController.navigationController popViewControllerAnimated:YES];
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat percentComplete = point.x / CGRectGetWidth(sender.view.bounds);
            self.shouldCompleteCurrentInteractiveTransition = percentComplete > 0.25;
            [self.currentTransition updateInteractiveTransition:fmaxf(0, percentComplete)];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
            if (self.shouldCompleteCurrentInteractiveTransition) {
                [self.currentTransition finishInteractiveTransition];
            } else {
                [self.currentTransition cancelInteractiveTransition];
            }
            self.isInteractive = NO;
            break;
            
        case UIGestureRecognizerStateCancelled:
            [self.currentTransition cancelInteractiveTransition];
            self.isInteractive = NO;
            break;
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStatePossible:
            break;
    }
}

@end
