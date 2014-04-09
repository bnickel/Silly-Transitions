//
//  UIBezierPath+SillyTransitions.m
//  Silly Transitions
//
//  Created by Brian Nickel on 4/9/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import "UIBezierPath+SillyTransitions.h"

@implementation UIBezierPath (SillyTransitions)

+ (instancetype)BKN_bezierPathWithStarEncompassingRect:(CGRect)innerRect
{
    CGFloat diameter = powf(powf(CGRectGetWidth(innerRect), 2) + powf(CGRectGetHeight(innerRect), 2), 0.5);
    
    CGRect rect = CGRectMake(CGRectGetMidX(innerRect) - diameter / 2, CGRectGetMidY(innerRect) - diameter / 2, diameter, diameter);
    
    return [self bezierPathWithOvalInRect:rect];
}

@end
