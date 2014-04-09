//
//  BKNTransitioningDelegate.m
//  Silly Transitions
//
//  Created by Brian Nickel on 4/9/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import "BKNTransitioningDelegate.h"
#import "UIViewController+SillyTransitions.h"
#import "_BKNStarTransition.h"

@interface BKNTransitioningDelegate()
@property (nonatomic, strong) id<UIViewControllerAnimatedTransitioning> currentTransition;
@end

@implementation BKNTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    BKNSillyTransitionType type;
    switch (operation) {
        case UINavigationControllerOperationPush:
            type = toVC.BKN_introTransitionType;
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
    }
    
    return self.currentTransition;
}

@end
