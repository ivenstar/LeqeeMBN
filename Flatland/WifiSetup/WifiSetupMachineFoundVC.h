//
//  WifiSetupMachineFound.h
//  Flatland
//
//  Created by Ionel Pascu on 12/3/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FlatWifiViewController.h"
#import "SSID.h"

@interface WifiSetupMachineFoundVC : FlatWifiViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UITableView *wifiListTable;
@property (strong, nonatomic) NSMutableDictionary *wifiDict;
@property (strong, nonatomic) NSMutableArray *wifiArray;
@property (strong, nonatomic) NSMutableArray *wifiEncryption;
@property (strong, nonatomic) NSString *selectedSSID;
@property (strong, nonatomic) NSString *selectedEncryption;
@property (strong, nonatomic) NSString *password;
@property (nonatomic, strong) NSMutableArray *ssids;
@property (strong, nonatomic) IBOutlet UITextView *description;
@property (strong, nonatomic) IBOutlet UIButton *scanBtn;

- (void)getWifiList:(void (^)(BOOL success))completion;
- (IBAction)scanAgain:(id)sender;
- (BOOL)validatePassword:(NSString*)pass :(NSString*)encryption;
@end
