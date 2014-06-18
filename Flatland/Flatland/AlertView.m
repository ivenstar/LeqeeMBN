//
//  AlertView.m
//  AlertViews
//
//  Created by Stefan Matthias Aust on 21.08.12.
//  Copyright (c) 2012 I.C.N.H GmbH. All rights reserved.
//

#import "AlertView.h"

@interface AlertView () <UIAlertViewDelegate>

@end

@implementation AlertView
{
    UIAlertView *_view;
    AlertView *_keepAlive;
    void (^_buttonClicked)(NSInteger);
}

+ (AlertView *)alertViewWithTitle:(NSString *)title
                          message:(NSString *)message
                     buttonTitles:(NSArray *)buttonTitles
                    buttonClicked:(void(^)(NSInteger buttonIndex))buttonClicked {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    if ([buttonTitles count] < 1) {
        [NSException raise:NSInvalidArgumentException format:@"Need at least one button title"];
    }
    for (NSString *title in buttonTitles) {
        [alertView addButtonWithTitle:title];
    }
    return [[AlertView alloc] initWithAlertView:alertView buttonClicked:buttonClicked];
}

+ (AlertView *)alertViewFromString:(NSString *)string
                     buttonClicked:(void(^)(NSInteger buttonIndex))buttonClicked {
    NSArray *components = [string componentsSeparatedByString:@"|"];
    if ([components count] < 3) {
        [NSException raise:NSInvalidArgumentException format:@"Need at least 3 parts separated by | in '%@'", string];
    }
    return [self alertViewWithTitle:[components objectAtIndex:0]
                            message:[components objectAtIndex:1]
                       buttonTitles:[components subarrayWithRange:NSMakeRange(2, [components count] - 2)]
                      buttonClicked:buttonClicked];
}

- (id)initWithAlertView:(UIAlertView *)alertView buttonClicked:(void (^)(NSInteger))buttonClicked {
    self = [self init];
    if (self) {
        _view = alertView;
        _view.cancelButtonIndex = 0;
        if (buttonClicked) {
            _buttonClicked = buttonClicked;
            _keepAlive = self;
            alertView.delegate = self;
        }
    }
    return self;
}

- (void)show {
    [_view show];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_buttonClicked) {
        _buttonClicked(buttonIndex);
    }
    _keepAlive = nil;
}

@end
