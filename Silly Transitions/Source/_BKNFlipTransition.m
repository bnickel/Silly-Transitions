//
//  _BKNFlipTransition.m
//  Silly Transitions
//
//  Created by Brian Nickel on 4/10/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import "_BKNFlipTransition.h"
#import "CATransaction+SillyTransitions.h"

@implementation _BKNFlipTransition

- (instancetype)initWithDirection:(BKNFlipTransitionDirection)direction
{
    self = [super init];
    if (self) {
        _direction = direction;
    }
    return self;
}

- (instancetype)initWithNavigationOperation:(UINavigationControllerOperation)operation
{
    switch (operation) {
        case UINavigationControllerOperationPush:
            return [self initWithDirection:BKNFlipTransitionLeft];
            
        case UINavigationControllerOperationPop:
            return [self initWithDirection:BKNFlipTransitionRight];
            
        case UINavigationControllerOperationNone:
            return nil;
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return UINavigationControllerHideShowBarDuration * 2;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    to.view.frame = [transitionContext finalFrameForViewController:to];
    [[transitionContext containerView] addSubview:to.view];
    
    from.view.layer.doubleSided = NO;
    to.view.layer.doubleSided = NO;
    
    CATransform3D perspectiveTransform = CATransform3DIdentity;
    perspectiveTransform.m34 = 1.0 / -500;
    [transitionContext containerView].layer.sublayerTransform = perspectiveTransform;
    
    CGFloat scale;
    switch (self.direction) {
        case BKNFlipTransitionLeft:
            scale = -1;
            break;
            
        case BKNFlipTransitionRight:
            scale = 1;
            break;
    }
    
    [CATransaction BKN_transactionWithDuration:duration animations:^{
        
        CABasicAnimation *fromFlipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        fromFlipAnimation.fromValue = @(0);
        fromFlipAnimation.toValue = @(scale * M_PI);
        fromFlipAnimation.fillMode = kCAFillModeBoth;
        fromFlipAnimation.removedOnCompletion = NO;
        
        CABasicAnimation *toFlipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        toFlipAnimation.fromValue = @(- scale * M_PI);
        toFlipAnimation.toValue = @(0);
        toFlipAnimation.fillMode = kCAFillModeBoth;
        toFlipAnimation.removedOnCompletion = NO;
        
        [from.view.layer addAnimation:fromFlipAnimation forKey:@"flip"];
        [to.view.layer addAnimation:toFlipAnimation forKey:@"flip"];
        
    } completion:^{
        
        if ([transitionContext transitionWasCancelled]) {
            [to.view removeFromSuperview];
            [transitionContext completeTransition:NO];
        } else {
            [from.view removeFromSuperview];
            [transitionContext completeTransition:YES];
        }
        
        to.view.layer.transform = CATransform3DIdentity;
        from.view.layer.transform = CATransform3DIdentity;
        [transitionContext containerView].layer.sublayerTransform = CATransform3DIdentity;
        
        [to.view.layer removeAnimationForKey:@"flip"];
        [from.view.layer removeAnimationForKey:@"flip"];

        
    }];
}

- (void)addPopGestureRecognizersToViewController:(UIViewController *)viewController transitioningDelegate:(BKNTransitioningDelegate *)transitioningDelegate
{
    [viewController.view addGestureRecognizer:[transitioningDelegate panGestureRecognizerForLeftEdgeOfViewController:viewController]];
}

@end
