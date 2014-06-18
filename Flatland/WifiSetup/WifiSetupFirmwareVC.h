//
//  WifiSetupFirmwareVC.h
//  Flatland
//
//  Created by Ionel Pascu on 4/22/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatWifiViewController.h"

@interface WifiSetupFirmwareVC : FlatWifiViewController
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, atomic) NSString *titleString;
@property (strong, nonatomic) IBOutlet UILabel *descLabel1;
@property (strong, atomic) NSString *descString1;
@property (strong, nonatomic) IBOutlet UILabel *descLabel2;
@property (strong, atomic) NSString *descString2;

@end
