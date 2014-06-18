//
//  WifiAddBillingAddressViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 19.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WifiAddBillingAddressViewController.h"
#import "User.h"

@interface WifiAddBillingAddressViewController ()

@end

@implementation WifiAddBillingAddressViewController

- (AddressMode)mode {
    return AddressModeBillingAddress;
}

- (void)didSaveAddress:(Address *)address {
    [User activeUser].preferredBillingAddressID = address.ID;
    [self dismissWithMessage:T(@"%general.added" )];
}

@end
