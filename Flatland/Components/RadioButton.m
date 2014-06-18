//
//  RadioButton.m
//  Flatland
//
//  Created by Bogdan Chitu on 05/05/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "RadioButton.h"

@implementation RadioButton

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (self.shouldRemainHighlighted)
    {
        [self setHighlighted:selected];
    }
}

- (void) setHighlighted:(BOOL)highlighted
{
    if (self.shouldRemainHighlighted)
    {
        highlighted = self.selected;
    }
    [super setHighlighted:highlighted];
}

@end
