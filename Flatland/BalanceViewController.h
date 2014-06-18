//
//  BalanceViewController.h
//  Flatland
//
//  Created by Stefan Aust on 15.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "OrderAwareViewController.h"
#import "Baby.h"
/**
 * Displays the balance and allows to user to register to some news letter to receive more information.
 */
@interface BalanceViewController : OrderAwareViewController <UIPickerViewDelegate, UIPickerViewDataSource>;

@property (strong, nonatomic) UIPickerView *namePicker;
@property (nonatomic, strong) Baby *baby;

@end
