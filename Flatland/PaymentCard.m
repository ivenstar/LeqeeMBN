//
//  PaymentCard.m
//  Flatland
//
//  Created by Stefan Aust on 14.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "PaymentCard.h"

@implementation PaymentCard

- (id)initWithJSONValue:(id)JSONValue {
    self = [self init];
    if (self) {
        self.ID = JSONValue[@"id"];
        self.cardHolder = JSONValue[@"cardHolder"];
        self.cardNumber = JSONValue[@"cardNumber"];
        self.expirationMonth = [JSONValue[@"expirationMonth"] integerValue];
        self.expirationYear = [JSONValue[@"expirationYear"] integerValue];
    }
    return self;
}

@end
