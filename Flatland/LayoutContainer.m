//
//  LayoutContainer.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 09.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "LayoutContainer.h"

@implementation LayoutContainer

- (void)layoutSubviews {
    //    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGFloat diff = 0;
    
    for (UIView *view in self.subviews) {
        CGFloat height = [view sizeThatFits:size].height;
        
        CGRect frame = view.frame;
        frame.origin.y += diff;
        diff += height - frame.size.height;
        frame.size.height = height;
        view.frame = frame;
    }
    
    [self sizeToFit];
}

- (CGSize)sizeThatFits:(CGSize)size {
    UIView *view = [self.subviews lastObject];
    if (view) {
        size.height = CGRectGetMaxY(view.frame);
    }
    return size;
}

@end
