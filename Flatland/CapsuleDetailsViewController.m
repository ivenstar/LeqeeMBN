//
//  CapsuleDetailsViewController.m
//  Flatland
//
//  Created by Stefan Aust on 21.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CapsuleDetailsViewController.h"
#import "IB.h"
#import "FlatBackgroundView.h"

@interface CapsuleDetailsViewController () <UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *capsuleImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@end

@implementation CapsuleDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.capsuleImageView.image = [UIImage imageNamed:self.capsule.imageName];
    self.titleLabel.text = self.capsule.title;
    self.navigationItem.title = self.capsule.title;
    self.descriptionLabel.text = self.capsule.shortDescription;
	
    // format the long description
    IB *ib = [[IB alloc] initWithView:self.contentView];
    [ib padding:@"10 20 15 20"];
    [ib add:[ib heading:[NSString stringWithFormat:T(@"%capsules.longName"), self.capsule.name]]];
    [ib gap: 5];
    
    for (NSString *line in [self.capsule.longDescription componentsSeparatedByString:@"\n"]) {
        [ib add:[ib paragraph:line]];
    }
    
    [ib add:[self linkButton]];
    
    [ib sizeToFit];
    
    // setup size of page
    UIView *contentView = [self.formScrollView.subviews objectAtIndex:0];
    self.formScrollView.contentSize = contentView.bounds.size;
}

- (UIView *)linkButton {
    FlatBackgroundView *view = [[FlatBackgroundView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    view.backgroundColor = [UIColor whiteColor];
    IB *ib = [[IB alloc] initWithView:view];
    [ib padding:@"5"];
    [ib add:[ib paragraph:self.capsule.linkDescription]];
    [ib pack];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkTapped:)]];
    return view;
}

#pragma mark - Private

- (void)linkTapped:(UITapGestureRecognizer *)r {
    // in France, the sensitive capsule is sold by a different company
    if ([kCountryCode isEqualToString:@"FR"] && [self.capsule.type isEqualToString:@"Sensitive"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:T(@"%capsules.sensetive.alert.title")
                                                            message:T(@"%capsules.sensetive.alert.text")
                                                           delegate:self
                                                  cancelButtonTitle:T(@"%general.cancel")
                                                  otherButtonTitles:T(@"%general.continue"), nil];
        [alertView show];
        return;
    }
    
    // Standard behavior is to open the support screen
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginRegistration" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"Contact"];
    [self.navigationController pushViewController:viewController animated:YES];
    
    
    if ([kCountryCode isEqualToString:@"FR"]) {
        CallSupport();
    }
}

#pragma mark - Alert View delegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.powersante.com/"]];
    }
}

@end
