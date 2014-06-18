//
//  FlatButton.h
//  Flatland
//
//  Created by Stefan Aust on 13.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Provides a flat button with rounded corners.
 */
@interface FlatButton : UIButton

- (UIColor *)backgroundColorForState:(UIControlState)state;
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

@end

@interface FlatLightButton : FlatButton //light gray button

@end

@interface FlatDarkButton : FlatButton //dark purple button

@end

@interface FlatDarkGrayButton : FlatButton //dark gray button

@end

