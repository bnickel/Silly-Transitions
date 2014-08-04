//
//  _BKNStarTransition.m
//  Silly Transitions
//
//  Created by Brian Nickel on 4/9/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import "_BKNStarTransition.h"
#import "UIBezierPath+SillyTransitions.h"
#import "CATransaction+SillyTransitions.h"

@implementation _BKNStarTransition

- (instancetype)initWithDirection:(BKNStarTransitionDirection)direction
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
            return [self initWithDirection:BKNStarTransitionOut];
            
        case UINavigationControllerOperationPop:
            return [self initWithDirection:BKNStarTransitionIn];
            
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
    
    UIView *viewToAnimate;
    
    switch (self.direction) {
        case BKNStarTransitionOut:
            viewToAnimate = to.view;
            break;
            
        case BKNStarTransitionIn:
            viewToAnimate = from.view;
            break;
    }
    
    to.view.frame = [transitionContext finalFrameForViewController:to];
    [[transitionContext containerView] addSubview:to.view];
    
    [[transitionContext containerView] addSubview:viewToAnimate];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.anchorPoint = CGPointMake(0, 1);
    viewToAnimate.layer.mask = shapeLayer;
    
    CGRect targetBounds = viewToAnimate.bounds;
    
    [CATransaction BKN_transactionWithDuration:duration animations:^{
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        
        UIBezierPath *bigPath = [UIBezierPath BKN_bezierPathWithStarEncompassingRect:targetBounds];
        UIBezierPath *smallPath = [UIBezierPath BKN_bezierPathWithStarEncompassingRect:CGRectMake(CGRectGetMidX(targetBounds) - 1, CGRectGetMidY(targetBounds) - 1, 2, 2)];
        
        switch (self.direction) {
            case BKNStarTransitionOut:
                pathAnimation.fromValue = (id)smallPath.CGPath;
                pathAnimation.toValue = (id)bigPath.CGPath;
                break;
                
            case BKNStarTransitionIn:
                pathAnimation.fromValue = (id)bigPath.CGPath;
                pathAnimation.toValue = (id)smallPath.CGPath;
                break;
        }
        
        pathAnimation.fillMode = kCAFillModeBoth;
        pathAnimation.removedOnCompletion = NO;
        
        [shapeLayer addAnimation:pathAnimation forKey:@"path"];
    } completion:^{
        viewToAnimate.layer.mask = nil;
        if ([transitionContext transitionWasCancelled]) {
            [to.view removeFromSuperview];
            [transitionContext completeTransition:NO];
        } else {
            [from.view removeFromSuperview];
            [transitionContext completeTransition:YES];
        }
    }];
}

- (void)addPopGestureRecognizersToViewController:(UIViewController *)viewController transitioningDelegate:(BKNTransitioningDelegate *)transitioningDelegate
{
    [viewController.view addGestureRecognizer:[transitioningDelegate panGestureRecognizerForLeftEdgeOfViewController:viewController]];
}

@end
