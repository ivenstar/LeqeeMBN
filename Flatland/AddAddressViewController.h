//
//  AddAddressViewController.h
//  Flatland
//
//  Created by Stefan Aust on 27.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"
#import "FlatRadioButtonGroup.h"
#import "FlatTextField.h"
#import "ValidationManager.h"
#import "OverlaySaveView.h"
#import "Address.h"
#import "BabyNesCountryPicker.h"
#import "FlatButton.h"
#import "BabyNesPhoneTextField.h"
#import <UIKit/UIPickerView.h>

/**
 * Adds a new delivery address or billing address to the system.
 */
@interface AddAddressViewController : FlatViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,BabyNesCountryPickerDelegate>
{
    ValidationManager *_validationManager;
}

@property (nonatomic, weak) IBOutlet UILabel *headerLabel;
@property (nonatomic, weak) IBOutlet FlatRadioButtonGroup *titleRadioButtonGroup;
@property (nonatomic, weak) IBOutlet FlatTextField *firstNameField;
@property (nonatomic, weak) IBOutlet FlatTextField *lastNameField;
@property (nonatomic, weak) IBOutlet FlatTextField *streetField;
@property (nonatomic, weak) IBOutlet FlatTextField *streetExtraField;
@property (nonatomic, weak) IBOutlet FlatTextField *ZIPField;
@property (nonatomic, weak) IBOutlet FlatTextField *cityField;
@property (nonatomic, weak) IBOutlet FlatTextField *stateField;
@property (nonatomic, weak) IBOutlet BabyNesPhoneTextField *mobileField;
@property (weak, nonatomic) IBOutlet BabyNesCountryPicker *countryPicker;
@property (weak, nonatomic) IBOutlet UIImageView *mobileIconImageView;
@property (weak, nonatomic) IBOutlet UINavigationItem *header;
@property (weak, nonatomic) IBOutlet FlatDarkButton *registerButton;


@property (nonatomic, weak) Address *userAddress;
@property (nonatomic, assign) AddressMode mode;
@property (nonatomic, strong) UIPickerView *statePicker; //State picker
@property (nonatomic) int pos;

- (IBAction)save;
- (void)didSaveAddress:(Address *)address;
- (void) setStateFieldHidden: (BOOL) hidden;

@end
