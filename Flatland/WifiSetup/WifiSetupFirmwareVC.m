//
//  WifiSetupFirmwareVC.m
//  Flatland
//
//  Created by Ionel Pascu on 4/22/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "WifiSetupFirmwareVC.h"

@interface WifiSetupFirmwareVC ()

@end

@implementation WifiSetupFirmwareVC

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
    self.titleLabel.text = self.titleString;
    self.descLabel1.text = self.descString1;
    self.descLabel2.text = self.descString2;
    
    //self.navigationItem.rightBarButtonItem = MakeImageBarButton(@"barbutton-close", self, @selector(closeModal));
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
