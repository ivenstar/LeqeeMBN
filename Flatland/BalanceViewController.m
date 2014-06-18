//
//  BalanceViewController.m
//  Flatland
//
//  Created by Stefan Aust on 15.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BalanceViewController.h"
#import "FlatTextField.h"
#import "User.h"
#import "AlertView.h"
#import "ValidationManager.h"
#import "WithingsAuthViewController.h"

@interface BalanceViewController ()

@property (nonatomic, weak) IBOutlet FlatTextField *emailTextField;
    @property (weak, nonatomic) IBOutlet UILabel *balanceTextTitleField;
    @property (weak, nonatomic) IBOutlet UILabel *balanceTextField;

@property (weak, nonatomic) IBOutlet UILabel *balanceChildLabel;
@property (strong, nonatomic) IBOutlet UITextField *babyName;
@property (strong, nonatomic) UIToolbar *accessoryView;
@property (nonatomic) int pos;

@end

#pragma mark

@implementation BalanceViewController {
    ValidationManager *_validationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_namePicker == nil) {
        _namePicker = [UIPickerView new];
        _pos = 0;
        
        _namePicker.delegate = self;
        _namePicker.showsSelectionIndicator = YES;
        
        self.accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
        self.accessoryView.barStyle = UIBarStyleBlackTranslucent;
        self.accessoryView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDonePressed)];
        UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.accessoryView.items = [NSArray arrayWithObjects:flexibleSpace, doneButton, nil];
        
        self.babyName.inputView = _namePicker;
        self.babyName.inputAccessoryView = self.accessoryView;
    }
    
    // setup a validator for the email address input field
    _validationManager = [[ValidationManager alloc] initWithMessageKeyPrefix:@"%balance"];
    [_validationManager addRegExpValidatorForField:self.emailTextField regExp:T(@"regexp.email") errorMessageKey:@"email"];
    
    // prefill input field with user's email address
    self.emailTextField.text = [User activeUser].email;
    
    // setup size of page
    UIView *contentView = [self.formScrollView.subviews objectAtIndex:0];
    self.formScrollView.contentSize = contentView.bounds.size;
    
    _babyName.text = _baby.name;
    CGSize textSize = [self.balanceChildLabel.text sizeWithFont:self.balanceChildLabel.font];
    if (textSize.width > self.balanceChildLabel.frame.size.width)
    {
        self.balanceChildLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.balanceChildLabel.numberOfLines = 2;
        self.balanceChildLabel.frame = CGRectMake(self.balanceChildLabel.frame.origin.x,self.balanceChildLabel.frame.origin.y - 30,self.balanceChildLabel.frame.size.width,self.balanceChildLabel.frame.size.height + 30);
    }
    
    
#ifndef BABY_NES_US
    //remove balance title(only used on US) and set the balance text frame back
    CGRect balanceTextTitleFrame = self.balanceTextTitleField.frame;
    CGRect balanceTextFrame = self.balanceTextField.frame;
    
    balanceTextFrame.origin = balanceTextTitleFrame.origin;
    balanceTextFrame.size.height += balanceTextFrame.origin.y - balanceTextTitleFrame.origin.y;
    
    [self.balanceTextTitleField removeFromSuperview];
    self.balanceTextField.frame = balanceTextFrame;
#endif //!BABY_NES_US
}

#pragma mark - Actions

- (IBAction)setupBalance {

}

- (IBAction)subscribe {
    if (![_validationManager validate]) {
        return;
    }

    [self.emailTextField resignFirstResponder];
    
    NSString *email = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([email length]) {
        [[User activeUser] subscribeForBalanceInformation:email completion:^(BOOL success) {
            if (success) {
                [[AlertView alertViewFromString:T(@"%balance.alert.newsLetterSuccess") buttonClicked:nil] show];
            } else {
                [[AlertView alertViewFromString:T(@"%balance.alert.newsLetterNoSuccess") buttonClicked:nil] show];
            }
        }];
    }
}

#pragma mark -
#pragma mark PickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [[[User activeUser] babies] count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [[[[User activeUser] babies] objectAtIndex:row] name];
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    _pos = row;
}

- (void)pickerDonePressed {
    [_babyName resignFirstResponder];
    _baby = [[[User activeUser] babies] objectAtIndex:_pos];
    _babyName.text = _baby.name;
}

- (IBAction)syncAccount:(id)sender {
    WithingsAuthViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WithingAuth"];
    vc.baby = _baby;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)linkPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:T(@"%balance.target")]];
}

@end
