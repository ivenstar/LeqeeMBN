//
//  AddressCell.h
//  Flatland
//
//  Created by Stefan Aust on 22.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Address.h"

/**
 * Displays a delivery address or billing address as part of the `CartSelectDeliveryAddressViewController`, 
 * `CartSelectBillingAddressViewController`, `CartSummaryViewController`, `PaymentConfirmationViewController`
 * and `AddressesViewController`.
 */
@interface AddressCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *streetLabel;
@property (nonatomic, weak) IBOutlet UILabel *cityLabel;

- (void)setAddress:(Address *)address;

@end
