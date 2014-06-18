//
//  AddAddressViewController.m
//  Flatland
//
//  Created by Stefan Aust on 27.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "AddAddressViewController.h"
#import "User.h"
#import "Address.h"
#import "AlertView.h"
#import "State.h"
#import "WaitIndicator.h"

#pragma mark

@interface AddAddressViewController ()

@property (nonatomic,strong) NSArray* viewsBelowStateField;
@property (strong, nonatomic) Country *currentCountry;

@end

@implementation AddAddressViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.firstNameField setDelegate:self];
    [self.lastNameField setDelegate:self];
    [self.streetField setDelegate:self];
    [self.streetExtraField setDelegate:self];
    [self.ZIPField setDelegate:self];
    [self.cityField setDelegate:self];
    [self.mobileField setDelegate:self];
    
    [self.countryPicker setDelegate:self];
    
    _pos = 0;
    _statePicker = [[UIPickerView alloc] init];
    
    UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    accessoryView.barStyle = UIBarStyleBlackTranslucent;
    accessoryView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDonePressed)];
    UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    accessoryView.items = [NSArray arrayWithObjects:flexibleSpace, doneButton, nil];
    
    _statePicker.delegate = self;
    _statePicker.showsSelectionIndicator = YES;
    
    _stateField.inputView = _statePicker;
    _stateField.inputAccessoryView = accessoryView;
    
    self.viewsBelowStateField = [NSArray arrayWithObjects: self.mobileField,self.mobileIconImageView ,self.registerButton,self.countryPicker, nil];
    
#ifdef BABY_NES_US
    _pos = 0;
    self.stateField.text = [(State*)[StatesUSJSON() objectAtIndex:_pos] name];

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
    
    NSArray* countries = CountriesJSON();
    for(int i=0;i<[countries count];i++)
    {
        Country *country = [countries objectAtIndex:i];
        if ([[country code] isEqualToString:@"US"])
        {
            [self.countryPicker setSelectedCountry:country];
            break;
        }
    }

#else
    [self setStateFieldHidden:YES];

#endif //BABY_NES_US
    
    // setup the validation rules for all input fields
    _validationManager = [[ValidationManager alloc] initWithMessageKeyPrefix:@"%address."];
    [_validationManager addRequiredValidatorForField:self.titleRadioButtonGroup errorMessageKey:@"salutation"];
    
    [_validationManager addRegExpValidatorForField:self.firstNameField regExp:T(@"regexp.firstname") errorMessageKey:@"firstName"];
    [_validationManager addRegExpValidatorForField:self.lastNameField regExp:T(@"regexp.lastname") errorMessageKey:@"lastName"];
   // [_validationManager addLengthValidatorForField:self.firstNameField minLength:1 maxLength:25 errorMessageKey:@"firstName"];  // validates only for last one
   // [_validationManager addLengthValidatorForField:self.lastNameField minLength:2 maxLength:35 errorMessageKey:@"lastName"];
    
    
    [_validationManager addRegExpValidatorForField:self.streetField regExp:T(@"regexp.street") errorMessageKey:@"street"];
    [_validationManager addRegExpValidatorForField:self.streetExtraField regExp:T(@"regexp.street") errorMessageKey:@"streetExtra"];
    [_validationManager addRegExpValidatorForField:self.cityField regExp:T(@"regexp.city") errorMessageKey:@"city"];
    
    
    BabyNesPhoneTextField* mobileTextField = self.mobileField;
    [_validationManager addValidatorForField:self.mobileField errorMessageKey:@"mobile" validator:^BOOL(id<ValidatableField> checkField)
    {
        return IsPhoneNumberValid(mobileTextField.text);
    }];
    
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
        _header.title  = T(@"%profile.billing");
    }
    
    [[User activeUser] loadPersonalInformation:^(Address *personalAddress) {
        _userAddress = personalAddress;
        _firstNameField.text = _userAddress.firstName;
        _lastNameField.text = _userAddress.lastName;

#ifdef BABY_NES_US
        if(_userAddress.title == AddressTitleMister)
        {
            _titleRadioButtonGroup.selectedIndex = 2;
        }
        else if (_userAddress.title == AddressTitleMisses)
        {
            _titleRadioButtonGroup.selectedIndex = 1;
        }
        else
        {
            _titleRadioButtonGroup.selectedIndex = 0;
        }
#else
        if(_userAddress.title == AddressTitleMister)
        {
            _titleRadioButtonGroup.selectedIndex = 1;
        }
        else
        {
            _titleRadioButtonGroup.selectedIndex = 0;
        }
#endif //BABY_NES_US
        
    }];
    
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

}

