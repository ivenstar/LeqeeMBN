//
//  MenuButton.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 20.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "MenuButton.h"

@interface MenuButton ()
{
    UIView* _separator;
    UIImageView *_arrowImageView;
    UIColor *_normalBackgroundColor;
}

@end

@implementation MenuButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self awakeFromNib];
    return self;
}

- (void)awakeFromNib {
    CGSize size = self.bounds.size;
    
    //allign the title to the left
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contentMode = UIViewContentModeLeft;
    self.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    
    // add searator line
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, size.height - 1, size.width, 1)];
    separator.backgroundColor = [UIColor colorWithRGBString:@"#62607E"];
    separator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin + UIViewAutoresizingFlexibleWidth;
    [self addSubview:separator];
    _separator = separator;
    
    // add disclosure arrow
    if (self.showArrow)
    {
        UIImage *arrow = [UIImage imageNamed:@"arrow-white"];
        [self setArrowImage:arrow withSize:CGSizeZero];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    if (self.highlighted != highlighted) {
        [super setHighlighted:highlighted];
        if (highlighted) {
            _normalBackgroundColor = self.backgroundColor;
            self.backgroundColor = [UIColor whiteColor];
        } else {
            self.backgroundColor = _normalBackgroundColor;
        }
    }
}

- (void) setShowArrow:(BOOL)showArrow
{
    if (_showArrow != showArrow)
    {
        _showArrow = showArrow;
        [_arrowImageView setHidden:!showArrow];
    }
}

- (void)setSeparatorHidden:(BOOL)hidden
{
    [_separator setHidden:hidden];
}


- (void) setArrowImage:(UIImage *)image withSize:(CGSize) imageSize
{
    if (_arrowImageView) //remove old imageview
    {
        [_arrowImageView removeFromSuperview];
    }
    
    if (imageSize.height == 0 && imageSize.width == 0)
    {
        imageSize.width = 6;
        imageSize.height = 10;
    }
    
    CGSize size = self.bounds.size;
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:image];
    arrow.frame = CGRectMake(size.width - 24 - (imageSize.width/2), (size.height - imageSize.height) / 2, imageSize.width, imageSize.height);
    arrow.autoresizingMask = UIViewAutoresizingFlexibleTopMargin + UIViewAutoresizingFlexibleLeftMargin + UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:arrow];
    _arrowImageView = arrow;
}

@end
