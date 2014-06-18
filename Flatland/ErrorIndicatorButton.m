//
//  ErrorIndicatorView.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 15.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "ErrorIndicatorButton.h"
#import "AlertView.h"

@implementation ErrorIndicatorButton

- (id)initWithFrame:(CGRect)frame {
    // force the correct size
    //Ionel: commented to fix crash
    //frame.size = [self sizeThatFits:frame.size];
    self = [super initWithFrame:frame];
    [self awakeFromNib];
    return self;
}

- (void)awakeFromNib {
    [self setBackgroundImage:[UIImage imageNamed:@"icon-error"] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(showError:) forControlEvents:UIControlEventTouchUpInside];
    CGRect frame = self.frame;
    frame.size.width = 24;
    frame.size.height = 24;
    self.frame = frame;
}

- (void)showError:(id)sender {
      [[AlertView alertViewFromString: [NSString stringWithFormat: @"%@|%@|OK", T(@"%validationError"), self.errorMessage] buttonClicked:nil] show];
}

@end
