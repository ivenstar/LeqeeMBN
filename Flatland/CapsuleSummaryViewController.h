//
//  CapsuleSummaryViewController.h
//  Flatland
//
//  Created by Stefan Aust on 15.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "OrderAwareViewController.h"
#import "Capsule.h"

/**
 * Displays summary information about a single capsule type and allows the user to order capsules of that type.
 */
@interface CapsuleSummaryViewController : OrderAwareViewController

@property (nonatomic, strong) Capsule *capsule;

@end
