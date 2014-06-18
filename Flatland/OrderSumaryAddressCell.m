//
//  OrderSumaryAddressCell.m
//  Flatland
//
//  Created by Bogdan Chitu on 02/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "OrderSumaryAddressCell.h"

@implementation OrderSumaryAddressCell

- (void)setAddress:(Address *)address {
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", address.firstName, address.lastName];
    self.streetLabel.text = address.street;
    self.cityLabel.text = [NSString stringWithFormat:@"%@ %@", address.ZIP, address.city];
}



@end
