//
//  PaymentViewController.h
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"

/**
 * Performs the payment using an embedded web page.
 * That page must signal success by redirecting to `ConfirmationDeCommande.aspx`
 * and must signal failure by redirecting to `OrderError.aspx`.
 */
@interface PaymentViewController : FlatViewController

@end
