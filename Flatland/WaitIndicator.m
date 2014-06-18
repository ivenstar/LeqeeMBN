//
//  WaitIndicator.m
//  BabyNes
//
//  Created by Stefan Matthias Aust on 28.06.11.
//  Copyright 2011 Proximity GmbH. All rights reserved.
//

#import "WaitIndicator.h"
#import "AppDelegate.h"

#define WAIT_INDICATOR_TAG 898719

@implementation WaitIndicator

+ (WaitIndicator *)waitIndicator {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] objectAtIndex:0];
}

+ (BOOL)waitOnView:(UIView *)view {
    // find the topmost window; cannot use -keyWindow because of alert view overlays
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    // Are we already waiting? If YES, abort
    if ([window viewWithTag:WAIT_INDICATOR_TAG]) {
        return NO;
    }
    
    WaitIndicator *waitIndicator = [self waitIndicator];
    [waitIndicator icnhLocalizeView];
    [waitIndicator changeSystemFontToApplicationFont];
    waitIndicator.frame = window.frame;
    waitIndicator.tag = WAIT_INDICATOR_TAG;
    //[waitIndicator setUserInteractionEnabled:NO];
    
    [window addSubview:waitIndicator];
    //[window bringSubviewToFront:waitIndicator];
    [window setUserInteractionEnabled:NO];
    return YES;
}

@end


@implementation UIView (WaitIndicator)

- (void)stopWaiting {
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;

    [[window viewWithTag:WAIT_INDICATOR_TAG] removeFromSuperview];
    [window setUserInteractionEnabled:YES];
}

@end
