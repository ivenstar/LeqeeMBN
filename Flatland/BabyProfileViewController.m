//
//  BabyProfileView.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 03.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BabyProfileViewController.h"
#import "FlatTextField.h"
#import "FlatRadioButtonGroup.h"
#import "CalendarPopupView.h"
#import "Capsule.h"
#import "User.h"

#ifdef SELECT_CAPSULE_SIZE
#import "BabyPreferredSizeViewController.h"
#endif //SELECT_CAPSULE_SIZE

#define kSecondsInMonth 2419200

static NSDateFormatter *sbirthdayFormatter = nil;

@interface BabyProfileViewController () <UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, CalendarPopupViewDelegate
#ifdef SELECT_CAPSULE_SIZE
                                                                                                                                                    ,BabyPreferredSizePickerDelegate
#endif //SELECT_CAPSULE_SIZE
                                                                                                                                                    >

@property (nonatomic,weak) IBOutlet UISegmentedControl *segmentedControl;


@property (weak, nonatomic) IBOutlet UIButton *removeProfileButton;
@property (weak, nonatomic) IBOutlet UIView *lineSeparator;

@property (weak, nonatomic) IBOutlet UILabel  *removePregLabel;

@property (weak, nonatomic) IBOutlet FlatRadioButtonGroup *pregnantRadioGroup;

@property (weak, nonatomic) IBOutlet UILabel  *removeBottleSizeLabel;

@property (weak, nonatomic) IBOutlet FlatRadioButtonGroup *bottleSizeRadioGroup;


@property (nonatomic, weak) IBOutlet UIImageView *babyPictureImageView;
@property (weak, nonatomic) IBOutlet FlatTextField *babyName;
@property (weak, nonatomic) IBOutlet FlatTextField *dateOfBirth;
//@property (weak, nonatomic) IBOutlet FlatTextField *weight;
@property (weak, nonatomic) IBOutlet FlatRadioButtonGroup *gender;
@property (nonatomic, strong) CalendarPopupView *calenderView;
@property (nonatomic, strong) Baby *editBaby;
//@property (nonatomic, strong) User *user;
@property (nonatomic, strong) ValidationManager *validationManager;
@property (nonatomic, copy) NSDate *currentSelectedDate;
#ifdef SELECT_CAPSULE_SIZE
@property (nonatomic, copy) NSString* selectedSize;
#endif //SELECT_CAPSULE_SIZE
@end

@implementation BabyProfileViewController {
    BOOL _imageChanged;
    BOOL _editMode;
    
}


@synthesize segmentedControl;
+ (BabyProfileViewController *)babyProfileViewControllerWithDelegate:(id<BabyProfileViewDelegate>)delegate {
    return [BabyProfileViewController babyProfileViewControllerWithDelegate:delegate baby:nil];
}

