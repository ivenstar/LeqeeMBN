//
//  AppDelegate.h
//  Flatland
//
//  Created by Stefan Aust on 13.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL isAlreadyStarted;
@property(nonatomic, strong) id<GAITracker> tracker;
@property(nonatomic) BOOL WifiSetupConfigureVisible;
@property(nonatomic) BOOL returnFromBG;


@end
