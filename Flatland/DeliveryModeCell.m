//
//  DeliveryModeCell.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 29.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "DeliveryModeCell.h"
#import "Colizen.h"

#define SELECTION_IMAGE_TAG 13

@implementation DeliveryModeCell

- (void)setDeliveryMode:(DeliveryMode *)deliveryMode
{
    [self setDeliveryMode:deliveryMode forOrder:[Order sharedOrder]];
}

- (void)setDeliveryMode:(DeliveryMode *)deliveryMode forOrder:(Order*) order
{
    self.nameLabel.text = deliveryMode.name;
    self.priceLabel.text = FormatPrice([order priceForDeliveryMode:deliveryMode]);
    self.line1Label.text = @""; //deliveryMode.line1;
    self.line2Label.text = deliveryMode.line2;
    self.line3Label.text = deliveryMode.line3;
    self.line4Label.text = deliveryMode.line4;
    
    NSDate *deliveryDate = [deliveryMode deliveryDate];
    if (!deliveryDate) {
        deliveryDate = order.rendezvousDate;
    }
    
    // reset positions
    CGRect frame;
    frame = self.line2Label.frame;
    frame.size.height = 15;
    self.line2Label.frame = frame;
    self.line2Label.numberOfLines = 1;
    frame = self.dateLabel.frame;
    frame.origin = CGPointMake(155, 45);
    
    if ([deliveryMode.ID isEqualToString:@"Colizen"]) {
        // do we already have a date or are we asking for a date?
        if (deliveryDate) {
            self.line2Label.text = @"";
            self.line3Label.text = @"";
            self.line4Label.text = @"";
            frame = self.dateLabel.frame;
            frame.origin = self.line2Label.frame.origin;
            self.dateLabel.frame = frame;
        } else {
            frame = self.line2Label.frame;
            frame.size.height = 45;
            self.line2Label.frame = frame;
            self.line2Label.numberOfLines = 0;
            self.line2Label.text = T(@"%cart.colizen.select");
            self.line3Label.text = @"";
            self.line4Label.text = @"";
        }
    }
    
    if (deliveryDate) {
        NSDateFormatter *deliveryDateFormat = [[NSDateFormatter alloc] init];
        [deliveryDateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[NSString stringWithFormat:@"%@_%@", T(@"%general.language"), kCountryCode]]];
        [deliveryDateFormat setDateFormat: @"EEEE d MMMM"];
        self.dateLabel.text = [deliveryDateFormat stringFromDate:deliveryDate];
        
        if ([deliveryMode.ID isEqualToString:@"Colizen"]) {
            NSInteger hours = [Colizen hoursFromDate:deliveryDate];
            self.dateLabel.text = [self.dateLabel.text stringByAppendingFormat:@" entre %02dh00 - %02dh00*", hours, hours + 2];
        } else {
            self.dateLabel.text = [self.dateLabel.text stringByAppendingString:@"*"];
        }
    } else {
        self.dateLabel.text = @"–";
    }
    
    // Remove expected delivery date
    [self.dateLabel setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    ((UIImageView *)[self viewWithTag:SELECTION_IMAGE_TAG]).highlighted = selected;
}

@end
