//
//  RegisterViewController.m
//  Flatland
//
//  Created by Stefan Aust on 14.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "RegisterViewController.h"
#import "User.h"
#import "AlertView.h"
#import "FlatRadioButtonGroup.h"
#import "FlatTextField.h"
#import "FlatCheckbox.h"
#import "FlatButton.h"
#import "WebViewViewController.h"
#import "WaitIndicator.h"
#import "GradientView.h"
#import "CalendarPopupView.h"
#import "BabyNesPhoneTextField.h"

static NSDateFormatter *sbirthdayFormatter = nil;

@interface RegisterViewController () <UITextFieldDelegate, CalendarPopupViewDelegate>
{
    int sizeDif;
}
@property (weak, nonatomic) IBOutlet FlatTextField *email;
@property (weak, nonatomic) IBOutlet FlatTextField *emailConfirm;
@property (weak, nonatomic) IBOutlet FlatTextField *password;
@property (weak, nonatomic) IBOutlet FlatTextField *passwordConfirm;
@property (weak, nonatomic) IBOutlet BabyNesPhoneTextField *phoneNumber;
@property (weak, nonatomic) IBOutlet FlatTextField *firstName;
@property (weak, nonatomic) IBOutlet FlatTextField *lastName;
@property (weak, nonatomic) IBOutlet FlatRadioButtonGroup *salutation;
@property (weak, nonatomic) IBOutlet FlatCheckbox *checkboxA;
@property (weak, nonatomic) IBOutlet FlatCheckbox *checkboxB;
@property (weak, nonatomic) IBOutlet FlatCheckbox *checkboxC;

@property (weak, nonatomic) IBOutlet FlatTextField *dateOfBirth;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property (weak, nonatomic) IBOutlet FlatCheckbox *pregnantConfirm;
@property (weak, nonatomic) IBOutlet UILabel *pregnantLabel;

@property (nonatomic, strong) CalendarPopupView *calenderView;
@property (nonatomic, copy) NSDate *currentSelectedDate;
@property (weak, nonatomic) IBOutlet UIButton *privacyButton;
@property (weak, nonatomic) IBOutlet FlatButton *registerButton;
@property (weak, nonatomic) IBOutlet UILabel *newsletterBabyNesButton;
@property (weak, nonatomic) IBOutlet UILabel *newsletterAllButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *acceptPrivacyLabel;
@property (weak, nonatomic) IBOutlet GradientView *gradientView;


- (IBAction)togglePregnant:(id)sender;

@end

