//
//  RadioButtonGroup.h
//  Flatland
//
//  Created by Bogdan Chitu on 11/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadioButtonGroup;
@protocol RadioButtonGroupDelegate <NSObject>

- (void) radioButtonGroup:(RadioButtonGroup*)group buttonPressed:(UIControl*) button;

@end

@interface RadioButtonGroup : UIControl
{
    NSArray* buttons;
}

@property (nonatomic,assign) BOOL userDefinedTags;//should be used as runtime attr. in xib
@property (nonatomic,assign) id<RadioButtonGroupDelegate> delegate;
@property (nonatomic,readonly) int selectedIndex;

- (void) setSelectedButtonWithTag: (int) buttonTag;
- (void) setSelectedButton:(UIButton*) button;

@end


