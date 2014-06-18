//
//  PaymentData.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 29.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "PaymentData.h"

@implementation PaymentData

- (id)initWithJSONValue:(id)JSONValue {
    self = [self init];
    self.orderNo = ObjectFromJSONValue(JSONValue[@"id"]);
    self.paymentURL = ObjectFromJSONValue(JSONValue[@"paymentURL"]);
    return self;
}

@end
