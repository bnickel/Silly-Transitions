//
//  BKNPercentDrivenInteractiveTransition.m
//  Silly Transitions
//
//  Created by Brian Nickel on 4/10/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import "BKNPercentDrivenInteractiveTransition.h"

// Slightly modified version of https://github.com/stringcode86/UIPercentDrivenInteractiveTransitionWithCABasicAnimation

@interface BKNPercentDrivenInteractiveTransition () <UIViewControllerAnimatedTransitioning>
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, assign) CFTimeInterval pausedTime;
@end

@implementation BKNPercentDrivenInteractiveTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [self doesNotRecognizeSelector:_cmd];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    CALayer *containerLayer =[_transitionContext containerView].layer;
    containerLayer.speed = 1.0;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    _transitionContext = transitionContext;
    [self animateTransition:_transitionContext];
    [self pauseLayer:[transitionContext containerView].layer];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    [_transitionContext updateInteractiveTransition:percentComplete];
    [_transitionContext containerView].layer.timeOffset =  _pausedTime + [self transitionDuration:_transitionContext]*percentComplete;
}

- (void)cancelInteractiveTransition
{
    [_transitionContext cancelInteractiveTransition];
    CALayer *containerLayer =[_transitionContext containerView].layer;
    containerLayer.speed = -self.completionSpeed;
    containerLayer.beginTime = CACurrentMediaTime();
}

- (void)finishInteractiveTransition
{
    [_transitionContext finishInteractiveTransition];
    [self resumeLayer:[_transitionContext containerView].layer];
}

- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
    _pausedTime = pausedTime;
}

- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

@end