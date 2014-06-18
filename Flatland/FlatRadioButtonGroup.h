//
//  FlatRadioButtonGroup.h
//  Flatland
//
//  Created by Stefan Aust on 13.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ValidationManager.h"

/**
 * Provides a horizontal list of buttons acting together like a radio buttion group.
 * Changing the selected index fires a UIControlEventValueChanged event
 */
@interface FlatRadioButtonGroup : UIControl <ValidatableField>

@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, assign) NSInteger gap;
@property (nonatomic, assign) NSInteger selectedIndex;

- (void) refreshButtons;
- (void) addButton:(UIButton*) button;

@end
