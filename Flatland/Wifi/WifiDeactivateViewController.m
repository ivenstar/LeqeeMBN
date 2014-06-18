//
//  WifiDeactivateViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 19.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WifiDeactivateViewController.h"
#import "IB.h"
#import "User.h"
#import "WaitIndicator.h"

@interface WifiDeactivateViewController ()

@end

@implementation WifiDeactivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    IB *ib = [[IB alloc] initWithView:self.view];
    
    [ib add:[ib heading:T(@"%wifiDeactivate.heading")]];
    [ib add:[ib paragraph:T(@"%wifiDeactivate.paragraph.1")]];
    [ib add:[ib paragraph:T(@"%wifiDeactivate.paragraph.2")]];
    [ib add:[ib paragraph:T(@"%wifiDeactivate.paragraph.3")]];
    [ib add:[ib paragraph:T(@"%wifiDeactivate.paragraph.4")]];
    [ib add:[ib paragraph:T(@"%wifiDeactivate.paragraph.5")]];
}

- (IBAction)doDeactivate:(id)sender {
    [WaitIndicator waitOnView:self.view];
    [[User activeUser] setWifiStatus:WIFI_STATUS_DEACTIVATED completion:^(BOOL success) {
        [self.view stopWaiting];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
