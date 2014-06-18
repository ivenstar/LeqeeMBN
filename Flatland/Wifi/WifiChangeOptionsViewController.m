//
//  WifiChangeOptionsViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 19.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WifiChangeOptionsViewController.h"
#import "IB.h"
#import "User.h"

@interface WifiChangeOptionsViewController ()

@end

@implementation WifiChangeOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[User activeUser] loadWifiOptions];
    
    IB *ib = [[IB alloc] initWithView:self.view];
    if (IS_IOS7)
    {
        [ib padding:@"20"];
    }
    [ib mode:IBModeCenter];
    [ib add:[ib image:@"logo-babynes-connect"]];
    [ib mode:IBModeFill];
    [ib addGap:10];
    [ib add:[ib paragraph:T(@"%wifiChange.paragraph.1")]];
    [ib add:[ib paragraph:T(@"%wifiWelcome.paragraph.3")]];
    [ib add:[ib paragraph:T(@"%wifiWelcome.paragraph.4")]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}



// show navigation bar (the default) if this screen is left
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
