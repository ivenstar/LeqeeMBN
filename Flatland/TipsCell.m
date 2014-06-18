//
//  TipsCell.m
//  Flatland
//
//  Created by Magdalena Kamrowska on 29.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "TipsCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TipsCell

- (void)configure {
    _titleLabel.text = _tip.title;
    [_titleLabel setFont:[UIFont regularFontOfSize:18]];
    
    switch (_tip.ageStep.integerValue) {
        case 0:
            _categoryIndicator.backgroundColor = [UIColor colorWithRGBString:@"C666E5"];
            _titleLabel.textColor = [UIColor colorWithRGBString:@"C666E5"];
            break;
        case 4:
            _categoryIndicator.backgroundColor = [UIColor colorWithRGBString:@"C7B2B8"];
            _titleLabel.textColor = [UIColor colorWithRGBString:@"C7B2B8"];
            break;
        case 6:
            _categoryIndicator.backgroundColor = [UIColor colorWithRGBString:@"A4D3E7"];
            _titleLabel.textColor = [UIColor colorWithRGBString:@"A4D3E7"];
            break;
        case 8:
            _categoryIndicator.backgroundColor = [UIColor colorWithRGBString:@"EFD95C"];
            _titleLabel.textColor = [UIColor colorWithRGBString:@"EFD95C"];
            break;
        case 12:
            _categoryIndicator.backgroundColor = [UIColor colorWithRGBString:@"C3D29B"];
            _titleLabel.textColor = [UIColor colorWithRGBString:@"C3D29B"];
            break;
        case 18:
            _categoryIndicator.backgroundColor = [UIColor colorWithRGBString:@"91B8A6"];
            _titleLabel.textColor = [UIColor colorWithRGBString:@"91B8A6"];
            break;
        default:
            break;
    }
    self.shadowView.layer.cornerRadius = 5;
    self.shadowView.layer.masksToBounds = YES;
    [self.shadowView setNeedsDisplay];
    
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    [self.bgView setNeedsDisplay];
}

@end
