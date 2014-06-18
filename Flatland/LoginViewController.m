//
//  LoginViewController.m
//  Flatland
//
//  Created by Stefan Aust on 14.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "AlertView.h"
#import "WaitIndicator.h"
#import "LostPasswordViewController.h"
#import "NotificationCenter.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set the textfield delegates
    self.email.delegate = self;
    self.password.delegate = self;
    
    //set the email if we have an account from device storage
    self.email.text = [User activeUser].email;
    self.screenName = @"Login Screen";
}

#pragma mark - UITextFieldDelegate

// advance to next text field on RETURN
-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    if ([self.email isFirstResponder]) {
        [self.password becomeFirstResponder];
    } else {
        [self.password resignFirstResponder];
        [self doLogin];
    }
    return YES;
}

#pragma mark - Actions

- (IBAction)doLogin {
    [self.view endEditing:YES];
    
    //validate email
    if(IsEmpty(self.email.text) || !ValidateEmailAddress(self.email.text)) {
        [[AlertView alertViewFromString:T(@"%login.alert.validEmail") buttonClicked:nil] show];
        return;
    }
    
    //validate password
    if(IsEmpty(self.password.text)) {
        [[AlertView alertViewFromString:T(@"%login.alert.validPassword") buttonClicked:nil] show];
        return;
    }
    
    //everything is fine - do the login
    LoginData *login = [LoginData new];
    login.email = self.email.text;
    login.password = self.password.text;
    login.deviceToken = [[NotificationCenter sharedCenter] deviceToken];
    
    [WaitIndicator waitOnView:self.view];
    
    [User login:login completion:^(BOOL success) {
        
        if (success) {
            //use the now active account and load the babies.
            [[User activeUser] loadBabies:^(BOOL success) {
                [self.view stopWaiting];
                if (success) {
                    //if we have babies enter directly into the app
                    if ([[User activeUser].babies count] > 0) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    } else { //otherwise go to the baby profile page and create some babies
                        [[User activeUser] loadPersonalInformation:^(Address *personalAddress) {
                            if([[User activeUser] pregnant]) {
                                [self dismissViewControllerAnimated:YES completion:nil];
                            } else {
                                [self performSegueWithIdentifier:@"createProfilesLogin" sender:self];
                            }
                        }];
                    }
                } else {
                    [[AlertView alertViewFromString:T(@"%login.alert.noBabies") buttonClicked:nil] show];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        } else {
            [self.view stopWaiting];
            [[AlertView alertViewFromString:T(@"%login.alert.authorization") buttonClicked:nil] show];
        }
    }];
    
}

@end
