//
//  WifiSetupSettingUpMachineVC.h
//  Flatland
//
//  Created by Ionel Pascu on 12/4/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatWifiViewController.h"
#import "WifiSetupErrorVC.h"
#import "WifiSetupLostConnectionVC.h"
#import "WifiSetupErrorServerVC.h"
#import "WifiSetupErrorWifiConnectVC.h"
#import "WifiSetupFirmwareVC.h"

@interface WifiSetupSettingUpMachineVC : FlatWifiViewController
@property (strong, nonatomic) IBOutlet UITextView *connectingText;
@property (strong, nonatomic) NSString *connecting;
@property (strong, nonatomic) NSString *pass;
@property (strong, nonatomic) NSString *ssid;
@property (nonatomic) int visibleFirmware; //0 for None; 1 for Available; 2 for Downloaded

- (void) setupStatusPoll;
- (void)configureWifi:(void (^)(BOOL success))completion;
- (void)getSetupStatus:(void (^)(BOOL success))completion;
- (void)completeSetup:(void (^)(BOOL success))completion;
@property (nonatomic) int setupStatus;
@end
