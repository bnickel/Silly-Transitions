//
//  UIViewController+SillyTransitions.m
//  Silly Transitions
//
//  Created by Brian Nickel on 4/9/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import "UIViewController+SillyTransitions.h"
#import <objc/runtime.h>

@implementation UIViewController (SillyTransitions)

- (BKNSillyTransitionType)BKN_introTransitionType
{
    return [objc_getAssociatedObject(self, @selector(BKN_introTransitionType)) integerValue];
}

- (void)setBKN_introTransitionType:(BKNSillyTransitionType)BKN_introTransitionType
{
    objc_setAssociatedObject(self, @selector(BKN_introTransitionType), @(BKN_introTransitionType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
