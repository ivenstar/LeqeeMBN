//
//  PaymentConfirmationViewController.h
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"
#import "User.h"

/**
 * Displays once again the cart, the delivery address, the billing address and the delivery mode.
 */
@interface PaymentConfirmationViewController : FlatViewController

@property (nonatomic, copy) Order *order; // must be a copy because the shared object will be deallocated

@end
