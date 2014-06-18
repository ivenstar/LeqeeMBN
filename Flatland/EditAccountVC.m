//
//  EditAccountVC.m
//  Flatland
//
//  Created by Ionel Pascu
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "EditAccountVC.h"
#import "FlatTextField.h"
#import "FlatRadioButtonGroup.h"
#import "User.h"
#import "ValidationManager.h"
#import "WaitIndicator.h"
#import "AlertView.h"
#import "FlatButton.h"
#import "BabyNesPhoneTextField.h"
#import "OverlaySaveView.h"

#ifdef BABY_NES_US
#import "State.h"
#endif //BABY_NES_US

@interface EditAccountVC ()
@property (weak, nonatomic) IBOutlet FlatRadioButtonGroup *salutationBtnGroup;
@property (weak, nonatomic) IBOutlet FlatTextField *firstNameField;
@property (weak, nonatomic) IBOutlet FlatTextField *lastNameField;
@property (weak, nonatomic) IBOutlet FlatTextField *streetNoField;
@property (weak, nonatomic) IBOutlet FlatTextField *additionalInformationField;
@property (weak, nonatomic) IBOutlet FlatTextField *plzField;
@property (weak, nonatomic) IBOutlet FlatTextField *stateField;
@property (weak, nonatomic) IBOutlet FlatTextField *cityField;
@property (weak, nonatomic) IBOutlet FlatTextField *emailField;
@property (weak, nonatomic) IBOutlet FlatTextField *emailConfirmField;
@property (weak, nonatomic) IBOutlet FlatTextField *passwordField;
@property (weak, nonatomic) IBOutlet FlatTextField *passwordConfirmField;
@property (weak, nonatomic) IBOutlet FlatTextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet BabyNesPhoneTextField *mobileNumberField;
@property (weak, nonatomic) IBOutlet UIImageView *emailIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *phoneIconImageVIew;
@property (weak, nonatomic) IBOutlet FlatButton *registerButton;


@property (strong,nonatomic) NSArray *viewsBelowState;

@property (weak, nonatomic) IBOutlet UIView *formContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *formScrollView;
@end

