//
//  PaymentCard.h
//  Flatland
//
//  Created by Stefan Aust on 14.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Represents a payment card.
 */
@interface PaymentCard : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *cardHolder;
@property (nonatomic, copy) NSString *cardNumber;
@property (nonatomic, assign) NSInteger expirationMonth;
@property (nonatomic, assign) NSInteger expirationYear;

- (id)initWithJSONValue:(id)JSONValue;

@end
