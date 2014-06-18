//
//  FlatRadioButtonGroup.m
//  Flatland
//
//  Created by Stefan Aust on 13.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatRadioButtonGroup.h"
#import "FlatButton.h"
#import "ErrorIndicatorButton.h"

@interface FlatRadioButtonGroup ()

@end

@implementation FlatRadioButtonGroup {
    ErrorIndicatorButton *_errorButton;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self awakeFromNib];
    return self;
}

- (void)awakeFromNib {
    _gap = 10;
    _selectedIndex = -1;
    
    NSMutableArray *buttons = [NSMutableArray array];
    for (UIButton *button in self.subviews) {
        [buttons addObject:button];
    }
    self.buttons = buttons;
    _errorButton = nil;
}

- (void)setGap:(NSInteger)gap {
    if (_gap != gap) {
        _gap = gap;
        [self refreshButtons];
    }
}

- (void)setButtons:(NSArray *)buttons {
    if (_buttons != buttons) {
        _buttons = buttons;
        [self refreshButtons];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        [self refreshState];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void) addButton:(UIButton*) button
{
    NSMutableArray *buttons = [NSMutableArray arrayWithArray:self.buttons];
    [buttons addObject:button];
    [self addSubview:button];
    self.buttons = buttons;
}

- (void)refreshButtons {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    NSUInteger index = 0;
    for (UIButton *b in self.buttons) {
        FlatButton *button = [[FlatButton alloc] initWithFrame:CGRectZero];
        [button setTitle:[b titleForState:UIControlStateNormal] forState:UIControlStateNormal];
        [button setImage:[b imageForState:UIControlStateNormal] forState:UIControlStateNormal];
        [button setImageEdgeInsets:b.imageEdgeInsets];
        [button setContentEdgeInsets:b.contentEdgeInsets];
        [button setTag:index++];
        [button addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:button];
        if(_buttons.count == 1) {
            [button setEnabled:NO];
        } else {
            [button setEnabled:YES];
        }
    }
    
    [self icnhLocalizeSubviews];
    [self refreshState];
    [self setNeedsLayout];
}

- (void)refreshState {
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[ErrorIndicatorButton class]]) {
            continue;
        }
        button.selected = button.tag == self.selectedIndex;
    }
}

- (void)layoutSubviews {
    NSInteger count = [self.subviews count];
    count = count - (_errorButton ? 1 : 0);
    if (count > 0) {
        CGFloat width = self.bounds.size.width - (_errorButton ? _errorButton.frame.size.width : 0);
        CGFloat height = self.bounds.size.height;
        
        CGFloat buttonWidth = (width - (count - 1) * self.gap) / count;
        CGRect frame = CGRectZero;
        for (UIView *view in self.subviews) {
            if([view isKindOfClass:[ErrorIndicatorButton class] ] ){
                continue;
            }
            frame.size.width = buttonWidth;
            frame.size.height = height;
        
            view.frame = frame;
            frame.origin.x += frame.size.width + self.gap;
            if (frame.origin.x + frame.size.width > width) {
                frame.origin.x = width - frame.size.width;
            }
        }
    }
    
    if (_errorButton) {
        CGRect frame = _errorButton.frame;
        frame.origin.x = self.bounds.size.width - _errorButton.frame.size.width;
        frame.origin.y = self.bounds.size.height / 2 - _errorButton.frame.size.height / 2;
        _errorButton.frame = frame;
    }
}

- (void)pressed:(UIButton *)sender {
    self.selectedIndex = sender.tag;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"groupButtonPressed" object:nil];
}

- (void) markAsInvalid:(NSString *)errorMesage {
    if (!_errorButton) {
        _errorButton = [ErrorIndicatorButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_errorButton];
    }
    _errorButton.errorMessage = errorMesage;
}

- (void) markAsValid {
    [_errorButton removeFromSuperview];
    _errorButton = nil;
}

@end
