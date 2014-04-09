//
//  ViewController.m
//  Silly Transitions
//
//  Created by Brian Nickel on 4/9/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import "ViewController.h"
#import "BKNTransitioningDelegate.h"
#import "UIViewController+SillyTransitions.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static BKNTransitioningDelegate *delegate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        delegate = [[BKNTransitioningDelegate alloc] init];
        self.navigationController.delegate = delegate;
    });
    
    if ([segue.identifier isEqualToString:@"star"]) {
        [segue.destinationViewController setBKN_introTransitionType:BKNSillyTransitionTypeStar];
    }
    
    [segue.destinationViewController view].backgroundColor = [self randomColor];
}

- (UIColor *)randomColor
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        srand48(time(0));
    });
    
    
    return [UIColor colorWithHue:drand48() saturation:1 brightness:1 alpha:1];
}

@end
