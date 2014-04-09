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
    const NSUInteger NumberOfPoints = 5;
    const CGFloat PointSize = 2.618;

    CGFloat innerRadius = powf(powf(CGRectGetWidth(innerRect), 2) + powf(CGRectGetHeight(innerRect), 2), 0.5) / 2;
    CGFloat outerRadius = innerRadius * PointSize;
    
    CGAffineTransform centerTranslation = CGAffineTransformMakeTranslation(CGRectGetMidX(innerRect), CGRectGetMidY(innerRect));
    
    CGPoint innerPoint = CGPointMake(0, -innerRadius);
    CGPoint outerPoint = CGPointMake(0, -outerRadius);
    
    CGFloat radialStep = M_PI / NumberOfPoints;
    
    UIBezierPath *path = [self bezierPath];
    
    [path moveToPoint:CGPointApplyAffineTransform(outerPoint, centerTranslation)];
    
    for (NSUInteger i = 0; i < NumberOfPoints; i ++) {
        [path addLineToPoint:CGPointApplyAffineTransform(CGPointApplyAffineTransform(innerPoint, CGAffineTransformMakeRotation(radialStep * (i * 2 + 1))), centerTranslation)];
        [path addLineToPoint:CGPointApplyAffineTransform(CGPointApplyAffineTransform(outerPoint, CGAffineTransformMakeRotation(radialStep * (i * 2 + 2))), centerTranslation)];
    }
    
    return path;
}

@end
