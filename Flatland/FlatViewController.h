//
//  FlatViewController.h
//  Flatland
//
//  Created by Stefan Aust on 14.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

/**
 * Provides support for a custom graphical back button.
 *
 * Provides support for shrinking a scroll view if the keyboard opens.
 * Must overwrite -formScrollView to activate
 */
// Ionel: inherit GAI view controller to be able to give names to visited view controllers
@interface FlatViewController : GAITrackedViewController

// returns the scroll view that will be shrunken if the keyboard appears
- (UIScrollView *)formScrollView;

// required by the graphical back button
- (IBAction)goBack;

// useful for modal dialogs
- (IBAction)dismiss;

// as a last resort, display an alert view with an error message
- (void)showError:(NSError *)error;

// tell the user that something isn't implemented yet
- (void)notYetImplementedError;

// show the message for one second, then dismiss
- (void)dismissWithMessage:(NSString *)message;

@end
