//
//  BabyNesPhoneTextField.m
//  Flatland
//
//  Created by Bogdan Chitu on 01/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "BabyNesPhoneTextField.h"

@implementation BabyNesPhoneTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectZero;
}

@end
