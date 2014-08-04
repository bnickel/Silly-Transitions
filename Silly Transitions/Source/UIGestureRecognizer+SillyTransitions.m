//
//  UIGestureRecognizer+SillyTransitions.m
//  Silly Transitions
//
//  Created by Brian Nickel on 4/9/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import "UIGestureRecognizer+SillyTransitions.h"
#import <objc/runtime.h>

@implementation UIGestureRecognizer (SillyTransitions)

- (UIViewController *)BKN_viewController
{
    return objc_getAssociatedObject(self, @selector(BKN_viewController));
}

- (void)setBKN_viewController:(UIViewController *)BKN_viewController
{
    objc_setAssociatedObject(self, @selector(BKN_viewController), BKN_viewController, OBJC_ASSOCIATION_ASSIGN);
}

@end
