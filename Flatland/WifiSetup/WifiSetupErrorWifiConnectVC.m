//
//  WifiSetupErrorWifiConnectVC.m
//  Flatland
//
//  Created by Ionel Pascu on 12/11/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "WifiSetupErrorWifiConnectVC.h"
#import "WifiSetupAdvancedWizVC.h"

@interface WifiSetupErrorWifiConnectVC ()

@end

@implementation WifiSetupErrorWifiConnectVC

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
    _desc1.text = T(@"%wifisetup.cannotwifi.description1");
    _desc2.text = T(@"%wifisetup.cannotwifi.description2");
    _desc3.text = T(@"%wifisetup.cannotwifi.description3");
    [_callBtn setTitle:[NSString stringWithFormat:@"%@ %@", T(@"%general.call"), T(@"%contact.text.2")]forState:UIControlStateNormal];
    [_callBtn setNeedsDisplay];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_callBtn setTitle:[NSString stringWithFormat:@"%@ %@", T(@"%general.call"), T(@"%contact.text.2")]forState:UIControlStateNormal];
    [_callBtn setNeedsDisplay];
    
    self.restartConnectionButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.restartConnectionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)restartProcess:(id)sender {
    UIViewController *prevVC = [self.navigationController.viewControllers objectAtIndex:2];
    [self.navigationController popToViewController:prevVC animated:YES];
}
- (IBAction)openWizard:(id)sender {
    WifiSetupAdvancedWizVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WifiSetupAdvancedWiz"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)makeCall:(id)sender {
    CallSupport();
}
@end
