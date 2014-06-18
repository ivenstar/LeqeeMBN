//
//  OrderSummaryDeliveryModeCell.m
//  Flatland
//
//  Created by Bogdan Chitu on 02/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "OrderSummaryDeliveryModeCell.h"
#import "Colizen.h"

@implementation OrderSummaryDeliveryModeCell


- (void)setDeliveryMode:(DeliveryMode *)deliveryMode
{
    [self setDeliveryMode:deliveryMode forOrder:[Order sharedOrder]];
}

- (void)setDeliveryMode:(DeliveryMode *)deliveryMode forOrder:(Order*) order
{
    self.nameLabel.text = deliveryMode.name;
    self.priceLabel.text = FormatPrice([order priceForDeliveryMode:deliveryMode]);
    self.line1Label.text = deliveryMode.line1;
    self.line2Label.text = deliveryMode.line2;
    self.line3Label.text = deliveryMode.line3;
    self.line4Label.text = deliveryMode.line4;
    
    NSDate *deliveryDate = [deliveryMode deliveryDate];
    if (!deliveryDate)
    {
        deliveryDate = order.rendezvousDate;
    }
    
    if ([deliveryMode.ID isEqualToString:@"Colizen"])
    {
        // do we already have a date or are we asking for a date?
        if (deliveryDate)
        {
            self.line2Label.text = @"";
            self.line3Label.text = @"";
            self.line4Label.text = @"";
        
            CGRect frame = self.dateLabel.frame;
            frame.origin = self.line2Label.frame.origin;
            self.dateLabel.frame = frame;
        }
        else
        {
            CGRect frame = self.line2Label.frame;
            frame.size.height = 45;
            self.line2Label.frame = frame; //?
            
            self.line2Label.numberOfLines = 0;
            self.line2Label.text = T(@"%cart.colizen.select");
            self.line3Label.text = @"";
            self.line4Label.text = @"";
        }
    }
    
    if (deliveryDate)
    {
        
        //fit the delivery date exp title label
        CGRect line1Frame = self.line1Label.frame;
        CGRect dateLabelFrame = self.dateLabel.frame;
        
        line1Frame.size.width = [self.line1Label.text sizeWithFont:self.line1Label.font].width;
        self.line1Label.frame = line1Frame;
        
        NSString* space = @" ";
        GLfloat spaceWidth = [space sizeWithFont:self.line1Label.font].width;
        
        dateLabelFrame.origin.x = line1Frame.origin.x + line1Frame.size.width + spaceWidth;
        self.dateLabel.frame = dateLabelFrame;
        
        //setup dat
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
    }
    else
    {
        self.dateLabel.text = @"–";
    }
    
    // Remove expected delivery date
//    [self.dateLabel setHidden:YES];
}
@end
