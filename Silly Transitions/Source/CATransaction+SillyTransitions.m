//
//  CATransaction+SillyTransitions.m
//  Silly Transitions
//
//  Created by Brian Nickel on 4/9/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import "CATransaction+SillyTransitions.h"

@implementation CATransaction (SillyTransitions)

+ (void)BKN_transactionWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(void))completion
{
    NSParameterAssert(animations);
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    [CATransaction setCompletionBlock:completion];
    animations();
    [CATransaction commit];
}

@end
