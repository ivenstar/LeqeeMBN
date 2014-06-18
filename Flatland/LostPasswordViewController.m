//
//  LostPasswordViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 21.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "LostPasswordViewController.h"
#import "AlertView.h"
#import "User.h"
#import "WaitIndicator.h"

@interface LostPasswordViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *email;

@end

@implementation LostPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.email.delegate = self;
    self.email.text = self.emailToRecover;
    self.screenName = @"Password Recover Screen";
}

#pragma mark - UITextFieldDelegate

// advance to next text field on RETURN
-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    if ([self.email isFirstResponder]) {
        [self doRecover];
    }
    return YES;
}

#pragma mark - Actions
- (IBAction) doRecover {
    [self.view endEditing:YES];
    
    //validate email
    if(IsEmpty(self.email.text) || !ValidateEmailAddress(self.email.text)) {
        [[AlertView alertViewFromString:T(@"%login.alert.validEmail") buttonClicked:nil] show];
        return;
    }
    [WaitIndicator waitOnView:self.view];

    [User recoverPasswordForEmail:self.email.text completion:^(BOOL success)
    {
        [self.view stopWaiting];
        [[AlertView alertViewFromString:T(@"%forgot.requestFinished") buttonClicked:nil] show];
    }];
}
@end

























