//
//  HomeViewController.h
//  Flatland
//
//  Created by Stefan Aust on 15.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"
#import "HomeFeedsDelegate.h"
#import "FlatWifiNavController.h"
#import "WifiHomeViewController.h"
#import "Stock.h"
#import "MenuViewController.h"

@interface HomeViewController : FlatViewController<HomeFeedsDelegate>

@property (nonatomic, strong) Stock *stock;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, strong) NSMutableArray *widgetControllers;
- (void) goToTip:(NSNumber *)tip;
- (void)doAdjustCapsuleStockNotification;
- (void)doOrderRecommendation;
- (void)closeMenu;
@end
