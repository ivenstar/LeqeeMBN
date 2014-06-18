//
//  CartAddBillingAddressViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CartAddBillingAddressViewController.h"
#import "BabyNesCountryPicker.h"
#import "State.h"
#import "User.h"

@implementation CartAddBillingAddressViewController


- (AddressMode)mode {
    return AddressModeBillingAddress;
}

- (void)didSaveAddress:(Address *)address {
    [Order sharedOrder].billingAddressID = address.ID;
    [Order sharedOrder].billingAddress = address;
    [self dismissWithMessage:T(@"%general.added")];
}



@end
