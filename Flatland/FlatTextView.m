//
//  FlatTextView.m
//  Flatland
//
//  Created by Stefan Aust on 14.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatTextView.h"
#import <QuartzCore/QuartzCore.h>

@implementation FlatTextView {
    UILabel *_placeholderLabel;
}

- (void)awakeFromNib {
    self.layer.cornerRadius = 8;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor colorWithRGBString:@"B1AEBF"] CGColor];
    self.contentInset = UIEdgeInsetsMake(2, 7, 2, 7);
    
    self.placeholder = self.text; // take predefined text as placeholder
    self.text = @"";
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (![_placeholder isEqualToString:placeholder]) {
        _placeholder = placeholder;
        if (!_placeholderLabel && [placeholder length]) {
            _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width - 16, self.font.lineHeight)];
            _placeholderLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            _placeholderLabel.font = self.font;
            _placeholderLabel.textColor = [UIColor colorWithRGBString:@"BEBCCF"];
            _placeholderLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:_placeholderLabel];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(didChange:)
                                                         name:UITextViewTextDidChangeNotification
                                                       object:self];
        }
        _placeholderLabel.text = self.placeholder;
    }
}

- (void)didChange:(NSNotification *)notification {
    if (_placeholderLabel.hidden) {
        if (![self.text length]) {
            _placeholderLabel.hidden = NO;
        }
    } else {
        if ([self.text length]) {
            _placeholderLabel.hidden = YES;
        }
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

@end
