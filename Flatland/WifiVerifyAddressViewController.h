//
//  WifiVerifyAddressViewController.h
//  Flatland
//
//  Created by Stefan Aust on 21.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WifiBaseViewController.h"

@interface WifiVerifyAddressViewController : WifiBaseViewController
#ifdef BABY_NES_US
                                            <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *statePicker; //State picker
@property (nonatomic) int pos;

#endif //BABY_NES_US


@end
