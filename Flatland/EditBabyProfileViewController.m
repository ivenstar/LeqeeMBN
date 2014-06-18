//
//  EditBabyProfileViewController.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 12.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "EditBabyProfileViewController.h"
#import "BabyProfileViewController.h"
#import "AlertView.h"
#import "WaitIndicator.h"
#import "FlatButton.h"
#import "User.h"

@interface EditBabyProfileViewController () <BabyProfileViewDelegate>

@property (nonatomic, strong) BabyProfileViewController *babyProfileView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet FlatDarkButton *registerButton;

@end

@implementation EditBabyProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.baby)
    {
        self.deleteButton.hidden = YES;
    }
    else //edit mode
    {
        if ([[[User activeUser] babies] count] == 1) //fixes BNM-634
        {
            self.deleteButton.hidden = YES;
        }
    }
    
    [self setupProfileView];
}
#pragma mark - Actions

- (void) setupProfileView {
    self.babyProfileView = nil;
    UIView *contentView = [self.view.subviews objectAtIndex:0];
    
    self.babyProfileView = [BabyProfileViewController babyProfileViewControllerWithDelegate:self baby:self.baby];
    
    if(!self.baby) {
        UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 60)];
        [label setTextColor:[UIColor colorWithRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha: 1]];
        [label setBackgroundColor:[UIColor clearColor]];
        [self.view changeSystemFontToApplicationFont];
        label.numberOfLines = 0;
        label.text = T(@"%babyProfile.text.intro");
        [label sizeToFit];
        [labelView addSubview:label];
        labelView.backgroundColor = [UIColor clearColor];;
        CGRect newFrame = self.registerButton.frame;
        newFrame.origin.y = 361;
        self.registerButton.frame = newFrame;
        newFrame = self.babyProfileView.view.frame;
        newFrame.origin.y = 61;
        self.babyProfileView.view.frame = newFrame;
        [contentView insertSubview: labelView atIndex:0];
    }
    
    [contentView insertSubview: self.babyProfileView.view atIndex:1];
    self.babyProfileView.actionSheetToolbar = self.navigationController.toolbar;
    UIView *view = self.babyProfileView.view;
    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 465)];
    [self.babyProfileView showRemoveButton:NO];
    [self.babyProfileView setCapsuleSizeOptionHidden:YES];
    [self.babyProfileView setPregnantOptionHidden:YES];
    
    //bchitu quick fix to get the button to work
    [self.registerButton.superview bringSubviewToFront:self.registerButton];
    
    
}

- (IBAction)saveBabyProfile {
    [self.view endEditing:YES];
        
    if(![self.babyProfileView validateFields])
    {
        return;
    }
    
    [WaitIndicator waitOnView:self.view];
    Baby *editBaby = self.babyProfileView.baby;
    [editBaby save:^(BOOL success, NSArray *errors) {
        [self.view stopWaiting];
        if (!success) {
            NSString *message = T(@"%babyProfile.alert.couldNotCreate");
            if(self.baby) {
                message = T(@"%babyProfile.alert.couldNotUpdate");
            }
            [[AlertView alertViewFromString:message buttonClicked:nil] show];
            
            // we were in creation mode - now switch to update mode the new baby has an ID
            if(!self.baby &&  editBaby.ID) {
                self.baby = editBaby;
                [self setupProfileView];
                self.deleteButton.hidden = NO;
            }
            return;
        } else {
           [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    self.baby.isEdited = YES;
    
}
- (IBAction)deleteBabyProfile {
    [self.view endEditing:YES];
    if([self.babyProfileView.baby.ID isEqualToString:@""]) {
    
    }
    [[AlertView alertViewFromString:T(@"%babyProfile.alert.confirmDelete") buttonClicked:^(NSInteger buttonIndex) {
        if(buttonIndex ==0) {
            [WaitIndicator waitOnView:self.view];
            [self.babyProfileView.baby remove:^(BOOL success) {
                [self.view stopWaiting];
                if (!success) {
                    [[AlertView alertViewFromString:T(@"%babyProfile.alert.couldNotDelete") buttonClicked:nil] show];
                    return;
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }] show];
}

#pragma mark - BabyProfileViewDelegate

- (void)presentController:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)removeProfile:(BabyProfileViewController *)babyProfileView {
    //Not needed
}
@end
