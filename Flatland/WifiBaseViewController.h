//
//  WifiBaseViewController.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 28.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"

typedef NS_ENUM(NSInteger, WifiOption) {
    WifiOptionNone = 0,
    WifiOptionFullAutomation = 1,
    WifiOptionQuickOrder = 2,
    WifiOptionFeedingTracker = 3
};

@interface WifiBaseViewController : FlatViewController

@property (nonatomic, assign) WifiOption wifiOption;

@end
