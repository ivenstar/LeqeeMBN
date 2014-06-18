//
//  PaymentDataService.h
//  Flatland
//
//  Created by Magdalena Kamrowska on 05.07.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentURLData : NSObject

@property (nonatomic, copy) NSURL *paymentURL;
@property (nonatomic, copy) NSString *cleanedURLstring;

@end

@interface PaymentDataService : NSObject

@property (nonatomic, retain) PaymentURLData* paymentData;

+ (void)getPaymentDataCompletion:(void (^)(PaymentURLData *))completion;

@end
