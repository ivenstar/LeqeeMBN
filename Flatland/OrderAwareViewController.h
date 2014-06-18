//
//  OrderAwareViewController.h
//  Flatland
//
//  Created by Stefan Matthias Aust on 25.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"
#import "Order.h"

/**
 * Abstract class to deal with the "checkout" cart button that is automatically added to the navigation bar
 * if the shared order object contains order items. It provides access to the shared order via -order and
 * observes the shared order object for changes.
 */
@interface OrderAwareViewController : FlatViewController

/// Returns the shared order object
@property (nonatomic, readonly) Order *order;

- (void)orderChanged:(NSNotification *)notification;

/// The checkout navigation bar button was tapped
- (IBAction)checkout;

@end
