//
//  RoundedView.m
//  Flatland
//
//  Created by Magdalena Kamrowska on 02.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "RoundedView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    [self setNeedsDisplay];
}

@end
