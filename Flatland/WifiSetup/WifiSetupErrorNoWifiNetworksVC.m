//
//  WifiSetupErrorNoWifiNetworksVC.m
//  Flatland
//
//  Created by Ionel Pascu on 12/19/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "WifiSetupErrorNoWifiNetworksVC.h"
#import "WifiSetupAdvancedWizVC.h"

@interface WifiSetupErrorNoWifiNetworksVC ()

@end

@implementation WifiSetupErrorNoWifiNetworksVC

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
    //_titleLabel.text = @"No visible wifi networks found";
    _description.text = T(@"%wifisetup.wizard1");
    _description.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanAgain:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)openWizard:(id)sender {
    WifiSetupAdvancedWizVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WifiSetupAdvancedWiz"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
