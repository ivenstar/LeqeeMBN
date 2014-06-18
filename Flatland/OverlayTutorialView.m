//
//  OverlayTutorialView.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 21.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "OverlayTutorialView.h"
#import "AppDelegate.h"
#import "User.h"

@implementation OverlayTutorialView

+ (OverlayTutorialView *)overlayTutorialView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] objectAtIndex:0];
}

+ (void)openTutorialView {
    // find the topmost window; cannot use -keyWindow because of alert view overlays
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    OverlayTutorialView *overlayTutorialView = [self overlayTutorialView];
    [overlayTutorialView changeSystemFontToApplicationFont];
    UITapGestureRecognizer *r = [[UITapGestureRecognizer alloc] initWithTarget:overlayTutorialView action:@selector(hide)];
    [overlayTutorialView addGestureRecognizer:r];
    // substract the height of status bar
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGRect frame = window.frame;
    frame.origin.y = statusBarHeight;
    overlayTutorialView.frame = frame;
    
    [window addSubview:overlayTutorialView];
}

- (void)hide {
    // ensure that the user will not se the view again
    [User activeUser].hasSeenTutorialView = YES;
    // and remove it...
    [self removeFromSuperview];
}
@end
