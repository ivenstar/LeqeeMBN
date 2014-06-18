//
//  FlatButton.m
//  Flatland
//
//  Created by Stefan Aust on 13.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatButton.h"

@implementation FlatButton {
    NSMutableArray *_backgroundColors;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self awakeFromNib];
    return self;
}

- (void)awakeFromNib {
}

- (UIColor *)backgroundColorForState:(UIControlState)state {
    id color = _backgroundColors[state];
    if (!color || color == [NSNull null]) {
        color = _backgroundColors[UIControlStateNormal];
        if (!color || color == [NSNull null]) {
            color = self.backgroundColor;
        }
    }
    return color;
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    if (!_backgroundColors) {
        _backgroundColors = [NSMutableArray arrayWithCapacity:8];
        for (int i = 0; i < 8; i++) {
            [_backgroundColors addObject:[NSNull null]];
        }
    }
    if (_backgroundColors[state] != color) {
        _backgroundColors[state] = color ? color : [NSNull null];
        [self refreshBackgroundColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    if (self.highlighted != highlighted) {
        [super setHighlighted:highlighted];
        [self refreshBackgroundColor];
    }
}

- (void)setSelected:(BOOL)selected {
    if (self.selected != selected) {
        [super setSelected:selected];
        [self refreshBackgroundColor];
    }
}

- (void)setEnabled:(BOOL)enabled {
    if (self.enabled != enabled) {
        [super setEnabled:enabled];
        [self refreshBackgroundColor];
    }
}

- (void)refreshBackgroundColor {
    UIControlState state = UIControlStateNormal;
    if (self.highlighted) {
        state |= UIControlStateHighlighted;
    }
    if (self.selected) {
        state |= UIControlStateSelected;
    }
    if (!self.enabled) {
        state |= UIControlStateDisabled;
    }
    self.backgroundColor = [self backgroundColorForState:state];
}

@end


@implementation FlatLightButton

@end


@implementation FlatDarkButton

@end

@implementation FlatDarkGrayButton

@end