@implementation RegisterViewController {
    ValidationManager *_validationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// set all the delegates
    self.email.delegate = self;
    self.emailConfirm.delegate = self;
    self.password.delegate = self;
    self.passwordConfirm.delegate = self;
    self.firstName.delegate = self;
    self.lastName.delegate = self;
    self.phoneNumber.delegate = self;
    [_dateOfBirth setHidden:YES];
    [_dateOfBirthLabel setHidden:YES];
    self.calenderView = [CalendarPopupView calendarViewWith:[NSDate date] calender:[NSCalendar currentCalendar]];
    self.calenderView.view.frame = CGRectMake(0, 5, 320, 255);
    self.calenderView.delegate = self;
    self.dateOfBirth.inputView = self.calenderView.view;
    
    if (sbirthdayFormatter == nil) {
        sbirthdayFormatter = [[NSDateFormatter alloc] init];
        [sbirthdayFormatter setDateFormat:T(@"%general.dateFormat")];
    }
    
    
#ifndef ADD_NEWSLETTER_ALL
    //hide last checkbox
    [_checkboxC removeFromSuperview];
    
    [_privacyButton setCenter:CGPointMake(_privacyButton.center.x, _privacyButton.center.y - 15)];
    [_registerButton setCenter:CGPointMake(_registerButton.center.x , _registerButton.center.y - 15)];
#endif //ADD_NEWSLETTER_ALL
    
    
//  Fit text to privacy labels
//  Fixes BNM-626
    CGFloat originalHeight = 0;
    CGFloat newHeight = 0;
    
    NSArray* checkViews = [NSArray arrayWithObjects:self.acceptPrivacyLabel,self.checkboxA,
                                                    self.newsletterBabyNesButton,self.checkboxB,
#ifdef ADD_NEWSLETTER_ALL
                                                    self.newsletterAllButton,self.checkboxC,
#endif //ADD_NEWSLETTER_ALL
                                                    nil];
    
    //see what views are bellow the last label so that we could move them afterwards
    NSMutableArray* viewsToShiftDownAfterResize = [[NSMutableArray alloc] init];
    for (UIView* view in self.contentView.subviews)
    {
        if (view.frame.origin.y > self.newsletterAllButton.frame.origin.y)
        {
            [viewsToShiftDownAfterResize addObject:view];
        }
    }
    
    //do the actual resizing
    for (int i=0;i<[checkViews count];i+=2)
    {
        UILabel *currentLabel = (UILabel*)[checkViews objectAtIndex:i];
        originalHeight += currentLabel.frame.size.height;
        
        //fit the text to the label
        [currentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [currentLabel setTextAlignment:NSTextAlignmentLeft];
        [currentLabel sizeToFit];
        
        //check for a min frame
#define LOGIN_CHECK_FIELDS_MIN_HEIGHT 25
        if (currentLabel.frame.size.height < LOGIN_CHECK_FIELDS_MIN_HEIGHT)
        {
            CGRect newFrame = currentLabel.frame;
            newFrame.size.height = LOGIN_CHECK_FIELDS_MIN_HEIGHT;
            currentLabel.frame = newFrame;
        }
        
        newHeight += currentLabel.frame.size.height;
        
        //add 10p between the last label frame and the current one
        if (i >= 2)
        {
            CGRect frame = currentLabel.frame;
            UILabel* previousLabel = (UILabel*)[checkViews objectAtIndex:i-2];
            frame.origin.y = previousLabel.frame.origin.y + previousLabel.frame.size.height + 10;
            currentLabel.frame = frame;
        }
        
        //move the checkbox to the same center as the label
        FlatCheckbox* checkBox = (FlatCheckbox*)[checkViews objectAtIndex:i+1];
        CGPoint checkBoxCenter = checkBox.center;
        checkBoxCenter.y = currentLabel.center.y;
        checkBox.center = checkBoxCenter;
    }
    
    //now move all the views bellow the last label down with newH - oldH +10
    CGFloat heightDifference = newHeight - originalHeight + 10;
    for (UIView* view in viewsToShiftDownAfterResize)
    {
        CGRect frame = view.frame;
        frame.origin.y += heightDifference;
        view.frame = frame;
    }
    
    
    //and make all the superviews bigger
    NSArray* superViews = [NSArray arrayWithObjects:self.contentView,self.gradientView,self.formScrollView, nil];
    for (UIView* view in superViews)
    {
        [view setFrame:CGRectMake(view.frame.origin.x,
                                  view.frame.origin.y,
                                  view.frame.size.width,
                                  view.frame.size.height + heightDifference)];
    }
    
    sizeDif -= heightDifference;
//  END - Fit text to privacy labels
    
#ifndef USE_PREGNANT_LABEL
    //remove the views
    [self.pregnantConfirm removeFromSuperview];
    [self.pregnantLabel removeFromSuperview];
    [self.dateOfBirthLabel removeFromSuperview];
    [self.dateOfBirth removeFromSuperview];
    
    
    NSMutableArray *viewsToMoveUp = [NSMutableArray arrayWithObjects:self.checkboxA, self.checkboxB, self.checkboxC, self.acceptPrivacyLabel, self.newsletterAllButton,self.newsletterBabyNesButton, self.registerButton,self.privacyButton, nil];
    //move the other views up
    
    for (UIView *view in viewsToMoveUp)
    {
        [view setCenter:CGPointMake(view.center.x, view.center.y - 25)];
    }
    
    //make content view and scroll view smaller
//    [self.contentView setFrame:CGRectMake(self.contentView.frame.origin.x,
//                                          self.contentView.frame.origin.y,
//                                          self.contentView.frame.size.width,
//                                          self.contentView.frame.size.height - 0)]; //bchitu: if we want to make the content view smaller we should make the gradient view smaller.Leaving it like it is
    [self.formScrollView setFrame:CGRectMake(self.formScrollView.frame.origin.x,
                                             self.formScrollView.frame.origin.y,
                                             self.formScrollView.frame.size.width,
                                             self.formScrollView.frame.size.height - 25)];
    
    sizeDif += 25;
    
#endif //!USE_PREGNANT_LABEL
    
#ifdef BABY_NES_US
    //    [self hidePregnantField];
    
    //swap register with privacy
    CGRect temp = _privacyButton.frame;
    [_privacyButton setFrame:_registerButton.frame];
    [_registerButton setFrame:temp];
    
    //check newsletter buttons
//    [_checkboxC setOn:YES];
    [_checkboxB setOn:YES];
    
    //add salutation for mrs
    FlatRadioButtonGroup *newGroup = [[FlatRadioButtonGroup alloc] initWithFrame:[_salutation frame]];
    
    UIButton *button;
    button = [[UIButton alloc] init];
    [button setTitle:@"%profile.miss" forState:UIControlStateNormal];
    [newGroup addButton:button];
    button = [[UIButton alloc] init];
    [button setTitle:@"%profile.title.f" forState:UIControlStateNormal];
    [newGroup addButton:button];
    button = [[UIButton alloc] init];
    [button setTitle:@"%profile.mister" forState:UIControlStateNormal];
    [newGroup addButton:button];
    
    UIView* salutationSuperView = [_salutation superview];
    [_salutation removeFromSuperview];
    _salutation = newGroup;
    [salutationSuperView addSubview:newGroup];
    
    
    //hide last checkbox
    [_checkboxC removeFromSuperview];
    
    [_privacyButton setCenter:CGPointMake(_privacyButton.center.x, _privacyButton.center.y - 15)];
    [_registerButton setCenter:CGPointMake(_registerButton.center.x , _registerButton.center.y - 15)];
    

   
#endif //BABY_NES_US
    
    //setup validation
    _validationManager = [[ValidationManager alloc] initWithMessageKeyPrefix:@"%register."];
    
    [_validationManager addRequiredValidatorForField:self.salutation errorMessageKey:@"Salutation NotValid"];
    
    [_validationManager addNameValidatorForField:self.firstName maxLength:25 errorMessageKey:@"FirstName NotValid"];
    [_validationManager addNameValidatorForField:self.lastName maxLength:35 errorMessageKey:@"LastName NotValid"];
    
    [_validationManager addEmailValidatorForField:self.email errorMessageKey:@"Email NotValid"];
    [_validationManager addEmailValidatorForField:self.email errorMessageKey:@"Email EmailAddressAlreadyExists"];
    [_validationManager addConfirmationValidatorForField:self.emailConfirm sourceField:self.email errorMessageKey:@"EmailConfirm NotValid"];
    
    [_validationManager addLengthValidatorForField:self.password minLength:8 maxLength:15 errorMessageKey:@"Password NotValid"];
    [_validationManager addConfirmationValidatorForField:self.passwordConfirm sourceField:self.password errorMessageKey:@"PasswordConfirm NotValid"];
    
    FlatTextField* mobileTextField = self.phoneNumber;
    [_validationManager addValidatorForField:self.phoneNumber errorMessageKey:@"mobile" validator:^BOOL(id<ValidatableField> checkField)
     {
         return IsPhoneNumberValid(mobileTextField.text);
     }];

    [_validationManager addRequiredValidatorForField:self.checkboxA errorMessageKey:@"Terms NotValid"];
    
    [_validationManager addValidatorForField:self.dateOfBirth errorMessageKey:@"Birthday NotValid" validator:^BOOL(id<ValidatableField> checkField) {
        if(((FlatTextField*)checkField).hidden) {
            return YES;
        }
        NSString *buf = ((UITextField *)checkField).text;
        NSString *text = [NSString stringWithFormat:@"%@", buf];
        if(!text) text = @"";
        NSDateFormatter *birthdayFormatter = [NSDateFormatter new];
        [birthdayFormatter setDateFormat:T(@"%general.dateFormat")];
        NSDate *date = [birthdayFormatter dateFromString:text];
        if([date compare:[NSDate date]] == NSOrderedAscending) {
            return NO;
        }
        return YES && text.length > 0;
    }];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:T(@"%general.cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(doneWithNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:T(@"%general.ok") style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    _phoneNumber.inputAccessoryView = numberToolbar;
    
    [self.privacyButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.privacyButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];

}

- (void) hidePregnantField
{
    [_pregnantConfirm setHidden:YES];
    [_pregnantLabel setHidden:YES];
    
    for (UIView* view in self.contentView.subviews)
    {
        [view setCenter:CGPointMake(view.center.x, view.center.y - 20)];
    }
    
    [_contentView setFrame:CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height - 50)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.formScrollView.contentSize = CGSizeMake(320, 640 - sizeDif);
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
//    [self.privacyButton.titleLabel setFont:[UIFont regularFontOfSize:10]];
}

#pragma mark - UITextFieldDelegate

// advance to next text field on RETURN
-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    if ([self.firstName isFirstResponder]) {
        [self.lastName becomeFirstResponder];
    } else if ([self.lastName isFirstResponder]) {
        [self.email becomeFirstResponder];
    } else if ([self.email isFirstResponder]) {
        [self.emailConfirm becomeFirstResponder];
    } else if ([self.emailConfirm isFirstResponder]) {
        [self.password becomeFirstResponder];
    } else if ([self.password isFirstResponder]) {
        [self.passwordConfirm becomeFirstResponder];
    } else if ([self.passwordConfirm isFirstResponder]) {
        [self.phoneNumber becomeFirstResponder];
    } else if ([self.phoneNumber isFirstResponder]) {
        [self.phoneNumber resignFirstResponder];
    }

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.dateOfBirth isEqual:textField])
    {
        return NO;
    }
    else if (self.phoneNumber == textField)
    {
        return MobileShouldChangeCharactersInRange(textField, range, string);
    }
    return YES;
    
}

