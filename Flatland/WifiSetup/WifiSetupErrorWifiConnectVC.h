//
//  WifiSetupErrorWifiConnectVC.h
//  Flatland
//
//  Created by Ionel Pascu on 12/11/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatWifiViewController.h"

@interface WifiSetupErrorWifiConnectVC : FlatWifiViewController
- (IBAction)restartProcess:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *callBtn;
- (IBAction)openWizard:(id)sender;
- (IBAction)makeCall:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *desc1;
@property (strong, nonatomic) IBOutlet UITextView *desc2;
@property (strong, nonatomic) IBOutlet UITextView *desc3;
@property (weak, nonatomic) IBOutlet UIButton *restartConnectionButton;

@end
