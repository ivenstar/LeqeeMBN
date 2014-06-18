//
//  DeliveryModeCell.h
//  Flatland
//
//  Created by Stefan Matthias Aust on 29.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "DeliveryMode.h"
#import "Order.h"

/**
 * Displays a delivery mode as part of the `CartSelectDeliveryModeViewController`, `CartSummaryViewController`,
 * `PaymentConfirmationViewController` and `DeliveryModesViewController`.
 */
@interface DeliveryModeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *line1Label;
@property (nonatomic, weak) IBOutlet UILabel *line2Label;
@property (nonatomic, weak) IBOutlet UILabel *line3Label;
@property (nonatomic, weak) IBOutlet UILabel *line4Label;

- (void)setDeliveryMode:(DeliveryMode *)deliveryMode;
- (void)setDeliveryMode:(DeliveryMode *)deliveryMode forOrder:(Order*) order;

@end
