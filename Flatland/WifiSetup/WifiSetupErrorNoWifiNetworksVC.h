//
//  WifiSetupErrorNoWifiNetworksVC.h
//  Flatland
//
//  Created by Ionel Pascu on 12/19/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatWifiViewController.h"

@interface WifiSetupErrorNoWifiNetworksVC : FlatWifiViewController
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)scanAgain:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *description;
- (IBAction)openWizard:(id)sender;

@end
