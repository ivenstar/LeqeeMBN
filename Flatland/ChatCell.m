//
//  ChatCell.m
//  Flatland
//
//  Created by Magdalena Kamrowska on 16.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "ChatCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ChatCell

- (void)roundCorners {
    self.chatBackground.layer.cornerRadius = 5;
    self.chatBackground.layer.masksToBounds = YES;
    [self.chatBackground setNeedsDisplay];
    
    if(![_message response]){
        self.requestBG.layer.cornerRadius = 5;
        self.requestBG.layer.masksToBounds = YES;
        [self.requestBG setNeedsDisplay];
    }
}

- (void)configure {
    self.messageLabel.text = _message.babyMessage;
    [self.messageLabel setFont:[UIFont regularFontOfSize:12]];    
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[NSString stringWithFormat:@"%@_%@", T(@"%general.language"), kCountryCode]]];
    NSString *format = T(@"%coach.timestamp");
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [df setDateFormat:format];
    self.timestampLabel.text = [df stringFromDate:_message.date];
    [self.timestampLabel setFont:[UIFont regularFontOfSize:10]];
    
    // set a cell's height by calculating the description label's height and adding a constant value for the header. This value has to be read within the cell-creating tableView-delegate by creating a cell in the heightForRowAtIndexpath:-method
    CGSize constraints = CGSizeMake((![_message response] ? 250.0f : 200.0f), 2000.0f);
    CGSize size = [self.messageLabel.text sizeWithFont:[UIFont regularFontOfSize:12] constrainedToSize:constraints lineBreakMode:NSLineBreakByWordWrapping];
    [self.messageLabel setFrame:CGRectMake(_messageLabel.frame.origin.x, _messageLabel.frame.origin.y, size.width, size.height)];
    [self.messageLabel setNeedsDisplay];
    CGFloat height = size.height+70.0f;
    CGRect newRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    [self setFrame:newRect];
    
}

@end
