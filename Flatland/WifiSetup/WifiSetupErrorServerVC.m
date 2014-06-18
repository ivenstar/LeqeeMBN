//
//  WifiSetupErrorServerVC.m
//  Flatland
//
//  Created by Ionel Pascu on 12/6/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "WifiSetupErrorServerVC.h"

@interface WifiSetupErrorServerVC ()

@end

@implementation WifiSetupErrorServerVC

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
    
    self.navigationItem.rightBarButtonItem = MakeImageBarButton(@"barbutton-close", self, @selector(close));
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_callBtn setTitle:[NSString stringWithFormat:@"%@ %@", T(@"%general.call"), T(@"%contact.text.2")]forState:UIControlStateNormal];
    [_callBtn setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)makeCall:(id)sender {
    CallSupport();
}


- (void) close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
