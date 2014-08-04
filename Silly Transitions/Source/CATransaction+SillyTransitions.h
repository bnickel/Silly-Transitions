//
//  CATransaction+SillyTransitions.h
//  Silly Transitions
//
//  Created by Brian Nickel on 4/9/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CATransaction (SillyTransitions)

+ (void)BKN_transactionWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(void))completion;

@end