-(void) setStateFieldHidden: (BOOL) hidden
{
    if (hidden)
    {
        if (![self.stateField isHidden])
        {
            for (UIView* view in self.viewsBelowStateField)
            {
                CGPoint viewCenter = view.center;
                viewCenter.y -= 38;
                view.center = viewCenter;
            }
            [self.stateField setHidden:YES];
        }
    }
    else
    {
        if ([self.stateField isHidden])
        {
            for (UIView* view in self.viewsBelowStateField)
            {
                CGPoint viewCenter = view.center;
                viewCenter.y += 38;
                view.center = viewCenter;
            }
            [self.stateField setHidden:NO];
        }
    }
}

#pragma mark - Actions

- (IBAction)save {
    [self.view endEditing:YES];
 
    if (![_validationManager validate])
        return;
    
    
    // setup the new address object
    Address *address = [Address new];
#ifdef BABY_NES_US
    switch (self.titleRadioButtonGroup.selectedIndex) {
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
    address.title = self.titleRadioButtonGroup.selectedIndex == 1 ? AddressTitleMister : AddressTitleMadam;
#endif//BABY_NES_US
    address.firstName = self.firstNameField.text;
    address.lastName = self.lastNameField.text;
    address.street = self.streetField.text;
    address.streetExtra = self.streetExtraField.text;
    address.ZIP = self.ZIPField.text;
    address.city = self.cityField.text;
    address.mobile = self.mobileField.text;
    
    if (self.countryPicker && !self.countryPicker.hidden)
    {
        address.country = [self.countryPicker.selectedCountry code];
    }
    
    if (self.stateField && !self.stateField.hidden)
    {
        address.state = [(State*)[StatesUSJSON() objectAtIndex:self.pos] code];
    }
    
    // save the address and dismiss screen on success
    [WaitIndicator waitOnView:self.view];
    switch (self.mode) {
        case AddressModeDeliveryAddress: {
            [[User activeUser] addDeliveryAddress:address completion:^(BOOL success) {
                [self.view stopWaiting];
                if (success) {
                    [self didSaveAddress:address];
                }
            }];
            break;
        }
        case AddressModeBillingAddress: {
            [[User activeUser] addBillingAddress:address completion:^(BOOL success) {
                [self.view stopWaiting];
                if (success) {
                    [self didSaveAddress:address];
                }
            }];
            break;
        }
        default:
            [NSException raise:@"ProgrammError" format:@"Unsupported address mode"];

    }
}

- (void)didSaveAddress:(Address *)address {
    switch (self.mode) {
        case AddressModeDeliveryAddress:
            [User activeUser].preferredDeliveryAddressID = address.ID;
            break;
        case AddressModeBillingAddress:
            [User activeUser].preferredBillingAddressID = address.ID;
            break;
        default:
            [NSException raise:@"ProgrammError" format:@"Unsupported address mode"];
    }
    [self dismissWithMessage:T(@"%general.added")];
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

#pragma mark -
#pragma mark PickerView DataSource
- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray* states = StatesUSJSON();
    return [states count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *states = StatesUSJSON();
    State *state = [states objectAtIndex:row];
    
    return [state name];
    
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    _pos = row;
}

- (void)pickerDonePressed
{
    NSArray *states = StatesUSJSON();
    State *state = [states objectAtIndex:_pos];
    _stateField.text = [state name];
    
    [_stateField resignFirstResponder];
}

#pragma mark-
#pragma mark BabyNesCountryPickerDelegate
- (void) picker:(BabyNesCountryPicker*) picker changedCountry: (Country*) country
{
    if (self.currentCountry != country)
    {
        self.currentCountry = country;
        
        //check if us and add or hide the state field
        if ([[[self.currentCountry code] uppercaseString] isEqualToString:@"US"])
        {
            [self setStateFieldHidden:NO];
            self.pos = 0;
            self.stateField.text = [(State*)[StatesUSJSON() objectAtIndex:self.pos] name];
        }
        else
        {
            [self setStateFieldHidden:YES];
        }
    }
}
#pragma mark -

#pragma mark UITextFieldDelegate
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.mobileField)
    {
        NSString* countryCode = kCountryCode;
        if (self.countryPicker && !self.countryPicker.hidden)
        {
           countryCode = [self.countryPicker.selectedCountry code];
        }
        
        return MobileShouldChangeCharactersInRange(textField, range, string);
    }
    
    return YES;
}

#pragma mark -

@end
