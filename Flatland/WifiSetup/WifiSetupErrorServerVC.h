//
//  WifiSetupErrorServerVC.h
//  Flatland
//
//  Created by Ionel Pascu on 12/6/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatWifiViewController.h"

@interface WifiSetupErrorServerVC : FlatWifiViewController
- (IBAction)makeCall:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *callBtn;

@end
