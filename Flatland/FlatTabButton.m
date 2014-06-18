//
//  FlatTabButton.m
//  Flatland
//
//  Created by Stefan Aust on 21.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatTabButton.h"

@implementation FlatTabButton

- (void)awakeFromNib {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont regularFontOfSize:12];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGSize size = [self imageSize];
    CGFloat height = [self labelHeight];
    contentRect.origin.x += (contentRect.size.width - size.width) / 2;
    contentRect.origin.y += (contentRect.size.height - size.height + height) / 2;
    contentRect.size = size;
    return contentRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGSize size = [self imageSize];
    CGFloat height = [self labelHeight];
    contentRect.origin.y += (contentRect.size.height - size.height - height) / 2;
    contentRect.size.height = height;
    return contentRect;
}

- (CGSize)imageSize {
    return [self imageForState:UIControlStateNormal].size;
}

- (CGFloat)labelHeight {
    return 16;
}

@end
