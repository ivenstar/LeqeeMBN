//
//  FlatBackgroundView.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 19.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatBackgroundView.h"
#import <QuartzCore/QuartzCore.h>

@implementation FlatBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self awakeFromNib];
    return self;
}

- (void)awakeFromNib {
    self.layer.cornerRadius = 8;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 0;
    self.layer.shadowOpacity = .2;
}

@end
