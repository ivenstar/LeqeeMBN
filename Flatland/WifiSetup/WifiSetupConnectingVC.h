//
//  WifiSetupConnectingVC.h
//  Flatland
//
//  Created by Ionel Pascu on 12/3/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatWifiViewController.h"
#import "WifiSetupMachineFoundVC.h"
#import "WifiSetupErrorVC.h"

@interface WifiSetupConnectingVC : FlatWifiViewController
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (void)getSetupStatus:(void (^)(BOOL success))completion;
@end
