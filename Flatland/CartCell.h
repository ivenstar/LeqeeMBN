//
//  CartCell.h
//  Flatland
//
//  Created by Stefan Matthias Aust on 25.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

/**
 * Displays an order item as part of the `CartViewController`, `CartSummaryViewController`,
 * `PaymentConfirmationViewController` and the `CapsulesRecommendationViewController`.
 */
@interface CartCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *capsuleImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *sizeLabel;
@property (nonatomic, weak) IBOutlet UILabel *quantityLabel;
@property (nonatomic, weak) IBOutlet UILabel *capsuleCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;

- (void)setOrderItem:(OrderItem *)orderItem;

@end
