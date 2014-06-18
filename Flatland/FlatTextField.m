//
//  FlatTextField.m
//  Flatland
//
//  Created by Stefan Aust on 13.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatTextField.h"
#import <QuartzCore/QuartzCore.h>
#import "ErrorIndicatorButton.h"
@implementation FlatTextField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self awakeFromNib];
    return self;
}

- (void)awakeFromNib {
    self.borderStyle = UITextBorderStyleNone;
    self.layer.cornerRadius = 8;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor colorWithRGBString:@"B1AEBF"] CGColor];
}

// because we set the border to UITextBorderStyleNone, we need to add the original insets
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset([super textRectForBounds:bounds], 7, 2);
}

// because we set the border to UITextBorderStyleNone, we need to add the original insets
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset([super editingRectForBounds:bounds], 7, 2);
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    [[UIColor redColor] setFill];
    [super drawPlaceholderInRect:rect];
}

- (void) markAsInvalid:(NSString *)errorMesage {
    self.layer.borderColor = [[UIColor colorWithRGBString:@"E03E1F"] CGColor];
    if(!self.rightView) {
        ErrorIndicatorButton *errorButton = [ErrorIndicatorButton buttonWithType:UIButtonTypeCustom];
        [self setRightView:errorButton];
        [self setRightViewMode:UITextFieldViewModeAlways];
    }
    ((ErrorIndicatorButton *)self.rightView).errorMessage = errorMesage;
}

- (void) markAsValid {
    self.layer.borderColor = [[UIColor colorWithRGBString:@"B1AEBF"] CGColor];
    [self setRightView:nil];
}

@end
