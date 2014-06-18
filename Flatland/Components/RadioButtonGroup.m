//
//  RadioButtonGroup.m
//  Flatland
//
//  Created by Bogdan Chitu on 11/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "RadioButtonGroup.h"

@interface RadioButtonGroup()
{
    BOOL tagsDefined;
}

@end

@implementation RadioButtonGroup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configureButtons];
        _selectedIndex = -1;
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self configureButtons];
    _selectedIndex = -1;
}

- (void) configureButtons
{
    int tag = 0;
    NSMutableArray* buttonsArray = [[NSMutableArray alloc] init];
    for (UIButton *button in self.subviews)
    {
        [buttonsArray addObject:button];
        if (!self.userDefinedTags)
        {
            button.tag = tag;
            ++tag;
        }
        
        [button addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:button];
    }
    
    buttons = buttonsArray;
}

- (void) setSelectedButtonWithTag: (int) buttonTag
{
    if (buttonTag >= 0 && buttonTag < [buttons count])
    {
        for (int i=0;i<[buttons count];i++)
        {
            if ([[buttons objectAtIndex:i] tag] == buttonTag)
            {
                [self setSelectedButton:[buttons objectAtIndex:i]];
                break;
            }
        }
    }
}

- (void) setSelectedButton:(UIButton*) button
{
    [button sendActionsForControlEvents:UIControlEventTouchDown];
}

- (void) pressed: (UIControl*) sender
{
    _selectedIndex = sender.tag;
    sender.selected = YES;
    
    for (UIButton* button in buttons)
    {
        if (button != sender)
        {
            button.selected = NO;
        }
    }
    
    [self.delegate radioButtonGroup:self buttonPressed:sender];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
