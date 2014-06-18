//
//  FlatSwitch.h
//  Flatland
//
//  Created by Stefan Aust on 20.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Provides a special kind of check box button displaying yes/no.
 * Changing the state fires a UIControlEventValueChanged event.
 */
@interface FlatSwitch : UIButton

@property(nonatomic, getter=isOn) BOOL on;

@end
