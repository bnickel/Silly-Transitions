//
//  UIViewController+SillyTransitions.h
//  Silly Transitions
//
//  Created by Brian Nickel on 4/9/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BKNSillyTransitionType) {
    BKNSillyTransitionTypeNone = 0,
    BKNSillyTransitionTypeStar,
    BKNSillyTransitionTypeFlip
};

@interface UIViewController (SillyTransitions)
@property (nonatomic, assign) BKNSillyTransitionType BKN_introTransitionType;
@end
