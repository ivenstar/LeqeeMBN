//
//  WifiHomeViewController.h
//  Flatland
//
//  Created by Ionel Pascu on 12/3/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatWifiViewController.h"
#import "WifiSetupInstructionsVC.h"

@interface WifiHomeViewController : FlatWifiViewController <UIAlertViewDelegate>
- (IBAction)startSetup:(id)sender;
- (IBAction)cancelSetup:(id)sender;

@end
