//
//  OverlaySaveView.m
//  Flatland
//
//  Created by Stefan Aust on 21.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "OverlaySaveView.h"
#import "AppDelegate.h"

@implementation OverlaySaveView

+ (OverlaySaveView *)overlayTutorialView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] objectAtIndex:0];
}

+ (void)showOverlayWithMessage:(NSString *)message afterDelay:(NSTimeInterval)delay performBlock:(void(^)())block {
    // find the topmost window; cannot use -keyWindow because of alert view overlays
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;

    OverlaySaveView *overlaySaveView = [self overlayTutorialView];
    overlaySaveView.messageLabel.text = message;
    overlaySaveView.center = window.center;
    [window addSubview:overlaySaveView];
    [window setUserInteractionEnabled:NO];
    [overlaySaveView performSelector:@selector(closeWithBlock:) withObject:block afterDelay:delay];
}
//Ionel: added for Landscape version
+ (void)showOverlayLandscapeWithMessage:(NSString *)message afterDelay:(NSTimeInterval)delay performBlock:(void(^)())block {
    // find the topmost window; cannot use -keyWindow because of alert view overlays
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    OverlaySaveView *overlaySaveView = [self overlayTutorialView];
    overlaySaveView.messageLabel.text = message;
    overlaySaveView.center = window.center;
    if ([[UIDevice currentDevice] orientation] == 4)
    overlaySaveView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    else overlaySaveView.transform = CGAffineTransformMakeRotation(M_PI_2);
    [window addSubview:overlaySaveView];
    [window setUserInteractionEnabled:NO];
    [overlaySaveView performSelector:@selector(closeWithBlock:) withObject:block afterDelay:delay];
}

- (void)closeWithBlock:(void(^)())block {
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [self removeFromSuperview];
    [window setUserInteractionEnabled:YES];
    block();
}

@end
