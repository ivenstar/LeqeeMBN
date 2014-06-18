//
//  FlatWifiViewController.m
//  Flatland
//
//  Created by Ionel Pascu on 12/12/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "FlatWifiViewController.h"

@interface FlatWifiViewController ()

@end

@implementation FlatWifiViewController

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
    [[super parentViewController] viewDidLoad];
    [self icnhLocalizeView];
    [self.view changeSystemFontToApplicationFont];
    self.navigationItem.hidesBackButton = TRUE;
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    //[[super parentViewController] viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    //[[super parentViewController] viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exitSetup{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
