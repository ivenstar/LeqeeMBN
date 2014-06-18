//
//  WifiBaseViewController.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 28.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WifiBaseViewController.h"
#import "WifiChangeOptionsViewController.h"
#import "User.h"
#import "WaitIndicator.h"

@interface WifiBaseViewController () <UIAlertViewDelegate>

@end

@implementation WifiBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = MakeImageBarButton(@"barbutton-close", self, @selector(doCancel:));
}

- (IBAction)doCancel:(id)sender {
    if(![self isKindOfClass:[WifiChangeOptionsViewController class]])   {
    [[[UIAlertView alloc] initWithTitle:T(@"%wifi.alert.cancel.title")
                                message:T(@"%wifi.alert.cancel.text")
                               delegate:self
                      cancelButtonTitle:T(@"%general.cancel")
                      otherButtonTitles:T(@"%general.yes"), nil] show];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if([[User activeUser] wifiStatus] != WIFI_STATUS_CONFIGURING)
        {
            [WaitIndicator waitOnView:self.view];
            [[User activeUser] setWifiStatus:WIFI_STATUS_CONFIGURING completion:^(BOOL success) {
                [self.view stopWaiting];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

@end
