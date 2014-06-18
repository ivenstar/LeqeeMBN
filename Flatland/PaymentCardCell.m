//
//  PaymentCardCell.m
//  Flatland
//
//  Created by Stefan Aust on 14.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "PaymentCardCell.h"

#define SELECTION_IMAGE_TAG 13

@implementation PaymentCardCell

- (void)setPaymentCard:(PaymentCard *)paymentCard {
    self.cardHolderLabel.text = paymentCard.cardHolder;
    NSString *cardNumber = paymentCard.cardNumber;
    if ([cardNumber length] == 4) {
        cardNumber = [@"**** **** **** " stringByAppendingString:cardNumber];
    }
    self.cardNumberLabel.text = cardNumber;
    self.expirationDateLabel.text = [NSString stringWithFormat:@"%02d / %04d", paymentCard.expirationMonth, paymentCard.expirationYear];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    ((UIImageView *)[self viewWithTag:SELECTION_IMAGE_TAG]).highlighted = selected;
}

@end
