//
//  WelcomeViewController.m
//  Flatland
//
//  Created by Stefan Aust on 14.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WelcomeViewController.h"
#import "HomeViewController.h"

@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *discoverLabel;
@property (strong, nonatomic) IBOutlet UILabel *storeLocatorLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactLabel;



@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CountryCode();
    [self.view changeSystemFontToApplicationFont];
}

// hide navigation bar for this screen
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

// show navigation bar (the default) if this screen is left
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (IBAction)doLogin:(id)sender {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Login"] animated:YES];
}

- (IBAction)doRegister:(id)sender {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Register"] animated:YES];
}

- (IBAction)doDiscover:(id)sender {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Discover"] animated:YES];
}

- (IBAction)doFindShops:(id)sender {
}

- (IBAction)doContact:(id)sender {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Contact"] animated:YES];
}

- (IBAction)doHome:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
