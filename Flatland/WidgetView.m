//
//  WidgetView.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 30.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WidgetView.h"
#import <QuartzCore/QuartzCore.h>

@implementation WidgetView


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

- (void)setupWithFrame:(CGRect)frame {
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    self.layer.borderColor = [UIColor colorWithRGBString:@"#9D9D9D"].CGColor;
    self.layer.borderWidth = 1;
    
    
}
/*
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    float HEIGHTOFPOPUPTRIANGLE = 20;
    float WIDTHOFPOPUPTRIANGLE = 40;
    float borderRadius = 8;
    float strokeWidth = 3;
    
    
    CGRect currentFrame = self.bounds;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, strokeWidth);
    //CGContextSetStrokeColorWithColor(context, (__bridge CGColorRef)([CIColor colorWithRed:100 green:100 blue:100 alpha:1]));
    //CGContextSetFillColorWithColor(context, (__bridge CGColorRef)([CIColor colorWithRed:100 green:100 blue:100 alpha:1]));

    // Draw and fill the bubble
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, borderRadius + strokeWidth + 0.5f, strokeWidth + HEIGHTOFPOPUPTRIANGLE + 0.5f);
    CGContextAddLineToPoint(context, round(currentFrame.origin.x) + 0.5f, HEIGHTOFPOPUPTRIANGLE + strokeWidth + 0.5f);
    CGContextAddLineToPoint(context, round(currentFrame.origin.x) + 0.5f + WIDTHOFPOPUPTRIANGLE / 2.0f, strokeWidth + 0.5f);
    CGContextAddLineToPoint(context, round(currentFrame.origin.x + WIDTHOFPOPUPTRIANGLE) + 0.5f, HEIGHTOFPOPUPTRIANGLE + strokeWidth + 0.5f);
    CGContextAddArcToPoint(context, currentFrame.size.width - strokeWidth - 0.5f, strokeWidth + HEIGHTOFPOPUPTRIANGLE + 0.5f, currentFrame.size.width - strokeWidth - 0.5f, currentFrame.size.height - strokeWidth - 0.5f, borderRadius - strokeWidth);
    CGContextAddArcToPoint(context, currentFrame.size.width - strokeWidth - 0.5f, currentFrame.size.height - strokeWidth - 0.5f, round(currentFrame.size.width / 2.0f + WIDTHOFPOPUPTRIANGLE / 2.0f) - strokeWidth + 0.5f, currentFrame.size.height - strokeWidth - 0.5f, borderRadius - strokeWidth);
    CGContextAddArcToPoint(context, strokeWidth + 0.5f, currentFrame.size.height - strokeWidth - 0.5f, strokeWidth + 0.5f, HEIGHTOFPOPUPTRIANGLE + strokeWidth + 0.5f, borderRadius - strokeWidth);
    CGContextAddArcToPoint(context, strokeWidth + 0.5f, strokeWidth + HEIGHTOFPOPUPTRIANGLE + 0.5f, currentFrame.size.width - strokeWidth - 0.5f, HEIGHTOFPOPUPTRIANGLE + strokeWidth + 0.5f, borderRadius - strokeWidth);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}
 */

@end
