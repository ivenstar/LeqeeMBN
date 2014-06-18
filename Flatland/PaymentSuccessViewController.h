//
//  PaymentSuccessViewController.h
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"
#import "User.h"
#import "Order.h"
#import "AlertView.h"

/**
 * Informs the user about a successful payment operation and offers to display the `PaymentConfirmationViewController`.
 */
@interface PaymentSuccessViewController : FlatViewController

@property (nonatomic, copy) Order *order; // must be a copy because the shared object will be deallocated

@end
