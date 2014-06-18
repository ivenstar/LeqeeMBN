//
//  FlatButton.m
//  Flatland
//
//  Created by Stefan Aust on 13.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatButtonSmall.h"

@implementation FlatButtonSmall {
    NSMutableArray *_backgroundColors;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self awakeFromNib];
    return self;
}

- (void)awakeFromNib {
}
@end
