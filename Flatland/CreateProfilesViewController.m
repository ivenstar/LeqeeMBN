//
//  CreateProfilesViewController.m
//  Flatland
//
//  Created by Stefan Aust on 14.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CreateProfilesViewController.h"
#import "BabyProfileViewController.h"
#import "DynamicSizeContainer.h"
#import "AlertView.h"
#import "WaitIndicator.h"

@interface CreateProfilesViewController () <BabyProfileViewDelegate>

@property (weak, nonatomic) IBOutlet DynamicSizeContainer *container;
@property (nonatomic, strong) NSMutableArray *babyProfileViews;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *addBabyButton;

@end

@implementation CreateProfilesViewController

- (void)viewDidLoad {
    self.navigationItem.hidesBackButton = YES;
    [super viewDidLoad];
    self.babyProfileViews = [NSMutableArray new];
    [self addBabyProfile];
}

#pragma mark - Actions

- (IBAction)addBabyProfile {
    BabyProfileViewController *babyProfile = [BabyProfileViewController babyProfileViewControllerWithDelegate:self];
    
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
    [self performSelector:@selector(resizeScrollView) withObject:nil afterDelay:0];
}

- (IBAction)doRegister:(id)sender {
    [self.view endEditing:YES];
    
    BOOL hasError = NO;
    for (BabyProfileViewController *babyProfile in self.babyProfileViews) {
        NSLog(@"Sinri0529debug doRegister in for cycle: baby=%p,ID=%@,birthday=%@,name=%@",babyProfile.baby,babyProfile.baby.ID,babyProfile.baby.birthday.description,babyProfile.baby.name);
        hasError = hasError || ![babyProfile validateFields];
        NSLog(@"Sinri0529debug doRegister in for cycle: hasError to be %@",(hasError?@"YES":@"NO"));
    }
    NSLog(@"Sinri0529debug doRegister out cycle: hasError been %@",(hasError?@"YES":@"NO"));
    if(hasError) {
        return;
    }
    NSLog(@"Sinri0529debug doRegister over hasError return: hasError been %@",(hasError?@"YES":@"NO"));
    [WaitIndicator waitOnView:self.view];
    __block int saveRequests = [self.babyProfileViews count];
    __block BOOL hasRESTError = NO;

    for (BabyProfileViewController *babyProfile in self.babyProfileViews) {
        [babyProfile.baby save:^(BOOL success, NSArray *errors) {
            
            if([self.babyProfileViews count] == 1){
                
            }
            
            saveRequests--;
            hasRESTError = hasRESTError || !success;
            
            if (saveRequests == 0) {
                [self.view stopWaiting];
                if (hasRESTError) {
                    [[AlertView alertViewFromString:T(@"%createProfile.alert.createFailed") buttonClicked:nil] show];
                } else {
                    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self.babyProfileViews removeObject:babyProfileView];
    [babyProfileView.view removeFromSuperview];
    
    [self showHideRemoveButtonOfProfileViews];
    //disable the button when there are 5 children
    [self.addBabyButton setEnabled:[self.babyProfileViews count] < 5];
    [self performSelector:@selector(resizeScrollView) withObject:nil afterDelay:0];
}

#pragma mark - Private methods

- (void)showHideRemoveButtonOfProfileViews
{
    for (BabyProfileViewController *babyProfile in self.babyProfileViews)
    {
        [babyProfile showRemoveButton: [self.babyProfileViews count] > 1 ];
        [babyProfile setCapsuleSizeOptionHidden:YES];
        [babyProfile setPregnantOptionHidden:YES];
    }
}

- (void)resizeScrollView {
    [self.container sizeToFit];
    ((UIScrollView *)self.view).contentSize = self.container.bounds.size;
}
@end
