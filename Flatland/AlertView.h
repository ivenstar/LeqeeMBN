//
//  AlertView.h
//  AlertViews
//
//  Created by Stefan Matthias Aust on 21.08.12.
//  Copyright (c) 2012 I.C.N.H GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Provides an easier to use API for UIAlertView.
 */
@interface AlertView : NSObject

/**
 * Constructs an alert view with an optional title, a message and one or more buttons.
 *
 * If a block is given, it is called with the index of the tapped button.
 *
 * @param title         the receiver's title or nil
 * @param message       the receiver's message
 * @param buttonTitles  a list of title strings; the array must contain at least one string
 * @param buttonClicked a callback block or nil; called with the index of the button that was taped
 */
+ (AlertView *)alertViewWithTitle:(NSString *)title
                          message:(NSString *)message
                     buttonTitles:(NSArray *)buttonTitles
                    buttonClicked:(void(^)(NSInteger buttonIndex))buttonClicked;

/**
 * Constructs an alert view from the given string which must separate title, message and buttons by "|".
 *
 * If a block is given, it is called with the index of the tapped button.
 *
 * @param string        title, message and button titles, separated by "|"
 * @param buttonClicked a callback block or nil; called with the index of the button that was taped
 */
+ (AlertView *)alertViewFromString:(NSString *)string
                     buttonClicked:(void(^)(NSInteger buttonIndex))buttonClicked;

/// displays the alert view
- (void)show;

@end
