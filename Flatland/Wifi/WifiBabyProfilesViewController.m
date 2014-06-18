//
//  WifiBabyProfilesViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 19.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WifiBabyProfilesViewController.h"
#import "BabyProfileViewController.h"
#import "DynamicSizeContainer.h"
#import "AlertView.h"
#import "WaitIndicator.h"
#import "User.h"
#import "WifiVerifyAddressViewController.h"

@interface WifiBabyProfilesViewController () <BabyProfileViewDelegate>

@property (weak, nonatomic) IBOutlet DynamicSizeContainer *container;
@property (nonatomic, strong) NSMutableArray *babyProfileViews;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *addBabyButton;

@end

@implementation WifiBabyProfilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.babyProfileViews = [NSMutableArray new];
    [WaitIndicator waitOnView:self.view];
    [[User activeUser] loadBabies:^(BOOL success) {
        [self.view stopWaiting];
        [self updateBabyProfileViews];
    }];
}

#pragma mark - Actions

- (IBAction)addBabyProfile {
    [self addProfileViewForBaby:nil];
}

- (IBAction)doRegister:(id)sender {
    [self.view endEditing:YES];
    
    BOOL hasError = NO;
    for (BabyProfileViewController *babyProfile in self.babyProfileViews)
    {
        hasError = hasError || ![babyProfile validateFields];
    }
    
    if(hasError)
    {
        return;
    }
    
    [WaitIndicator waitOnView:self.view];
    
    __block int saveRequests = [self.babyProfileViews count];
    __block BOOL hasRESTError = NO;
    for (BabyProfileViewController *babyProfile in self.babyProfileViews) {
        [babyProfile.baby save:^(BOOL success, NSArray *errors) {
            
            saveRequests--;
            hasRESTError = hasRESTError || !success;
            
            if (saveRequests == 0) {
                [self.view stopWaiting];
                if (hasRESTError) {
                    [[AlertView alertViewFromString:T(@"%createProfile.alert.createFailed") buttonClicked:nil] show];
                } else {
                    if (self.wifiOption == WifiOptionFullAutomation || self.wifiOption == WifiOptionQuickOrder) {
                        //Ionel bypass edit address screen, go directly to address list
                        //[self performSegueWithIdentifier:@"configureAddresses" sender:self];
                        [self performSegueWithIdentifier:@"configureDeliveryAddressVerifyBypassed" sender:self];
                    } else {
                        [[User activeUser] setWifiStatus:WIFI_STATUS_CONFIGURED completion:^(BOOL success) {
                            [self.view stopWaiting];
                            if(success) {
                                [self dismiss];
                                [[AlertView alertViewFromString:T(@"%wifi.success") buttonClicked:nil] show];
                            } else {
                                [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
                            }
                        }];
                    }
                }
            }
        }];
    }
}

#pragma mark - Baby Profile View delegate

- (void)presentController:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)removeProfile:(BabyProfileViewController *)babyProfileView {
    if (babyProfileView.baby.ID) {
        [[AlertView alertViewFromString:T(@"%babyProfile.alert.confirmDelete") buttonClicked:^(NSInteger buttonIndex) {
            if(buttonIndex ==0) {
                [babyProfileView.baby remove:^(BOOL success) {
                    if (success) {
                        [self removeBabyView:babyProfileView];
                    } else {
                        [[AlertView alertViewFromString:T(@"%babyProfile.alert.couldNotDelete") buttonClicked:nil] show];
                    }
                }];
            }
        }] show];
    } else {
        [self removeBabyView:babyProfileView];
    }
}

#pragma mark - Private methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"configureAddresses"]) {
//        WifiVerifyAddressViewController *vc = segue.destinationViewController;
//        vc.wifiOption = self.wifiOption;
//    }
    //Ionel bypass edit address screen, go directly to address list
    WifiBaseViewController *vc = segue.destinationViewController;
    if([[[User activeUser] wifiOrderOption] isEqualToString:@"Automatic"]) {
        vc.wifiOption = 1;
    } else if([[[User activeUser] wifiOrderOption] isEqualToString:@"QuickOrder"]) {
        vc.wifiOption = 2;
    } else if([[[User activeUser] wifiOrderOption] isEqualToString:@"TrackerOnly"]) {
        vc.wifiOption = 3;
    }
}

- (void) removeBabyView:(BabyProfileViewController *)vc {
    [self.babyProfileViews removeObject:vc];
    [vc.view removeFromSuperview];
    
    [self showHideRemoveButtonOfProfileViews];
    // enable the button when there are 5 children
    [self.addBabyButton setEnabled:[self.babyProfileViews count] < 5];
    [self performSelector:@selector(resizeScrollView) withObject:nil afterDelay:0];

}

- (void)addProfileViewForBaby:(Baby *)baby {
    BabyProfileViewController *babyProfile = [BabyProfileViewController babyProfileViewControllerWithDelegate:self baby:baby];
    
    if([self.babyProfileViews count] == 0){
        UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 60)];
        [label setTextColor:[UIColor colorWithRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha: 1]];
        [label setBackgroundColor:[UIColor clearColor]];
        [self.view changeSystemFontToApplicationFont];
        label.numberOfLines = 0;
        label.text = T(@"%babyProfile.text.intro");
        [label sizeToFit];
        [labelView addSubview:label];
        labelView.backgroundColor = [UIColor clearColor];
        CGRect newFrame = babyProfile.view.frame;
        newFrame.origin.y = 61;
        babyProfile.view.frame = newFrame;
        [self.container insertSubview: labelView atIndex:0];
    }
    [self.container insertSubview: babyProfile.view atIndex:[self.babyProfileViews count]+1];
    [self.babyProfileViews addObject:babyProfile];
    babyProfile.actionSheetToolbar = self.navigationController.toolbar;
    [self showHideRemoveButtonOfProfileViews];
    //disable the button when there are 5 children
    [self.addBabyButton setEnabled:[self.babyProfileViews count] < 5];
    if([User activeUser].babies.count == 1 && baby) {
        BabyProfileViewController *vc = [self.babyProfileViews objectAtIndex:0];
        UIView *view = vc.view;
        [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 460)];
        [view setNeedsDisplay];
    } else {
        BabyProfileViewController *vc = [self.babyProfileViews objectAtIndex:0];
        UIView *view = vc.view;
        [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 460)];
        [view setNeedsDisplay];
    }
    [self performSelector:@selector(resizeScrollView) withObject:nil afterDelay:0];
}

- (void)updateBabyProfileViews {
    for (Baby *baby in [User activeUser].babies) {
        [self addProfileViewForBaby:baby];
    }
}

- (void)showHideRemoveButtonOfProfileViews
{
    for (BabyProfileViewController *babyProfile in self.babyProfileViews)
    {
        [babyProfile showRemoveButton: [self.babyProfileViews count] > 1 ];
    }
}

- (void)resizeScrollView {
    [self.container sizeToFit];
    ((UIScrollView *)self.view).contentSize = self.container.bounds.size;
}

@end
