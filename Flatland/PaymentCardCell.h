//
//  PaymentCardCell.h
//  Flatland
//
//  Created by Stefan Aust on 14.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentCard.h"

/**
 * Displays payment card information as part of the PaymentCardsViewController.
 */
@interface PaymentCardCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *cardHolderLabel;
@property (nonatomic, weak) IBOutlet UILabel *cardNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *expirationDateLabel;

- (void)setPaymentCard:(PaymentCard *)paymentCard;

@end
