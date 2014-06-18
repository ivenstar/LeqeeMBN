//
//  SimpleTextField.m
//  Flatland
//
//  Created by Bogdan Chitu on 23/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "SimpleTextField.h"

@implementation SimpleTextField

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 0);
}



@end
