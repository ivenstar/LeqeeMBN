//
//  CircularMaskImageView.h
//  Flatland
//
//  Created by Stefan Aust on 14.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CircularMaskImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CircularMaskImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    // create a circle path, create a mask from that path, add that mask to the receiver's layer
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, self.bounds);
    CAShapeLayer *mask =[CAShapeLayer layer];
    mask.path = path;
    mask.frame = self.bounds;
    CGPathRelease(path);
    self.layer.mask = mask;
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (self.bounds.size.width), (self.bounds.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setCornerRadius:(self.bounds.size.height) / 2];
    [borderLayer setBorderWidth:1];
    [borderLayer setBorderColor: [[UIColor colorWithRGBString:@"#9894B7"] CGColor]];
    [self.layer addSublayer:borderLayer];
}

- (void)setDrawBorder:(BOOL)drawBorder {
    if (drawBorder) {
        [[self.layer.sublayers lastObject] setBorderWidth:3];
    } else {
        [[self.layer.sublayers lastObject] setBorderWidth:1];
    }
}
@end
