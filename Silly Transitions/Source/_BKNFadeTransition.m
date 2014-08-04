//
//  _BKNFadeTransition.m
//  Silly Transitions
//
//  Created by Brian Nickel on 4/10/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import "_BKNFadeTransition.h"
#import "CATransaction+SillyTransitions.h"

@implementation _BKNFadeTransition

- (instancetype)initWithDirection:(BKNFadeTransitionDirection)direction
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
            return [self initWithDirection:BKNFadeTransitionLeft];
            
        case UINavigationControllerOperationPop:
            return [self initWithDirection:BKNFadeTransitionRight];
            
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
    
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.frame = CGRectMake(0, 0, CGRectGetWidth(to.view.bounds), CGRectGetHeight(to.view.bounds));
    
    switch (self.direction) {
        case BKNFadeTransitionLeft:
            maskLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
            break;
            
        case BKNFadeTransitionRight:
            maskLayer.colors = @[(id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor];
            break;
    }

    maskLayer.locations = @[@0, @1];
    maskLayer.startPoint = CGPointMake(1, 0.5);
    maskLayer.endPoint = CGPointMake(2, 0.5);
    
    to.view.layer.mask = maskLayer;

    [CATransaction BKN_transactionWithDuration:duration animations:^{
        CABasicAnimation *startPointAnimation = [CABasicAnimation animationWithKeyPath:@"startPoint.x"];
        startPointAnimation.fillMode = kCAFillModeBoth;
        startPointAnimation.removedOnCompletion = NO;

        
        CABasicAnimation *endPointAnimation = [CABasicAnimation animationWithKeyPath:@"endPoint.x"];
        endPointAnimation.fillMode = kCAFillModeBoth;
        endPointAnimation.removedOnCompletion = NO;
        
        switch (self.direction) {
            case BKNFadeTransitionLeft:
                startPointAnimation.fromValue = @1;
                startPointAnimation.toValue = @(-1);
                endPointAnimation.fromValue = @2;
                endPointAnimation.toValue = @0;

                break;
                
            case BKNFadeTransitionRight:
                startPointAnimation.fromValue = @-1;
                startPointAnimation.toValue = @1;
                endPointAnimation.fromValue = @0;
                endPointAnimation.toValue = @2;
                break;
                
        }
        
        [maskLayer addAnimation:startPointAnimation forKey:@"startX"];
        [maskLayer addAnimation:endPointAnimation forKey:@"endX"];
        
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

- (void)addPopGestureRecognizersToViewController:(UIViewController *)viewController transitioningDelegate:(BKNTransitioningDelegate *)transitioningDelegate
{
    [viewController.view addGestureRecognizer:[transitioningDelegate panGestureRecognizerForLeftEdgeOfViewController:viewController]];
}

@end
