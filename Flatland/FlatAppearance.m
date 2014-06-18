//
//  FlatAppereance.m
//  Flatland
//
//  Created by Stefan Aust on 13.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatAppearance.h"

#import "FlatButton.h"
#import "FlatRadioButtonGroup.h"
#import "FlatTextField.h"
#import "FlatTextView.h"
#import "FlatSwitch.h"
#import "FlatBigLabel.h"
#import "FlatMediumLabel.h"
#import "FlatSmallLabel.h"
#import "FlatTabButton.h"
#import "FlatButtonSmall.h"

#import "MenuButton.h"

@implementation FlatAppearance

+ (void)setup {
    
    // change default font
    [[UILabel appearanceWhenContainedIn:[UIButton class], nil] setFont:[UIFont boldFontOfSize:16]];
    [[FlatButton appearance] setFont:[UIFont boldFontOfSize:16]];
    [[FlatButtonSmall appearance] setFont:[UIFont boldFontOfSize:14]];
    [[UITextField appearance] setFont:[UIFont regularFontOfSize:15]];
    [[FlatSwitch appearance] setFont:[UIFont boldFontOfSize:11]];
    [[MenuButton appearance] setFont:[UIFont regularFontOfSize:16]];
    [[UILabel appearance] setFont:[UIFont regularFontOfSize:14]];
    [[FlatBigLabel appearance] setFont:[UIFont regularFontOfSize:45]];
    [[FlatMediumLabel appearance] setFont:[UIFont regularFontOfSize:24]];
    [[FlatSmallLabel appearance] setFont:[UIFont regularFontOfSize:17]];
    
    // normal flat button
    [[FlatButton appearance] setCornerRadius:8];
    [[FlatButton appearance] setBackgroundColor:[UIColor colorWithRGBString:@"9894B7"] forState:UIControlStateNormal];
    [[FlatButton appearance] setBackgroundColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [[FlatButton appearance] setTitleColor:[UIColor colorWithRGBString:@"FDFDFD"] forState:UIControlStateNormal];

    // light gray flat button
    [[FlatLightButton appearance] setBackgroundColor:[UIColor colorWithRGBString:@"DAD9DE"] forState:UIControlStateNormal];
    [[FlatLightButton appearance] setTitleColor:[UIColor colorWithRGBString:@"4C4962"] forState:UIControlStateNormal];
    
    // dark purple flat button
    [[FlatDarkButton appearance] setBackgroundColor:[UIColor colorWithRGBString:@"4A4A60"] forState:UIControlStateNormal];
    [[FlatDarkButton appearance] setTitleColor:[UIColor colorWithRGBString:@"FDFDFD"] forState:UIControlStateNormal];
    
    // dark gray flat button
    [[FlatDarkGrayButton appearance] setBackgroundColor:[UIColor colorWithRGBString:@"6B6B6B"] forState:UIControlStateNormal];
    [[FlatDarkGrayButton appearance] setTitleColor:[UIColor colorWithRGBString:@"FDFDFD"] forState:UIControlStateNormal];
    
    [[FlatTabButton appearance] setFont:[UIFont regularFontOfSize:12]];
    
    id radioButtonGroupAppearance = [FlatButton appearanceWhenContainedIn:[FlatRadioButtonGroup class], nil];
    [radioButtonGroupAppearance setBackgroundColor:[UIColor colorWithRGBString:@"DAD9DE"] forState:UIControlStateNormal];
    [radioButtonGroupAppearance setBackgroundColor:[UIColor colorWithRGBString:@"000000"] forState:UIControlStateHighlighted];
    [radioButtonGroupAppearance setBackgroundColor:[UIColor colorWithRGBString:@"4A4A60"] forState:UIControlStateSelected];
    [radioButtonGroupAppearance setBackgroundColor:[UIColor colorWithRGBString:@"000000"] forState:UIControlStateSelected+UIControlStateHighlighted];
    [radioButtonGroupAppearance setTitleColor:[UIColor colorWithRGBString:@"4C4962"] forState:UIControlStateNormal];
    [radioButtonGroupAppearance setTitleColor:[UIColor colorWithRGBString:@"FDFDFD"] forState:UIControlStateHighlighted];
    [radioButtonGroupAppearance setTitleColor:[UIColor colorWithRGBString:@"FDFDFD"] forState:UIControlStateSelected];
    [radioButtonGroupAppearance setTitleColor:[UIColor colorWithRGBString:@"FDFDFD"] forState:UIControlStateSelected+UIControlStateHighlighted];

    // navigation bar (slightly higher, see below, and with a different font)
    UIImage *image = [UIImage imageNamed:@"navigationbar"];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRGBString:@"9792BF"]];
    if (IS_IOS7)
    {
        image = [image scaleToSize:CGSizeMake(image.size.width, 88)];
    }
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                     UITextAttributeFont:[UIFont boldFontOfSize:22],
                                UITextAttributeTextColor:[UIColor whiteColor]}];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRGBString:@"9792BF"]];
    NSDictionary *attributes = @{UITextAttributeFont: [UIFont boldFontOfSize:13],
                                 UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateHighlighted];

    
    [[FlatTextView appearance] setFont:[UIFont regularFontOfSize:14]];
    [[FlatTextView appearance] setBackgroundColor:[UIColor whiteColor]];
    
    [[FlatTextField appearance] setFont:[UIFont regularFontOfSize:14]];
    [[FlatTextField appearance] setBackgroundColor:[UIColor whiteColor]];
}

@end



