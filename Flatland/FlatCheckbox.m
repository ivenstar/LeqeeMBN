//
//  FlatCheckbox.m
//  Flatland
//
//  Created by Stefan Aust on 13.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatCheckbox.h"
#import <QuartzCore/QuartzCore.h>

#define IMAGE_WIDTH  25
#define IMAGE_HEIGHT 25

@implementation FlatCheckbox

- (id)initWithFrame:(CGRect)frame {
    // force the correct size
    frame.size = [self sizeThatFits:frame.size];
    
    self = [super initWithFrame:frame];
    [self awakeFromNib];
    return self;
}

- (void)awakeFromNib {
    [self setBackgroundImage:[UIImage imageNamed:@"checkbox-normal"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"checkbox-selected"] forState:UIControlStateSelected];
    [self addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self setTintColor:[UIColor clearColor]];
    
    // if this button is followed by a UILabel, touching that label is like pressing this button
    NSArray *subviews = self.superview.subviews;
    NSUInteger index = [subviews indexOfObject:self];
    if (index != NSNotFound && index + 1 < [subviews count]) {
        UIView *label = [subviews objectAtIndex:index + 1];
        if ([label isKindOfClass:[UILabel class]]) {
            UITapGestureRecognizer *r = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressed:)];
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:r];
        }
    }
}

- (void)setOn:(BOOL)on {
    if (_on != on) {
        _on = on;
        [self setSelected:on];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    size.width = IMAGE_WIDTH;
    size.height = IMAGE_HEIGHT;
    return size;
}

- (void)pressed:(id)sender {
    self.on = !self.on;
}

- (void) markAsInvalid:(NSString *)errorMesage {
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
    self.layer.borderColor = [[UIColor colorWithRGBString:@"E03E1F"] CGColor];
}

- (void) markAsValid {
    self.layer.borderWidth = 0.0f;
}

@end
