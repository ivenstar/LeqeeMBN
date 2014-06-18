//
//  CartPickDayViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CartPickDayViewController.h"
#import "Colizen.h"

@interface CartPickDayViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, copy) NSArray *dates;

@end

#pragma mark

@implementation CartPickDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // the next 7 days...
    NSMutableArray *dates = [NSMutableArray arrayWithCapacity:7];
    NSInteger start = [Colizen daysFromDateSinceNow:[Colizen earliestRendezvousDate]];
    for (NSInteger i = 0; i < 7; i++) {
        [dates addObject:[Colizen dateInDays:start + i hour:0]];
    }
    self.dates = dates;
    
    // compute the earliest day possible
    NSInteger days = [Colizen daysFromDateSinceNow:self.date];
    [self.pickerView reloadComponent:0];
    [self.pickerView selectRow:days - start inComponent:0 animated:NO];
}

#pragma mark - Picker View Data Source & Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dates count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone defaultTimeZone]];
    [df setLocale:CurrentLocale()];
    [df setDateFormat:@"EEEE dd MMMM"];
    return [[df stringFromDate:[self.dates objectAtIndex:row]] capitalizedString];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDate *date = [self.dates objectAtIndex:row];
    self.date = [Colizen dateInDays:[Colizen daysFromDateSinceNow:date]
                               hour:[Colizen hoursFromDate:self.date]];
}

#pragma mark - Actions

- (IBAction)save {
    [self.delegate datePicked:self.date];
    [self dismiss];
}

@end
