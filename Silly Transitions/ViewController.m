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
#import "UIBezierPath+SillyTransitions.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *starButton;
@end

@implementation ViewController

- (void)viewDidLoad
{
    CAShapeLayer *starLayer = [CAShapeLayer layer];
    starLayer.path = [[UIBezierPath BKN_bezierPathWithStarEncompassingRect:self.starButton.titleLabel.frame] CGPath];
    self.starButton.layer.mask = starLayer;
}

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
    
    [segue.destinationViewController setTitle:[sender titleForState:UIControlStateNormal]];
    [segue.destinationViewController view].backgroundColor = [self rotatedColor];
}

- (UIColor *)rotatedColor
{
    static NSInteger SharedHue = - 100;
    SharedHue = (SharedHue + 100) % 360;
    return [UIColor colorWithHue:(float)SharedHue / 360.0 saturation:1 brightness:1 alpha:1];
}

@end
