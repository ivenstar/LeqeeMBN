//
//  WifiVerifyAddressViewController.m
//  Flatland
//
//  Created by Stefan Aust on 21.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WifiVerifyAddressViewController.h"
#import "WifiAddDeliveryAddressViewController.h"
#import "FlatTextField.h"
#import "FlatRadioButtonGroup.h"
#import "User.h"
#import "FlatCheckbox.h"
#import "WaitIndicator.h"
#import "AlertView.h"

#ifdef BABY_NES_US
#import "State.h"
#endif //BABY_NES_US

@interface WifiVerifyAddressViewController ()

@property (weak, nonatomic) IBOutlet FlatRadioButtonGroup *salutationBtnGroup;
@property (weak, nonatomic) IBOutlet FlatTextField *firstNameField;
@property (weak, nonatomic) IBOutlet FlatTextField *lastNameField;
@property (weak, nonatomic) IBOutlet FlatTextField *streetNoField;
@property (weak, nonatomic) IBOutlet FlatTextField *additionalInformationField;
@property (weak, nonatomic) IBOutlet FlatTextField *plzField;
@property (weak, nonatomic) IBOutlet FlatTextField *cityField;
@property (weak, nonatomic) IBOutlet FlatTextField *mobileNumberField;
@property (weak, nonatomic) IBOutlet FlatTextField *stateField;
@property (weak, nonatomic) IBOutlet FlatCheckbox *differentBillingDeliveryAddressField;
@property (weak, nonatomic) IBOutlet UIView *containterView;

@property (nonatomic, strong) Address *userAddress;


@end

@implementation WifiVerifyAddressViewController{
    ValidationManager *_validationManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef BABY_NES_US
    [_containterView setCenter:CGPointMake(_containterView.center.x, _containterView.center.y + 38)];
    [_stateField setHidden:NO];
    
    _statePicker = [[UIPickerView alloc] init];
    
    UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    accessoryView.barStyle = UIBarStyleBlackTranslucent;
    accessoryView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDonePressed)];
    UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    accessoryView.items = [NSArray arrayWithObjects:flexibleSpace, doneButton, nil];
    
    _statePicker.delegate = self;
    _statePicker.showsSelectionIndicator = YES;
    
    _pos = 0;
    self.stateField.text = [[StatesUSJSON() objectAtIndex:0] name];
    
    //add salutation for mrs
    FlatRadioButtonGroup *newGroup = [[FlatRadioButtonGroup alloc] initWithFrame:[_salutationBtnGroup frame]];
    
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
    
    UIView* salutationSuperView = [_salutationBtnGroup superview];
    [_salutationBtnGroup removeFromSuperview];
    _salutationBtnGroup = newGroup;
    [salutationSuperView addSubview:newGroup];
    
#endif //BABY_NES_US
    
    [[User activeUser] loadPersonalInformation:^(Address *userAddress) {
        self.userAddress = userAddress;
        
#ifdef BABY_NES_US
        switch (userAddress.title)
        {
            case AddressTitleMadam:
                self.salutationBtnGroup.selectedIndex = 0;
                break;
            case AddressTitleMisses:
                self.salutationBtnGroup.selectedIndex = 1;
                break;
            case AddressTitleMister:
                self.salutationBtnGroup.selectedIndex = 2;
                break;
            default:
                break;
        }
#else
        self.salutationBtnGroup.selectedIndex = userAddress.title == AddressTitleMadam ? 0 : 1;
#endif //BABY_NES_US
        
        self.firstNameField.text = userAddress.firstName;
        self.lastNameField.text = userAddress.lastName;
        
        self.streetNoField.text = userAddress.street;
        self.plzField.text = userAddress.ZIP;
        self.cityField.text = userAddress.city;
        self.additionalInformationField.text = userAddress.streetExtra;
        self.mobileNumberField.text = userAddress.mobile;
    }];
    
    //setup validation
    _validationManager = [[ValidationManager alloc] initWithMessageKeyPrefix:@"%register."];
    
    [_validationManager addRequiredValidatorForField:self.salutationBtnGroup errorMessageKey:@"Salutation NotValid"];
    
    [_validationManager addRequiredValidatorForField:self.streetNoField errorMessageKey:@"Street NotValid"];
    
    if ([kValidCountryCodes rangeOfString:@"ch"].location != NSNotFound) {
        [_validationManager addLengthValidatorForField:self.plzField minLength:4 maxLength:4 errorMessageKey:@"ZIP NotValid"];
    }else{
        [_validationManager addLengthValidatorForField:self.plzField minLength:5 maxLength:5 errorMessageKey:@"ZIP NotValid"];
    }
    
    [_validationManager addRequiredValidatorForField:self.cityField errorMessageKey:@"City NotValid"];
    
    [_validationManager addNameValidatorForField:self.firstNameField maxLength:25 errorMessageKey:@"FirstName NotValid"];
    [_validationManager addNameValidatorForField:self.lastNameField maxLength:35 errorMessageKey:@"LastName NotValid"];

    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:T(@"%general.cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(doneWithNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:T(@"%general.ok") style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    _mobileNumberField.inputAccessoryView = numberToolbar;
}

- (IBAction)performSequeIfValid {
    [self.view endEditing:YES];
    if (![_validationManager validate]) {
        return;
    }

#ifdef BABY_NES_US
    switch (self.salutationBtnGroup.selectedIndex)
    {
        case 0:
            self.userAddress.title = AddressTitleMadam;
            break;
        case 1:
            self.userAddress.title = AddressTitleMisses;
            break;
        case 2:
            self.userAddress.title = AddressTitleMister;
            break;
        default:
            break;
    }
#else
        self.userAddress.title = self.salutationBtnGroup.selectedIndex == 0 ? AddressTitleMadam : AddressTitleMister;
#endif //BABY_NES_US
    
    
    
    self.userAddress.firstName = self.firstNameField.text;
    self.userAddress.lastName = self.lastNameField.text;
    self.userAddress.street = self.streetNoField.text;
    self.userAddress.streetExtra = self.additionalInformationField.text;
    self.userAddress.ZIP = self.plzField.text;
    self.userAddress.city = self.cityField.text;
    self.userAddress.mobile = self.mobileNumberField.text;
    
#ifdef BABY_NES_US
    self.userAddress.state = [(State*)[StatesUSJSON() objectAtIndex:_pos] code];
#endif //BABY_NES_US
    
    [WaitIndicator waitOnView:self.view];
    
    [[User activeUser] updatePersonalInformation:self.userAddress oldPassword:nil newPassword:nil email:[User activeUser].email completion:^(BOOL success, NSString *errorMessage) {
        [self.view stopWaiting];
        if (success) {
            if (self.differentBillingDeliveryAddressField.selected) {
                [self performSegueWithIdentifier:@"configureDeliveryAddress" sender:self];
            } else {
                [self performSegueWithIdentifier:@"configurePayment" sender:self];
            }
        } else {
            [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
        }
    }];

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WifiBaseViewController *vc = segue.destinationViewController;
    if([[[User activeUser] wifiOrderOption] isEqualToString:@"Automatic"]) {
        vc.wifiOption = 1;
    } else if([[[User activeUser] wifiOrderOption] isEqualToString:@"QuickOrder"]) {
        vc.wifiOption = 2;
    } else if([[[User activeUser] wifiOrderOption] isEqualToString:@"TrackerOnly"]) {
        vc.wifiOption = 3;
    }
}

-(void)doneWithNumberPad{
    [_mobileNumberField resignFirstResponder];
}


#ifdef BABY_NES_US

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


#endif//BABY_NES_US

@end
