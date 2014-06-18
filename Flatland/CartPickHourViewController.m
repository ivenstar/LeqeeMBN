//
//  CartPickHourViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CartPickHourViewController.h"
#import "Colizen.h"

@interface CartPickHourViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, assign) NSInteger minHour, maxHour;

@end

#pragma mark

@implementation CartPickHourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // compute the hour range for the current day
    if ([Colizen weekdayFromDate:self.date] == 1) {
        self.minHour = 8;
        self.maxHour = 11;
    } else {
        self.minHour = [Colizen minHourForDate:self.date];
        self.maxHour = [Colizen maxHourForDate:self.date];
    }
    NSInteger hour = [Colizen hoursFromDate:self.date];
    if (hour < self.minHour) {
        hour = self.minHour;
    }
    if (hour > self.maxHour) {
        hour = self.maxHour;
    }
    [self.pickerView reloadComponent:0];
    [self.pickerView selectRow:hour - self.minHour inComponent:0 animated:NO];
}

#pragma mark - Picker View Data Source & Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.maxHour - self.minHour + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%02dh00 - %02dh00", row + self.minHour, row + self.minHour + 2];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.date = [Colizen dateInDays:[Colizen daysFromDateSinceNow:self.date] hour:row + self.minHour];
}

#pragma mark - Actions

- (IBAction)save {
    [self.delegate datePicked:self.date];
    [self dismiss];
}

@end
