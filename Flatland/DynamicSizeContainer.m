//
//  DynamicSizeContainer.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 03.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "DynamicSizeContainer.h"

@implementation DynamicSizeContainer

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure {
    if (!self.border) {
        self.border = 0;
    }
    
    if(!self.cols) {
        self.cols = 1;
    }
    if(!self.gap) {
        self.gap = 0;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    bounds.size.width -= self.border;
    bounds.origin = CGPointMake(self.border/2, self.border/2);
    CGFloat height = 0;
    
    NSUInteger index = 0;
    for (UIView *view in self.subviews) {
        CGRect frame = bounds;
        frame.size.width = (bounds.size.width - self.gap * (self.cols - 1)) / self.cols;
        frame.size.height = 1e6;
        frame.size.height = [view sizeThatFits:frame.size].height;
        height = MAX(height, frame.size.height);
        frame.origin.x += (frame.size.width + self.gap) * (index % self.cols);
        view.frame = frame;
        if (index % self.cols == self.cols-1) {
            bounds.origin.y += height + self.gap;
            height = 0;
        }
        index++;
    }
    [self.superview setNeedsLayout];
}

- (CGSize)sizeThatFits:(CGSize)size {
    size.width = (size.width - self.border - self.gap * (self.cols - 1)) / self.cols;
    size.height = 1e6;
    CGFloat totalHeight = 0;
    CGFloat rowHeight = 0;
    
    NSUInteger index = 0;
    for (UIView *view in self.subviews) {
        CGFloat h = [view sizeThatFits:size].height;
        rowHeight = MAX(rowHeight, h);
        if (index % self.cols == self.cols-1) {
            totalHeight += rowHeight;
            totalHeight += self.gap;
            rowHeight = 0;
        }
        index++;
    }
    if (rowHeight > 0) {
        totalHeight += rowHeight;
        totalHeight += self.border;
    } else if (totalHeight > 0) {
        totalHeight -= self.gap;
        totalHeight += self.border;
    }
    size.width = size.width * self.cols + (self.cols - 1) * self.gap + self.border;
    size.height = totalHeight;
    return size;
}
@end
