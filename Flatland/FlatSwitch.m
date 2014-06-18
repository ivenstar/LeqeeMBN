//
//  FlatSwitch.m
//  Flatland
//
//  Created by Stefan Aust on 20.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatSwitch.h"

#define IMAGE_WIDTH  25
#define IMAGE_HEIGHT 25

@implementation FlatSwitch

- (id)initWithFrame:(CGRect)frame {
    // force the correct size
    frame.size = [self sizeThatFits:frame.size];
    
    self = [super initWithFrame:frame];
    [self awakeFromNib];
    return self;
}

- (void)awakeFromNib {
    [self setBackgroundImage:[UIImage imageNamed:@"switch-no"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"switch-yes"] forState:UIControlStateSelected];
    [self setTitle:T(@"%general.no") forState:UIControlStateNormal];
    [self setTitle:T(@"%general.yes") forState:UIControlStateSelected];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.font = [UIFont boldFontOfSize:10];
}

- (void)setOn:(BOOL)on {
    [self setSelected:on];
}

- (CGSize)sizeThatFits:(CGSize)size {
    size.width = IMAGE_WIDTH;
    size.height = IMAGE_HEIGHT;
    return size;
}

- (void)pressed:(id)sender {
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
