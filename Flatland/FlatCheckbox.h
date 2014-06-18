//
//  FlatCheckbox.h
//  Flatland
//
//  Created by Stefan Aust on 13.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ValidationManager.h"

/**
 * Provides a check box button.
 * Changing the state fires a UIControlEventValueChanged event.
 */
@interface FlatCheckbox : UIButton <ValidatableField>

@property(nonatomic,setter=setOn:,getter=isOn) BOOL on;

@end
