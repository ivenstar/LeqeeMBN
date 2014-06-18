//
//  PaymentData.h
//  Flatland
//
//  Created by Stefan Matthias Aust on 29.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentData : NSObject

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *paymentURL;

- (id)initWithJSONValue:(id)JSONValue;

@end
