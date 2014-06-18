//
//  MoodRadioButton.m
//  Flatland
//
//  Created by Bogdan Chitu on 28/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "MoodRadioButton.h"

@implementation MoodRadioButton

- (void)awakeFromNib
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setImage:[self imageForState:UIControlStateHighlighted] forState:UIControlStateSelected];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGSize size = [self imageSize];
    contentRect.origin.y += 5;
    contentRect.origin.x += (contentRect.size.width - size.width) / 2;
    contentRect.size = size;
    return contentRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat height = [self labelHeight];
    contentRect.origin.y += contentRect.size.height - height;
    contentRect.size.height = height;
    return contentRect;
}

- (CGSize)imageSize
{
    return [self imageForState:UIControlStateNormal].size;
}

- (CGFloat)labelHeight
{
    return 14;
}

- (void) setSelected:(BOOL)selected
{
    if (self.selected != selected)
    {
        if (selected)
        {
            self.titleLabel.font = [UIFont boldFontOfSize:self.titleLabel.font.pointSize + 1];
        }
        else
        {
            self.titleLabel.font = [UIFont regularFontOfSize:self.titleLabel.font.pointSize - 1];
        }
    }
    
    [super setSelected:selected];
    [self setHighlighted:selected];
}

- (void) setHighlighted:(BOOL)highlighted
{
    highlighted = self.selected;
    [super setHighlighted:highlighted];
}


@end
