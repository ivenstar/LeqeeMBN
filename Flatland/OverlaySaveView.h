//
//  OverlaySaveView.h
//  Flatland
//
//  Created by Stefan Aust on 21.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverlaySaveView : UIView

@property (nonatomic, weak) IBOutlet UILabel *messageLabel;

+ (OverlaySaveView *)overlayTutorialView;

+ (void)showOverlayWithMessage:(NSString *)message afterDelay:(NSTimeInterval)delay performBlock:(void(^)())block;
+ (void)showOverlayLandscapeWithMessage:(NSString *)message afterDelay:(NSTimeInterval)delay performBlock:(void(^)())block;

@end
