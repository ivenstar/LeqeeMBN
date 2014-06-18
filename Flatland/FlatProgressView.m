//
//  FlatProgressView.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 29.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//
#import "FlatProgressView.h"
#import <QuartzCore/QuartzCore.h>


@interface FlatProgressView()

@end

@implementation FlatProgressView {
    CALayer *barLayer;
}

- (void)setupWithFrame:(CGRect)frame {
    _progress = 0.0;
    
    self.layer.cornerRadius = frame.size.height/2.0;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.layer.backgroundColor = [UIColor colorWithRGBString:@"#D8D7E0"].CGColor;
   
    barLayer = [[CALayer alloc]initWithLayer:self.layer];
    barLayer.frame = CGRectMake(0, 0, _progress * frame.size.width, frame.size.height);
    barLayer.backgroundColor = [UIColor colorWithRGBString:@"#9793bb"].CGColor;
    
    [self.layer addSublayer:barLayer];
}

- (void)setProgress:(float)progress {
    _progress = progress;
    barLayer.frame = CGRectMake(0,0,progress*self.frame.size.width,self.frame.size.height);
}

- (void)setProgressBarColor:(UIColor *)color {
	barLayer.backgroundColor = color.CGColor;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithFrame:frame];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupWithFrame:self.frame];
    }
    return self;
}
@end
