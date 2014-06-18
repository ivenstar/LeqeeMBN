//
//  WifiWelcomeViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 19.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WifiWelcomeViewController.h"
#import "IB.h"
#import "User.h"

@interface WifiWelcomeViewController ()

@end

@implementation WifiWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[User activeUser] loadWifiOptions];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.title = T(@"%wifisetup.replenishmentoptions");
    
    
    IB *ib = [[IB alloc] initWithView:self.view];
    if (IS_IOS7)
    {
        [ib padding:@"20"];
    }
    [ib mode:IBModeCenter];
    [ib add:[ib image:@"logo-babynes-connect"]];
    [ib mode:IBModeFill];
    [ib addGap:10];
    [ib add:[ib heading:T(@"%wifiWelcome.heading")]];
    
    if([[User activeUser] hasStartedWifiRefill])
    {
        [ib add:[ib paragraph:T(@"%wifiWelcome.paragraph.1")]];
    }
    else
    {
        [[User activeUser] setHasStartedWifiRefill:YES];
    }
    
    [ib add:[ib paragraph:T(@"%wifiWelcome.paragraph.2")]];
    [ib add:[ib paragraph:T(@"%wifiWelcome.paragraph.3")]];
    [ib add:[ib paragraph:T(@"%wifiWelcome.paragraph.4")]];

    if (IS_IOS7)
    {
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
        
        UIView *blackBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        [blackBar setBackgroundColor:[UIColor blackColor]];
        
        [self.view addSubview:blackBar];
        
        for (UIView *view in self.view .subviews)
        {
            if (view != self.buttonNext && view != self.buttonBegin )
            {
                CGRect viewFrame = view.frame;
                viewFrame.origin.y += 44;
                view.frame = viewFrame;
            }
        }
    }
}

// hide navigation bar for this screen
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

// show navigation bar (the default) if this screen is left
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
