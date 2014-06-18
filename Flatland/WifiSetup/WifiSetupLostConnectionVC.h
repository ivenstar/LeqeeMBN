//
//  WifiSetupLostConnectionVC.h
//  Flatland
//
//  Created by Ionel Pascu on 12/5/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatWifiViewController.h"
#import "AppDelegate.h"

@interface WifiSetupLostConnectionVC : FlatWifiViewController
- (IBAction)chooseOptions:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *chooseReorder;
@property (strong, nonatomic) IBOutlet UILabel *afterFirmwareUpdateTxt;
@property (strong, nonatomic) NSString *afterFirmwareString;

@end
