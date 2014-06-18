//
//  OrderSummaryDeliveryModeCell.h
//  Flatland
//
//  Created by Bogdan Chitu on 02/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryMode.h"
#import "Order.h"

@interface OrderSummaryDeliveryModeCell : UITableViewCell

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
