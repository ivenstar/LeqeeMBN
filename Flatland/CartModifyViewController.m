//
//  CartModifyViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CartModifyViewController.h"

@interface CartModifyViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *boxPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalPriceLabel;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

@end

#pragma mark

@implementation CartModifyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updatePrices];
    [self.pickerView selectRow:self.quantity - 1 inComponent:0 animated:NO];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IS_IOS7)
    {
        CGRect pickerFrame = self.pickerView.frame;
        pickerFrame.origin.y = 155;
        self.pickerView.frame = pickerFrame;
    }
}


#pragma mark - Picker View Data Source & Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 20;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%d", row + 1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.quantity = row + 1;
    [self updatePrices];
}

#pragma mark - Actions

- (IBAction)save {
    [self.delegate quantityChangedTo:self.quantity];
    [self dismiss];
}

#pragma mark - Private

- (void)updatePrices {
    self.boxPriceLabel.text = FormatPrice(self.price);
    self.totalPriceLabel.text = FormatPrice(self.price * self.quantity);
}

@end
