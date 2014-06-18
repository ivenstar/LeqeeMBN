//
//  EditUserViewController.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 14.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"
#import "User.h"
#import "Address.h"

/**
 * Show form of user personal information
 */
@interface EditUserViewController : FlatViewController <UITextFieldDelegate
#ifdef BABY_NES_US
                                    ,UIPickerViewDataSource,UIPickerViewDelegate
#endif //BABY_NES_US
                                    >

@property (nonatomic, strong) User *user; // the user that should be updated
@property (nonatomic, strong) Address *userAddress; // the address of the user

#ifdef BABY_NES_US
@property (nonatomic, strong) UIPickerView *statePicker; //State picker
@property (nonatomic) int pos;
#endif //BABY_NES_US

@end
