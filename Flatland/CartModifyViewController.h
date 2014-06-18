//
//  CartModifyViewController.h
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"
#import "CartModifyViewControllerDelegate.h"

/**
 * Allows the user to modify the quantity of an order item.
 * Informs a `CartModifyViewControllerDelegate` about quantity changes.
 */
@interface CartModifyViewController : FlatViewController

@property (nonatomic, assign) NSUInteger price;
@property (nonatomic, assign) NSUInteger quantity;
@property (nonatomic, weak) id<CartModifyViewControllerDelegate> delegate;

@end