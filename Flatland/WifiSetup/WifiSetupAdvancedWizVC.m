//
//  WifiSetupAdvancedWizVC.m
//  Flatland
//
//  Created by Ionel Pascu on 12/19/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "WifiSetupAdvancedWizVC.h"
#import "AppDelegate.h"

@interface WifiSetupAdvancedWizVC ()

@end

@implementation WifiSetupAdvancedWizVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startWizard:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://10.178.191.1/interface/index.html"];
    [[UIApplication sharedApplication] openURL:url];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)goNext{
//    if (((AppDelegate *)[UIApplication sharedApplication].delegate).returnFromBG == TRUE){
//        ((AppDelegate *)[UIApplication sharedApplication].delegate).returnFromBG = FALSE;
//        WifiSetupConnectingVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WifiSetupConnecting"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    
//    
//    
//}
@end