+ (BabyProfileViewController *)babyProfileViewControllerWithDelegate:(id<BabyProfileViewDelegate>)delegate baby:(Baby *)baby {
    BabyProfileViewController *babyProfileView = [[BabyProfileViewController alloc] initWithNibName:NSStringFromClass([BabyProfileViewController class]) bundle:nil];
    babyProfileView.editBaby = baby; //had to remove the copy to fix BNM-543
    babyProfileView.delegate = delegate;
    return babyProfileView;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
  
//    if ([User activeUser].pregnant){
//        [segmentedControl setSelectedSegmentIndex:0];
//        [segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
//    }
//    else {
//        [segmentedControl setSelectedSegmentIndex:1];
//        [segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
//
//    }
    [self icnhLocalizeView];
    if (!self.editBaby)
    {
        self.editBaby = [Baby new];
        //_weight.textColor = [UIColor blackColor];
    } else {
        _editMode = YES;
       // _weight.textColor = [UIColor lightGrayColor];
    }
    
    [self.view changeSystemFontToApplicationFont];
    
    self.babyName.delegate = self;
    self.dateOfBirth.delegate = self;
    //self.weight.delegate = self;
    
    //Replace the keyboard with calendar picker
    self.calenderView = [CalendarPopupView calendarViewWith:self.editBaby.birthday ? self.editBaby.birthday : [NSDate date] calender:[NSCalendar currentCalendar]];
    self.calenderView.view.frame = CGRectMake(0, 5, 320, 255);
    self.calenderView.delegate = self;
    self.dateOfBirth.inputView = self.calenderView.view;
    
    // create date formatter
    if (sbirthdayFormatter == nil) {
        sbirthdayFormatter = [[NSDateFormatter alloc] init];
        [sbirthdayFormatter setDateFormat:T(@"%general.dateFormat")];
    }
    
    //load the image
    [self.editBaby loadPictureWithCompletion:^(UIImage *picture) {
        self.babyPictureImageView.image = picture;
    }];

    //copy values into fields
    self.babyName.text = self.editBaby.name;
    self.dateOfBirth.text = [sbirthdayFormatter stringFromDate:self.editBaby.birthday];
    self.currentSelectedDate = self.editBaby.birthday;
    
    //if (self.editBaby.weight > 0) {
        //self.weight.text = [NSString stringWithFormat:@"%@ kg", [NSNumber numberWithDouble:self.editBaby.weight / 1000.0]];
    //}
    
    switch (self.editBaby.gender) {
        case GenderFemale:
            [self.gender setSelectedIndex:0];
            break;
        case GenderMale:
            [self.gender setSelectedIndex:1];
            break;
        default:
            [self.gender setSelectedIndex:0];
            break;
    }
    
    
    //setup validation
    self.validationManager = [[ValidationManager alloc] initWithMessageKeyPrefix:@"%createProfile."];

    [self.validationManager addRegExpValidatorForField:self.babyName regExp:T(@"regexp.name") errorMessageKey:@"Name NotValid"];

    
    FlatRadioButtonGroup *pregnantRadioButtonGroup = self.pregnantRadioGroup; //new var in order to have no warning about retain cycles 
    [self.validationManager addValidatorForField:self.dateOfBirth errorMessageKey:@"Birthday NotValid" validator:^BOOL(id<ValidatableField> checkField)
    {
        if (pregnantRadioButtonGroup.selectedIndex == 1)
        {
            NSString *text = ((UITextField *)checkField).text;
            if(!text) text = @"";
            NSDate *date = [sbirthdayFormatter dateFromString:text];
            if([date compare:[NSDate date]] == NSOrderedDescending){
                 NSLog(@"isNotPregnant: Birthday in the future");
                return NO;
            }
            else if ( [date compare:[NSDate dateWithTimeIntervalSinceNow:94608000]] == NSOrderedDescending)  {
                 NSLog(@"isNotPregnant: Birthday waaay in the past");
                return NO;
            }
             NSLog(@"isNotPregnant: Birthday correct");
            return text.length > 0;
        }
        else
        {
            NSString *text = ((UITextField *)checkField).text;
            if(!text) text = @"";
            NSDate *date = [sbirthdayFormatter dateFromString:text];
            if([date compare:[NSDate date]]== NSOrderedAscending){
                NSLog(@"isPregnant: Due Date preceeds curent date");
                return NO;
            }
            else if ([date compare:[NSDate dateWithTimeInterval:24796800 sinceDate:[NSDate date]]]== NSOrderedDescending){
                NSLog(@"isPregnant: Due Date exceeds term -> 41 weeks");
                return NO;
            }
            NSLog(@"isPregnant: Due Date correct");
            return YES && text.length > 0;
        }
    }];
//}
    //only validate weight when we are creating a new baby
//    if (!_editMode) {
//        [self.validationManager addRequiredValidatorForField:self.weight errorMessageKey:@"Weight NotValid"];
//        [self.validationManager addNumberValidatorForField:self.weight errorMessageKey:@"Weight NotValid"];
//    }
    
//    if (_editMode) {
//        [self.weight setEnabled:NO];
//    }
    
    UITapGestureRecognizer *r = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:r];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:T(@"%general.cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(doneWithNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:T(@"%general.ok") style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    //_weight.inputAccessoryView = numberToolbar;
    
    self.bottleSizeRadioGroup.selectedIndex = [self.editBaby.capsuleSize isEqualToString: @"Large"] ? 1 : 0;
    self.pregnantRadioGroup.selectedIndex = self.editBaby.preganatWithThisBaby ? 0 : 1;
}



#pragma mark - Actions

- (IBAction)setPicture {
    //show the actionsheet
    [[[UIActionSheet alloc] initWithTitle:@""
                                 delegate:self
                        cancelButtonTitle:T(@"%general.cancel")
                   destructiveButtonTitle:nil
                        otherButtonTitles:T(@"%babyProfile.takePhoto"), T(@"%babyProfile.pickPhoto"), nil]
     showFromToolbar:self.actionSheetToolbar];
}

- (IBAction)removeProfile {
    //inform the delegate that we want to be removed
    [self.delegate removeProfile:self];
}

#pragma mark - CalendarViewDelegate

- (void)calenderView:(CalendarPopupView *)calenderView didSelectDate:(NSDate *)date {
    [self.dateOfBirth resignFirstResponder];
    self.currentSelectedDate = date;
    self.dateOfBirth.text = [sbirthdayFormatter stringFromDate:date];

    
#ifdef SELECT_CAPSULE_SIZE
    NSTimeInterval age = [[NSDate date] timeIntervalSinceDate:date];
    if(age < kSecondsInMonth*6 && age > 0) {
        BabyPreferredSizeViewController *vc = [BabyPreferredSizeViewController new];
        [vc setDelegate:self];
        Capsule *c = [Capsule new];
        if (age < kSecondsInMonth) {
            c = [Capsule capsuleForType:@"FirstMonth"];
            [vc setCapsule:c];
        } else if(age < kSecondsInMonth*2) {
            c = [Capsule capsuleForType:@"SecondMonth"];
        } else {
            c = [Capsule capsuleForType:@"ThirdToSixthMonth"];
        }
        [vc setCapsule:c];
        [self.delegate presentController:vc];
    }
#endif //SELECT_CAPSULE_SIZE
    
}

