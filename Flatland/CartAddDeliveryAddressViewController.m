//
//  CartAddDeliveryAddressViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CartAddDeliveryAddressViewController.h"
#import "User.h"

@interface CartAddDeliveryAddressViewController ()

@end

#pragma mark

@implementation CartAddDeliveryAddressViewController

- (AddressMode)mode {
    return AddressModeDeliveryAddress;
}

- (void)didSaveAddress:(Address *)address {
    [Order sharedOrder].deliveryAddressID = address.ID;
    [Order sharedOrder].deliveryAddress = address;
    [self dismissWithMessage:T(@"%general.added")];
}

@end