@implementation EditAccountVC {
    ValidationManager *_validationManager;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag;
    
    UIView* nextResponder = nil;
    do
    {
        nextTag++;
        nextResponder = [textField.superview viewWithTag:nextTag];
        int a = nextResponder.hidden;
    }while (nextResponder != nil && nextResponder.hidden);
    
    if (nextResponder)
    {
        [nextResponder becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }

    return NO; // We do not want UITextField to insert line-breaks.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [User activeUser];
    
    
//#ifdef BABY_NES_US
//    [_stateField setHidden:NO];
//    
//    _statePicker = [[UIPickerView alloc] init];
//    
//    UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
//    accessoryView.barStyle = UIBarStyleBlackTranslucent;
//    accessoryView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDonePressed)];
//    UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    accessoryView.items = [NSArray arrayWithObjects:flexibleSpace, doneButton, nil];
//    
//    _statePicker.delegate = self;
//    _statePicker.showsSelectionIndicator = YES;
//    [_statePicker selectRow:_pos inComponent:0 animated:NO];
//    
//    _stateField.inputView = _statePicker;
//    _stateField.inputAccessoryView = accessoryView;
//    
//    CGRect formContainerFrame = self.formContainer.frame;
//    formContainerFrame.size.height += 38;
//    self.formContainer.frame = formContainerFrame;
//#else
//    [_stateField setHidden:YES];
//    
//    for(UIView* view in self.viewsBelowState)
//    {
//        CGPoint viewCenter = view.center;
//        viewCenter.y -= 38;
//        view.center = viewCenter;
//    }
//    
//    CGRect formContainerFrame = self.formContainer.frame;
//    formContainerFrame.size.height -= 38;
//    self.formContainer.frame = formContainerFrame;
//    
//#endif //BABY_NES_US
    
    self.formScrollView.contentSize = self.formContainer.frame.size;
    
    
    [self.mobileNumberField setDelegate:self];
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [WaitIndicator waitOnView:self.view];
    [[User activeUser] loadPersonalInformation:^(Address *personalAddress) {
        [self.view stopWaiting];
        self.userAddress = personalAddress;
        //_dataLoaded = YES;
        //[self.tableView reloadData];
        [self populateForm];        
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self deleteRightBarButtonItem];
    [self icnhLocalizeView];
}

- (void)populateForm {
    self.firstNameField.text = self.userAddress.firstName;
    self.lastNameField.text = self.userAddress.lastName;
    //self.additionalInformationField.text = self.userAddress.streetExtra;
    //self.streetNoField.text = self.userAddress.street;
    //self.plzField.text = self.userAddress.ZIP;
    //self.cityField.text = self.userAddress.city;
    //self.additionalInformationField.text = self.userAddress.streetExtra;
    self.mobileNumberField.text = self.userAddress.mobile;
    
    self.emailField.text = self.user.email;
    
#ifdef BABY_NES_US
    _pos = 0;
    
    self.viewsBelowState = [NSArray arrayWithObjects:self.emailConfirmField, self.emailField,self.emailIconImageView, self.passwordConfirmField,self.passwordField, self.passwordIconImageView,self.oldPasswordField,self.phoneIconImageVIew,self.mobileNumberField,self.registerButton, nil];
    
    NSArray* states = StatesUSJSON();
    for(int i=0;i<[states count];i++)
    {
        State *state = [states objectAtIndex:i];
        if ([[state code] isEqualToString:self.userAddress.state])
        {
            _pos = i;
            break;
        }
    }
    
    self.stateField.text = [[StatesUSJSON() objectAtIndex:_pos] name];
    
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
    
    switch (self.userAddress.title)
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
    self.salutationBtnGroup.selectedIndex = self.userAddress.title == AddressTitleMadam ? 0 : 1;
#endif //BABY_NES_US
    
    //setup validation
    _validationManager = [[ValidationManager alloc] initWithMessageKeyPrefix:@"%register."];
    
    [_validationManager addRequiredValidatorForField:self.salutationBtnGroup errorMessageKey:@"Salutation NotValid"];
    
    //[_validationManager addRequiredValidatorForField:self.streetNoField errorMessageKey:@"Street NotValid"];
    //[_validationManager addRequiredValidatorForField:self.plzField errorMessageKey:@"Plz NotValid"];
    
//    if ([kValidCountryCodes rangeOfString:@"ch"].location != NSNotFound)
//    {
//        [_validationManager addLengthValidatorForField:self.plzField minLength:4 maxLength:4 errorMessageKey:@"ZIP NotValid"];
//    }
//    else
//    {
//        [_validationManager addLengthValidatorForField:self.plzField minLength:5 maxLength:5 errorMessageKey:@"ZIP NotValid"];
//    }
    
    //[_validationManager addRequiredValidatorForField:self.cityField errorMessageKey:@"City NotValid"];
    
    [_validationManager addNameValidatorForField:self.firstNameField maxLength:25 errorMessageKey:@"FirstName NotValid"];
    [_validationManager addNameValidatorForField:self.lastNameField maxLength:35 errorMessageKey:@"LastName NotValid"];
    
    [_validationManager addEmailValidatorForField:self.emailField errorMessageKey:@"Email NotValid"];
    
    
    //only validate confirm-email field if the email was changed
    UITextField *sourceEmailField = self.emailField;
    User *u = self.user;
    [_validationManager addValidatorForField:self.emailConfirmField errorMessageKey:@"EmailConfirm NotValid" validator:^BOOL(id<ValidatableField> checkField) {
        NSString *sourceTxt = sourceEmailField.text;
        return [sourceTxt isEqualToString:u.email] || [((UITextField*)checkField).text isEqualToString:sourceTxt];
    }];
    
    // only validate password if something was added to the text field
    [_validationManager addValidatorForField:self.passwordField errorMessageKey:@"Password NotValid" validator:^BOOL(id<ValidatableField> checkField) {
        NSString *text = ((UITextField *)checkField).text;
        return IsEmpty(text) || ([text length] >= 8 && [text length] <= 15);
    }];
    
    [_validationManager addConfirmationValidatorForField:self.passwordConfirmField sourceField:self.passwordField errorMessageKey:@"PasswordConfirm NotValid"];
    
    // only validate the old password with the password was changed
    UITextField *sourcePasswordField = self.passwordField;
    [_validationManager addValidatorForField:self.oldPasswordField errorMessageKey:@"OldPassword NotValid" validator:^BOOL(id<ValidatableField> checkField) {
        NSString *sourceText = sourcePasswordField.text;
        NSString *text = ((UITextField *)checkField).text;
        return IsEmpty(sourceText) || !IsEmpty(text);
    }];
    
    FlatTextField* mobileField = self.mobileNumberField;
    [_validationManager addValidatorForField:self.mobileNumberField errorMessageKey:@"Mobile NotValid" validator:^BOOL(id<ValidatableField> checkField)
     {
         return IsPhoneNumberValid(mobileField.text);
     }];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:T(@"%general.cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:T(@"%general.ok") style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    _mobileNumberField.inputAccessoryView = numberToolbar;
    
//    UIToolbar* numberToolbarPlz = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
//    numberToolbarPlz.barStyle = UIBarStyleBlackTranslucent;
//    numberToolbarPlz.items = [NSArray arrayWithObjects:
//                              [[UIBarButtonItem alloc]initWithTitle:T(@"%general.cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPadPlz)],
//                              [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                              [[UIBarButtonItem alloc]initWithTitle:T(@"%general.ok") style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadPlz)],
//                              nil];
//    [numberToolbarPlz sizeToFit];
//    _plzField.inputAccessoryView = numberToolbarPlz;
    

}

- (IBAction)doSave {
    [self.view endEditing:YES];
    if (![_validationManager validate]) {
        return;
    }
    
#ifdef BABY_NES_US
    switch (self.self.salutationBtnGroup.selectedIndex) {
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
#endif//BABY_NES_US
    self.userAddress.firstName = self.firstNameField.text;
    self.userAddress.lastName = self.lastNameField.text;
    //self.userAddress.street = self.streetNoField.text;
    //self.userAddress.streetExtra = self.additionalInformationField.text;
    //self.userAddress.ZIP = self.plzField.text;
    //self.userAddress.city = self.cityField.text;
    self.userAddress.mobile = self.mobileNumberField.text;
#ifdef BABY_NES_US
    //self.userAddress.state = [(State*)[StatesUSJSON() objectAtIndex:_pos] code];
    self.userAddress.state = nil;
#endif //BABY_NES_US
    
    // take the old email if nothing changed
    NSString *email = IsEmpty(self.emailConfirmField.text)? self.user.email : self.emailConfirmField.text;
    
    [WaitIndicator waitOnView:self.view];
    
    
//    if ([self.oldPasswordField.text length] == 0 && [self.oldPasswordField.text length] == [self.oldPasswordField.text length])
//    {
//           //bchitu Hack in order to save without introducing a new pass
//    }
    
    [self.user updatePersonalInformation:self.userAddress oldPassword:self.oldPasswordField.text newPassword:self.passwordField.text email:email completion:^(BOOL success, NSString *errorMessage) {
        
        [self.view stopWaiting];
        if (success) {
            //[self.navigationController popViewControllerAnimated:YES];
            [OverlaySaveView showOverlayWithMessage:T(@"%general.modified") afterDelay:2.0f performBlock:^{}];
        } else {
            [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong")  buttonClicked:nil] show];
        }
    }];
}

-(void)doneWithNumberPad{
    [_mobileNumberField resignFirstResponder];
    [self textFieldShouldReturn:_mobileNumberField];
}

-(void)cancelNumberPad{
    [[_mobileNumberField undoManager] undo];
    [_mobileNumberField resignFirstResponder];
}

-(void)doneWithNumberPadPlz{
    [_plzField resignFirstResponder];
    [self textFieldShouldReturn:_plzField];
}

-(void)cancelNumberPadPlz{
    [[_plzField undoManager] undo];
    [_plzField resignFirstResponder];
}

#pragma mark -
#pragma mark TextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.mobileNumberField)
    {
        return MobileShouldChangeCharactersInRange(textField, range, string);
    }
    
    return YES;
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
    [self textFieldShouldReturn:_stateField];
}
#endif//BABY_NES_US
#pragma mark Tab
/// Creates a view suitable as a table header view.
- (UIView *)viewForHeaderWithTitle:(NSString *)title tableView:(UITableView *)tableView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 16, tableView.bounds.size.width, 20)];
    label.font = [UIFont regularFontOfSize:15];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:label];
    return view;
}
/// Creates a Custom view suitable as a table header view.
- (UIView *)viewForHeaderWithTitleDeliveryFR:(NSString *)title subtitle:(NSString *) subtitle tableView:(UITableView *)tableView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, tableView.bounds.size.width, 20)];
    label.font = [UIFont regularFontOfSize:15];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    
    UILabel *labelSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, tableView.bounds.size.width, 20)];
    labelSubtitle.font = [UIFont regularFontOfSize:10];
    labelSubtitle.backgroundColor = [UIColor clearColor];
    labelSubtitle.text = subtitle;//@"(La livraison aux points relais est disponible uniquement sur le site internet)";
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:label];
    [view addSubview:labelSubtitle];
    return view;
}


/// Presents a modal view controller named `identifier` from the current storybuild.
- (void)presentViewControllerWithIdentifier:(NSString *)identifier {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.mainViewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)barButtonItem {
    self.mainViewController.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)deleteRightBarButtonItem {
    self.mainViewController.navigationItem.rightBarButtonItem = nil;
}

@end
