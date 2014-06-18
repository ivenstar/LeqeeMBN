//
//  RoundButton.m
//  Flatland
//
//  Created by Ionel Pascu on 10/22/13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "RoundButton.h"

@implementation RoundButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.layer.cornerRadius = 10;
        //[self setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:UIControlStateSelected];
        //[self setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:UIControlStateHighlighted];
        //[self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        //self.but1.layer.cornerRadius = 10;
        //self.layer.masksToBounds = YES;
        //self.clipsToBounds = YES;
        //[self.titleLabel setFont:[UIFont systemFontOfSize:7.0f]];
        //self.layer.borderColor = [UIColor clearColor].CGColor;
        //self.layer.borderWidth = 1;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor colorWithRed:(52.0 / 255.0) green:(48.0 / 255.0) blue:(78.0 / 255.0) alpha:1] forState:UIControlStateNormal];
        NSLog(@"doloress");
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (id) init{
    self = [super init];
    if (self){
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor colorWithRed:(52.0 / 255.0) green:(48.0 / 255.0) blue:(78.0 / 255.0) alpha:1] forState:UIControlStateNormal];
    NSLog(@"doloress");
    }
    return self;
}
- (void) viewDidLoad{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor colorWithRed:(52.0 / 255.0) green:(48.0 / 255.0) blue:(78.0 / 255.0) alpha:1] forState:UIControlStateNormal];
    NSLog(@"doloress");
}

@end
