//
//  WifiAddDeliveryAddressViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 19.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WifiAddDeliveryAddressViewController.h"
#import "User.h"

@interface WifiAddDeliveryAddressViewController ()

@end

@implementation WifiAddDeliveryAddressViewController

- (AddressMode)mode {
    return AddressModeDeliveryAddress;
}

- (void)didSaveAddress:(Address *)address {
    [User activeUser].preferredDeliveryAddressID = address.ID;
    [self dismissWithMessage:T(@"%general.added")];
}

@end
