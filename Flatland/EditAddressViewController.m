//
//  EditAddressViewController.m
//  Flatland
//
//  Created by Stefan Aust on 27.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "EditAddressViewController.h"
#import "FlatRadioButtonGroup.h"
#import "FlatTextField.h"
#import "ValidationManager.h"
#import "User.h"
#import "OverlaySaveView.h"
#import "AlertView.h"

@interface EditAddressViewController ()

@property (nonatomic, weak) IBOutlet UILabel *headerLabel;
@property (nonatomic, weak) IBOutlet FlatRadioButtonGroup *titleRadioButtonGroup;
@property (nonatomic, weak) IBOutlet FlatTextField *firstNameField;
@property (nonatomic, weak) IBOutlet FlatTextField *lastNameField;
@property (nonatomic, weak) IBOutlet FlatTextField *streetField;
@property (nonatomic, weak) IBOutlet FlatTextField *streetExtraField;
@property (nonatomic, weak) IBOutlet FlatTextField *ZIPField;
@property (nonatomic, weak) IBOutlet FlatTextField *cityField;
@property (nonatomic, weak) IBOutlet FlatTextField *mobileField;
@property (weak, nonatomic) IBOutlet UINavigationItem *header;

@end

#pragma mark

@implementation EditAddressViewController {
    ValidationManager *_validationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];

#ifdef BABY_NES_US
    //add salutation for mrs
    FlatRadioButtonGroup *newGroup = [[FlatRadioButtonGroup alloc] initWithFrame:[_titleRadioButtonGroup frame]];
    
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
    
    UIView* salutationSuperView = [_titleRadioButtonGroup superview];
    [_titleRadioButtonGroup removeFromSuperview];
    _titleRadioButtonGroup = newGroup;
    [salutationSuperView addSubview:newGroup];
    
#endif //BABY_NES_US
    
    // setup the validation rules for all input fields
    _validationManager = [[ValidationManager alloc] initWithMessageKeyPrefix:@"%address."];
    [_validationManager addRequiredValidatorForField:self.titleRadioButtonGroup errorMessageKey:@"salutation"];
    [_validationManager addRegExpValidatorForField:self.firstNameField regExp:T(@"regexp.name") errorMessageKey:@"firstName"];
    [_validationManager addRegExpValidatorForField:self.lastNameField regExp:T(@"regexp.name") errorMessageKey:@"lastName"];
    [_validationManager addRegExpValidatorForField:self.streetField regExp:T(@"regexp.street") errorMessageKey:@"street"];
    [_validationManager addRegExpValidatorForField:self.streetExtraField regExp:T(@"regexp.street") errorMessageKey:@"streetExtra"];
    [_validationManager addRegExpValidatorForField:self.cityField regExp:T(@"regexp.city") errorMessageKey:@"city"];
    
    FlatTextField* mobileTextField = self.mobileField;
    [_validationManager addValidatorForField:self.mobileField errorMessageKey:@"mobile" validator:^BOOL(id<ValidatableField> checkField)
     {
         return IsPhoneNumberValid(mobileTextField.text);
    }];
    
    [_validationManager addLengthValidatorForField:self.firstNameField minLength:1 maxLength:25 errorMessageKey:@"firstName"];
    [_validationManager addLengthValidatorForField:self.lastNameField minLength:2 maxLength:35 errorMessageKey:@"lastName"];
    [_validationManager addLengthValidatorForField:self.streetField minLength:1 maxLength:60 errorMessageKey:@"street"];
    [_validationManager addLengthValidatorForField:self.streetExtraField minLength:0 maxLength:60 errorMessageKey:@"streetExtra"];
    if ([kValidCountryCodes rangeOfString:@"ch"].location != NSNotFound) {
        [_validationManager addLengthValidatorForField:self.ZIPField minLength:4 maxLength:4 errorMessageKey:@"zip"];
    }else{
        [_validationManager addLengthValidatorForField:self.ZIPField minLength:5 maxLength:5 errorMessageKey:@"zip"];
    }
    [_validationManager addLengthValidatorForField:self.cityField minLength:1 maxLength:35 errorMessageKey:@"city"];
    
    if(self.mode == AddressModeDeliveryAddress) {
        _headerLabel.text = T(@"%wifi.verifyDelivery");
        _header.title = T(@"%profile.delivery");
    } else {
        _headerLabel.text = T(@"%wifi.verifyBilling");
        _header.title = T(@"%profile.billing");
    }
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:T(@"%general.cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelWithNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:T(@"%general.ok") style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    _mobileField.inputAccessoryView = numberToolbar;
    _ZIPField.inputAccessoryView = numberToolbar;
    
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.streetField.delegate = self;
    self.streetExtraField.delegate = self;
    self.ZIPField.delegate = self;
    self.cityField.delegate = self;
    self.mobileField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    switch (self.mode) {
        case AddressModeDeliveryAddress:
            self.title = T(@"%profile.delivery");
            self.headerLabel.text = T(@"%wifi.checkDelivery");
            break;
        case AddressModeBillingAddress:
            self.title = T(@"%profile.billing");
            self.headerLabel.text = T(@"%wifi.checkBilling");
            break;
        default:
            [NSException raise:@"ProgrammError" format:@"Unsupported address mode"];
    }
    
    
#ifdef BABY_NES_US
    switch (self.address.title) {
        case AddressTitleMadam:
            self.titleRadioButtonGroup.selectedIndex = 0;
            break;
        case AddressTitleMisses:
            self.titleRadioButtonGroup.selectedIndex = 1;
            break;
        case AddressTitleMister:
            self.titleRadioButtonGroup.selectedIndex = 2;
            break;
        default:
            self.titleRadioButtonGroup.selectedIndex = -1;
            break;
    }
#else
    switch (self.address.title) {
        case AddressTitleMadam:
            self.titleRadioButtonGroup.selectedIndex = 0;
            break;
        case AddressTitleMister:
            self.titleRadioButtonGroup.selectedIndex = 1;
            break;
        default:
            self.titleRadioButtonGroup.selectedIndex = -1;
            break;
    }
#endif
    
    
    self.firstNameField.text = self.address.firstName;
    self.lastNameField.text = self.address.lastName;
    self.streetField.text = self.address.street;
    self.streetExtraField.text = self.address.streetExtra;
    self.ZIPField.text = self.address.ZIP;
    self.cityField.text = self.address.city;
    self.mobileField.text = self.address.mobile;
    
    
}

