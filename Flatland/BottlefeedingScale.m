//
//  BottlefeedingScale.m
//  Flatland
//
//  Created by Jochen Block on 30.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BottlefeedingScale.h"

@interface BottlefeedingScale()
{
}

@end

@implementation BottlefeedingScale

@synthesize scaleMax;


- (void)drawRect:(CGRect)rect
{
    
    int height = self.frame.size.height;
    
    double position = 10.0;
    int middle = (scaleMax / 2)/10;
    int count = 1;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:52.0f/255.0f green:48.0f/255.0f blue:78.0f/255.0f alpha:1.0f].CGColor);
    
    CGContextMoveToPoint(context, 10, 10);
    CGContextAddLineToPoint(context, 0, 10);
    CGContextMoveToPoint(context, 0, height-1);
    CGContextAddLineToPoint(context, 10, height-1);
    
    CGContextStrokePath(context);
    double offset = (height - 10)/(scaleMax/10.0);
    
    CGContextSetLineWidth(context, 1.0);
    while (position < (height - 10)) {
        position += offset;
        if(count == middle){
            CGContextMoveToPoint(context, 0, position);
            CGContextAddLineToPoint(context, 10, position);
            CGContextStrokePath(context);
        }else{
            CGContextMoveToPoint(context, 5, position);
            CGContextAddLineToPoint(context, 10, position);
            CGContextStrokePath(context);
        }
        count++;
    }    
}

@end