#pragma mark - CalendarViewDelegate

- (void)calenderView:(CalendarPopupView *)calenderView didSelectDate:(NSDate *)date {
    [self.dateOfBirth resignFirstResponder];
    self.currentSelectedDate = date;
    self.dateOfBirth.text = [sbirthdayFormatter stringFromDate:date];
}

#pragma mark - Actions

- (IBAction)doRegister {
    [self.view endEditing:YES];
    
    if (![_validationManager validate]) {
        return;
    }
    
    [WaitIndicator waitOnView:self.view];
    
    RegistrationData *data = [RegistrationData new];
    
    data.email = self.email.text;
    data.password = self.password.text;
    data.firstName = self.firstName.text;
    data.lastName = self.lastName.text;
    data.phone = self.phoneNumber.text;
    
#ifdef BABY_NES_US
    switch (self.salutation.selectedIndex)
    {
        case 0:
            data.salutation = @"Ms";
            break;
        case 1:
            data.salutation = @"Mrs";
            break;
        case 2:
            data.salutation = @"Mr";
            break;
        default:
            break;
    }
#else
    data.salutation = self.salutation.selectedIndex == 0 ? @"Ms" : @"Mr";
#endif //BABY_NES_US
    
    data.acceptNewsletter = self.checkboxB.isOn;
#if !defined(BABY_NES_US) || defined(ADD_NEWSLETTER_ALL)
    data.acceptNestleNewsletter = self.checkboxC.isOn;
#else
    data.acceptNestleNewsletter = NO;
#endif //!BABY_NES_US || ADD_NEWSLETTER_ALL
    
    if(data.acceptNestleNewsletter){
        data.optLevel = @"F";
    }else{
        data.optLevel = @"C";
    }
    if(_pregnantConfirm.isSelected) {
        data.dateOfBirth = self.currentSelectedDate;
    }

    [User register:data completion:^(BOOL success, NSArray *errors) {
        [self.view stopWaiting];
        if (success) {
            if(_pregnantConfirm.isSelected) {
                [User activeUser].pregnant = YES;
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self performSegueWithIdentifier:@"createProfilesRegistration" sender:self];
            }
        } else {
            if ([errors count] == 0 || ![_validationManager showValidationErrors:errors]) {
                [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
            }
        }
    }];
}

#pragma mark - Helpers

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"privacyWebView"]) {
        WebViewViewController *vc = (WebViewViewController *)segue.destinationViewController;
        vc.viewName = T(@"%menu.information.privacy.html");
    }
}

- (IBAction)togglePregnant:(id)sender {
    if(_pregnantConfirm.isSelected) {
        [_dateOfBirthLabel setHidden:NO];
        [_dateOfBirth setHidden:NO];
    } else {
        [_dateOfBirthLabel setHidden:YES];
        [_dateOfBirth setHidden:YES];
    }
}

-(void)doneWithNumberPad{
    [_phoneNumber resignFirstResponder];
}

@end
