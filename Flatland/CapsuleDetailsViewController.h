//
//  CapsuleDetailsViewController.h
//  Flatland
//
//  Created by Stefan Aust on 21.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "OrderAwareViewController.h"
#import "Capsule.h"

/**
 * Displays detail information about a single capsule type and allows the user to call the support
 */
@interface CapsuleDetailsViewController : OrderAwareViewController

@property (nonatomic, strong) Capsule *capsule;

@end
