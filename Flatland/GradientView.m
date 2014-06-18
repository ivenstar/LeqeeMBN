//
//  GradientView.m
//  Flatland
//
//  Created by Stefan Aust on 21.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "GradientView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GradientView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self awakeFromNib];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    
    UIColor *startColor;
    UIColor *stopColor;
    
    switch (self.kind) {
        case 0:
            startColor = [UIColor whiteColor];
            stopColor = [UIColor colorWithRGBString:@"DCDBE2"];
            break;
        case 1:
            startColor = [UIColor colorWithRGBString:@"D8D7DD"];
            stopColor = [UIColor colorWithRGBString:@"BFBDC9"];
            break;
        case 2:
            startColor = [UIColor colorWithRGBString:@"D8D6E0"];
            stopColor = [UIColor colorWithRGBString:@"FFFEFF"];
            break;
    }
    gradientLayer.colors = @[(id)startColor.CGColor, (id)stopColor.CGColor];
}

@end
