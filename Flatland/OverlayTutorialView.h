//
//  OverlayTutorialView.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 21.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverlayTutorialView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *overlayTutorialImage;

+ (OverlayTutorialView *)overlayTutorialView;

+ (void)openTutorialView;

@end
