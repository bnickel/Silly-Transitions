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
    return UINavigationControllerHideShowBarDuration * 5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    to.view.frame = [transitionContext finalFrameForViewController:to];
    [[transitionContext containerView] addSubview:to.view];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.anchorPoint = CGPointMake(0, 1);
    to.view.layer.mask = shapeLayer;
    
    [CATransaction BKN_transactionWithDuration:duration animations:^{
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        
        CGRect targetBounds = to.view.bounds;
        pathAnimation.fromValue = (id)[UIBezierPath BKN_bezierPathWithStarEncompassingRect:CGRectMake(CGRectGetMidX(targetBounds) - 1, CGRectGetMidY(targetBounds) - 1, 2, 2)].CGPath;
        pathAnimation.toValue = (id)[UIBezierPath BKN_bezierPathWithStarEncompassingRect:targetBounds].CGPath;
        [shapeLayer addAnimation:pathAnimation forKey:@"path"];
        shapeLayer.path = (__bridge CGPathRef)(pathAnimation.toValue);
    } completion:^{
        to.view.layer.mask = nil;
        if ([transitionContext transitionWasCancelled]) {
            [to.view removeFromSuperview];
            [transitionContext completeTransition:NO];
        } else {
            [from.view removeFromSuperview];
            [transitionContext completeTransition:YES];
        }
    }];
}

@end
