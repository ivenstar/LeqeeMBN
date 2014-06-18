//
//  WifiSetupErrorVC.m
//  Flatland
//
//  Created by Ionel Pascu on 12/5/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "WifiSetupErrorVC.h"

@interface WifiSetupErrorVC ()

@end

@implementation WifiSetupErrorVC
@synthesize titleTxt, description, suport;
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
    titleTxt.text = self.titleS;
    description.text = self.descriptionS;
    suport.text = self.suportS;
    if ([suport.text isEqualToString:@""]) [suport setHidden:YES];
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
@end
