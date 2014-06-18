//
//  CartColizenViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CartColizenViewController.h"
#import "CartPickDayViewController.h"
#import "CartPickHourViewController.h"
#import "FlatTextField.h"
#import "ValidationManager.h"
#import "Order.h"
#import "Colizen.h"

@interface CartColizenViewController () <CartPickDayViewControllerDelegate, CartPickHourViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UIButton *pickDayButton;
@property (nonatomic, strong) IBOutlet UIButton *pickHourButton;
@property (nonatomic, strong) IBOutlet FlatTextField *mobileField;

@property (nonatomic, strong) NSDate *rendezvousDate;

@end

#pragma mark

@implementation CartColizenViewController {
    ValidationManager *_validationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup a validator for the required mobile number field.
    _validationManager = [[ValidationManager alloc] initWithMessageKeyPrefix:@"%colizen"];
    [_validationManager addRegExpValidatorForField:self.mobileField regExp:T(@"regexp.mobile") errorMessageKey:@"mobile"];

    // populate the mobile number field from the delivery address
    self.mobileField.text = [Order sharedOrder].deliveryAddress.mobile;

    // initialize the earliest rendezvous date possible
    self.rendezvousDate = [Colizen earliestRendezvousDate];
}

#pragma mark - Segues

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"Next"]) {
        return [_validationManager validate];
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PickDay"]) {
        CartPickDayViewController *vc = ((UINavigationController *)segue.destinationViewController).viewControllers[0];
        vc.delegate = self;
        vc.date = self.rendezvousDate;
    }
    if ([segue.identifier isEqualToString:@"PickHour"]) {
        CartPickHourViewController *vc = ((UINavigationController *)segue.destinationViewController).viewControllers[0];
        vc.delegate = self;
        vc.date = self.rendezvousDate;
    }
    if ([segue.identifier isEqualToString:@"Next"]) {
        [Order sharedOrder].rendezvousDate = self.rendezvousDate;
        [Order sharedOrder].phoneNumber = self.mobileField.text;
    }
}

#pragma mark - Delegates

- (void)datePicked:(NSDate *)date {
    self.rendezvousDate = date;
}

- (void)setRendezvousDate:(NSDate *)date {
    date = [Colizen normalizeDate:date];
    NSInteger hour = [Colizen hoursFromDate:date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone defaultTimeZone]];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[NSString stringWithFormat:@"%@_%@", T(@"%general.language"), kCountryCode]]];
    [df setDateFormat:@"EEEE dd MMMM"];
    [self.pickDayButton setTitle:[[df stringFromDate:date] capitalizedString]
                        forState:UIControlStateNormal];
    [self.pickHourButton setTitle:[NSString stringWithFormat:@"%02dh00 - %02dh00", hour, hour + 2]
                         forState:UIControlStateNormal];
    
    _rendezvousDate = date;
}

@end
