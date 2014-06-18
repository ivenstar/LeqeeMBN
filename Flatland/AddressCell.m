//
//  AddressCell.m
//  Flatland
//
//  Created by Stefan Aust on 22.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "AddressCell.h"

#define SELECTION_IMAGE_TAG 13

@implementation AddressCell

- (void)setAddress:(Address *)address {
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@ %@", address.localizedTitle, address.firstName, address.lastName];
    self.streetLabel.text = address.street;
    self.cityLabel.text = [NSString stringWithFormat:@"%@ %@", address.ZIP, address.city];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    ((UIImageView *)[self viewWithTag:SELECTION_IMAGE_TAG]).highlighted = selected;
}

@end
