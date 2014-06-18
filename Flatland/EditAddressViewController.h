//
//  EditAddressViewController.h
//  Flatland
//
//  Created by Stefan Aust on 27.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"
#import "Address.h"

/**
 * Edits an existing delivery address or billing address.
 */
@interface EditAddressViewController : FlatViewController <UITextFieldDelegate>

@property (nonatomic, assign) AddressMode mode;
@property (nonatomic, strong) Address *address;

@end