- (UITextField*) getFirstResponderWithNumPad
{
    NSArray* textFieldsWithNumberPad = [NSArray arrayWithObjects:self.ZIPField,self.mobileField, nil];
    
    for (UITextField *responder in textFieldsWithNumberPad)
    {
        if([responder isFirstResponder])
        {
            return responder;
        }
    }
    
    return nil;
}

-(void)cancelWithNumberPad
{
    UITextField* firstResponder = [self getFirstResponderWithNumPad];
    
    [[firstResponder undoManager] undo];
    [firstResponder resignFirstResponder];
}


-(void)doneWithNumberPad{
    UITextField* firstResponder = [self getFirstResponderWithNumPad];
    
    [firstResponder resignFirstResponder];
    
    if (firstResponder)
        [self textFieldShouldReturn:firstResponder];
}

#pragma mark - Actions

- (IBAction)save {
    if (![_validationManager validate]) {
        [[AlertView alertViewFromString:T(@"%general.alert.entries") buttonClicked:nil] show];
        return;
    }
    
    // setup the new address object
    Address *address = self.address;
    address.firstName = self.firstNameField.text;
    address.lastName = self.lastNameField.text;
    address.street = self.streetField.text;
    address.streetExtra = self.streetExtraField.text;
    address.ZIP = self.ZIPField.text;
    address.city = self.cityField.text;
    address.mobile = self.mobileField.text;
    
#ifdef BABY_NES_US
    switch (self.titleRadioButtonGroup.selectedIndex)
    {
        case 0:
            address.title = AddressTitleMadam;
            break;
        case 1:
            address.title = AddressTitleMisses;
            break;
        case 2:
            address.title = AddressTitleMister;
            break;
        default:
            break;
    }
#else
    self.address.title = self.titleRadioButtonGroup.selectedIndex == 1 ? AddressTitleMister : AddressTitleMadam;
#endif
    
    // save the address and dismiss screen on success
    switch (self.mode) {
        case AddressModeDeliveryAddress: {
            [[User activeUser] updateDeliveryAddress:address completion:^(BOOL success) {
                if (success) {
                    [User activeUser].preferredDeliveryAddressID = address.ID;
                    [OverlaySaveView showOverlayWithMessage:T(@"%general.added") afterDelay:1 performBlock:^{
                        [self dismiss];
                    }];
                }
            }];
            break;
        }
        case AddressModeBillingAddress: {
            [[User activeUser] updateBillingAddress:address completion:^(BOOL success) {
                if (success) {
                    [User activeUser].preferredBillingAddressID = address.ID;
                    [OverlaySaveView showOverlayWithMessage:T(@"%general.added") afterDelay:1 performBlock:^{
                        [self dismiss];
                    }];
                }
            }];
            break;
        }
        default:
            [NSException raise:@"ProgrammError" format:@"Unsupported address mode"];
    }
}

#pragma mark - textfielddelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return MobileShouldChangeCharactersInRange(textField, range, string);
}

// advance to next text field on RETURN
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag;
    
    UIView* nextResponder = nil;
    do
    {
        nextTag++;
        nextResponder = [textField.superview viewWithTag:nextTag];
    }while (nextResponder != nil && nextResponder.hidden);
    
    if (nextResponder)
    {
        [nextResponder becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return NO;
}

@end
