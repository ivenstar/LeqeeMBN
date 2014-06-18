//
//  WifiSetupLostConnectionVC.m
//  Flatland
//
//  Created by Ionel Pascu on 12/5/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "WifiSetupLostConnectionVC.h"
#import "WifiSetupConnectingVC.h"

@interface WifiSetupLostConnectionVC ()

@end

@implementation WifiSetupLostConnectionVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _chooseReorder.text = T(@"%wifisetup.lost.reorder");
    _afterFirmwareUpdateTxt.text = _afterFirmwareString;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goNext) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).WifiSetupConfigureVisible = TRUE;
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goNext{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).returnFromBG == TRUE){
        ((AppDelegate *)[UIApplication sharedApplication].delegate).returnFromBG = FALSE;
        WifiSetupConnectingVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WifiSetupConnecting"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    
}

- (IBAction)chooseOptions:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openWifiOptions" object:nil];
        //[self performSelector:@selector(openOptions:) withObject:Nil afterDelay:3.0f];
    }];
    
}
@end
