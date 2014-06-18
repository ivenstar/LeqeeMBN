//
//  BottlefeedingCell.m
//  Flatland
//
//  Created by Jochen Block on 24.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BottlefeedingCell.h"
#import <QuartzCore/QuartzCore.h>

@interface BottlefeedingCell () {
    CGRect dateOrigin;
    CGRect dateMoved;
}
@end

@implementation BottlefeedingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        dateOrigin = self.capsuleImage.frame;
        dateMoved = CGRectMake(dateOrigin.origin.x - 32, dateOrigin.origin.y, dateOrigin.size.width, dateOrigin.size.height);
    }
    return self;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    if (!IS_IOS7)
    {
        if (state >= 2)
        {
          [UIView animateWithDuration:0.15 animations:^{ self.capsuleImage.alpha = 0.0; }];
        }
    }
    [super willTransitionToState:state];
}

- (void)didTransitionToState:(UITableViewCellStateMask)state
{
    if (!IS_IOS7)
    {
        if (state <= 1)
        {
            [UIView animateWithDuration:0.15 animations:^{ self.capsuleImage.alpha = 1.0; }];
        }
        else
        {
          if (state >= 2)
          {
              [UIView animateWithDuration:0.15 animations:^{ self.capsuleImage.alpha = 0.0; }];
          }
        }
    }
    [super didTransitionToState:state];
}

- (void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade Out" context:nil];
    
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToDissolve.alpha = 0.0;
    [UIView commitAnimations];
}

-(void)fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade In" context:nil];
    
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToFadeIn.alpha = 1;
    [UIView commitAnimations];
    
}

-(void) fadeInFromFadeOut: (UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration
{
    viewToFadeIn.hidden=NO;
    [self fadeOut:viewToFadeIn withDuration:1 andWait:0];
    [self fadeIn:viewToFadeIn withDuration:duration andWait:0];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self sendSubviewToBack:self.contentView];
}

@end
