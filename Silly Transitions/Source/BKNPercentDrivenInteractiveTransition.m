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
@property (nonatomic, readonly, weak) CALayer *containerLayer;
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, assign) CFTimeInterval pausedTime;
@end

@implementation BKNPercentDrivenInteractiveTransition

- (CALayer *)containerLayer
{
    return [self.transitionContext containerView].layer;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [self doesNotRecognizeSelector:_cmd];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    self.containerLayer.speed = 1.0;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    _transitionContext = transitionContext;
    _duration = [self transitionDuration:transitionContext];
    
    [self animateTransition:transitionContext];
    [self pauseLayer:self.containerLayer];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    [self.transitionContext updateInteractiveTransition:percentComplete];
    self.containerLayer.timeOffset =  self.pausedTime + self.duration * percentComplete;
}

- (void)cancelInteractiveTransition
{
    [self.transitionContext cancelInteractiveTransition];
    self.containerLayer.speed = -1.0;
    self.containerLayer.beginTime = CACurrentMediaTime();
}

- (void)finishInteractiveTransition
{
    [self.transitionContext finishInteractiveTransition];
    [self resumeLayer:self.containerLayer];
}

- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
    self.pausedTime = pausedTime;
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