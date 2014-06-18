//
//  WifiHomeViewController.m
//  Flatland
//
//  Created by Ionel Pascu on 12/3/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "WifiHomeViewController.h"
#import "User.h"
#import "WifiSetupTermsViewController.h"


@interface WifiHomeViewController ()

@end

@implementation WifiHomeViewController

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
    //call getWifiStatus API - already called in app Home
    //if configured, show alert
    //NSLog(@"growth:: %@", GrowthPathFromJSON(1));
    //NSLog(@"Wifi status:: %@", [[User activeUser] wifiStatus]);

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:T(@"%wifisetup.alert1") delegate:self cancelButtonTitle:T(@"%general.ok") otherButtonTitles:nil];
    alert.tag = 2;
    [alert show];
    
    
    if (IS_IOS7)
    {
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    }
    
    [[User activeUser] setWifiSetupStarted:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startSetup:(id)sender {
#ifdef BABY_NES_US
    WifiSetupInstructionsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WifiSetupInstructions"];
    
#else
    WifiSetupTermsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Terms"];
#endif//BABY_NES_US
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)cancelSetup:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag){
        case 1:{
            if (buttonIndex == 0) [self cancelSetup:nil];
            else if (buttonIndex == 1){
            }
            break;
        }
        case 2: {
//            if (buttonIndex == 0){
//                UIAlertView *alertCleaningTool = [[UIAlertView alloc] initWithTitle:nil message:T(@"%wifisetup.alert3") delegate:self cancelButtonTitle:T(@"%general.ok") otherButtonTitles:nil];
//                alertCleaningTool.tag = 3;
//                [alertCleaningTool show];
//            }
//
//            break;
//        }
//        case 3:{
            if (buttonIndex == 0){
                if ([[User activeUser] wifiStatus] == WIFI_STATUS_CONFIGURED)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:T(@"%wifisetup.alert2") delegate:self cancelButtonTitle:T(@"%general.cancel") otherButtonTitles:T(@"%general.ok"),  nil];
                    alert.tag = 1;
                    [alert show];
                }
            }
            break;
        }
            
        default: break;
    }
}

@end