- (void)closeCalendar {
    [self.dateOfBirth resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

// advance to next text field on RETURN
-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    if ([self.babyName isFirstResponder]) {
        [self.dateOfBirth becomeFirstResponder];
    }// else if ([self.dateOfBirth isFirstResponder]) {
        //[self.weight becomeFirstResponder];
   // } else if ([self.weight isFirstResponder]) {
     //   [self.weight resignFirstResponder];
    //}
    return YES;
}

// disallow editing with keyboard when datepicker opens
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.dateOfBirth isEqual:textField]) {
        return NO;
    }
    return YES;
    
}

#pragma mark - Action Sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: // take new picture with Camera
            [self takePictureWithCamera];
            break;
        case 1: // pick a picture from device
            [self pickPictureFromDevice];
            break;
        default: // cancel
            break;
    }
}


#pragma mark - Image picker controller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    self.babyPictureImageView.image = image;
    _imageChanged = YES;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#ifdef SELECT_CAPSULE_SIZE
#pragma mark - capsule size delegate 

- (void)picker:(BabyPreferredSizeViewController *)picker didSelectPreferredSize:(NSString *)size {
    [picker dismissViewControllerAnimated:YES completion:nil];
    _selectedSize = size;
}
#endif//SELECT_CAPSULE_SIZE

#pragma mark - Helpers

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)showRemoveButton:(BOOL)show {
//    if (!show)
//    {
//        CGRect frame = self.view.frame;
//        frame.size.height -= self.removeProfileButton.frame.size.height;
//    }
//    bchitu : button was moved in the upper corner
    
    self.removeProfileButton.hidden = !show;
}

- (void) setCapsuleSizeOptionHidden:(BOOL) hidden
{
    //TODO resize superview(substract heights of frames of vewis below)
    [self.removeBottleSizeLabel setHidden:hidden];
    [self.bottleSizeRadioGroup setHidden:hidden];
    [self.lineSeparator setHidden:hidden];
}

- (void) setPregnantOptionHidden: (BOOL) hidden
{
    //TODO counter part for TODO above
    [self.removePregLabel setHidden:hidden];
    [self.pregnantRadioGroup setHidden:hidden];
}


- (void)takePictureWithCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    if (![mediaTypes containsObject:@"public.image"]) {
        return;
    }
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.mediaTypes = mediaTypes;
    controller.allowsEditing = YES;
    controller.delegate = self;
    [self.delegate presentController:controller];
}

- (void)pickPictureFromDevice {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    controller.allowsEditing = YES;
    [self.delegate presentController:controller];
}

- (BOOL) validateFields
{
    return [_validationManager validate];
}

- (Baby *) baby
{
    Baby *baby = self.editBaby;
    baby.name = self.babyName.text;
#ifdef SELECT_CAPSULE_SIZE
    baby.capsuleSize = _selectedSize ? _selectedSize : @"Small";
#else
    baby.capsuleSize = self.bottleSizeRadioGroup.selectedIndex == 0 ? @"Standard" : @"Large";
#endif //SELECT_CAPSULE_SIZE
    
    baby.preganatWithThisBaby = self.pregnantRadioGroup.selectedIndex == 0;
    
    if (!_editMode) {
       // NSNumberFormatter *nf = [NSNumberFormatter new];
       // [nf setNumberStyle:NSNumberFormatterDecimalStyle];
        //baby.weight = [nf numberFromString:self.weight.text].doubleValue * 1000l;
    }
    
    switch (self.gender.selectedIndex) {
        case 0:
            baby.gender = GenderFemale;
            break;
        case 1:
            baby.gender = GenderMale;
            break;
        default:
            baby.gender = GenderNone;
            break;
    }
    baby.birthday = self.currentSelectedDate;
    if (_imageChanged) {
        baby.picture = self.babyPictureImageView.image;
    }
    return baby;
}

-(void)doneWithNumberPad{
    //[_weight resignFirstResponder];
}
//- (IBAction)isPregnant:(id)sender {
//    if (segmentedControl.selectedSegmentIndex ==0 ){
//        NSLog(@"Yes is selected");
//        self.dateOfBirth.placeholder = @"Due date";
//        [[User activeUser] setPregnant:YES];
//        NSLog([User activeUser].pregnant ? @"1.Yes: user is pregnat " : @"1.No :user is not pregnant");
//        
//   //     self.validationManager = [[ValidationManager alloc] initWithMessageKeyPrefix:@"%createProfile."];
//        
//        
//    }
//    if (segmentedControl.selectedSegmentIndex == 1){
//        NSLog(@"No is selected");
//        self.dateOfBirth.placeholder = @"Birthday";
//    
//        [[User activeUser] setPregnant: NO];
//         NSLog([User activeUser].pregnant ? @"2.Yes: user is pregnat " : @"2.No :user is not pregnant");
//        
//     //   self.validationManager = [[ValidationManager alloc] initWithMessageKeyPrefix:@"%createProfile."];
//    }
//}

@end
