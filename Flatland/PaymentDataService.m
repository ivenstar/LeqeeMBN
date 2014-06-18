//
//  PaymentDataService.m
//  Flatland
//
//  Created by Magdalena Kamrowska on 05.07.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "PaymentDataService.h"
#import "User.h"
#import "RESTService.h"

@implementation PaymentURLData

@end

@implementation PaymentDataService

+ (void)getPaymentDataCompletion:(void (^)(PaymentURLData *paymentData))completion {
    static PaymentDataService *service = nil;
    if(!service) {
        service = [PaymentDataService new];
        [[User activeUser] getWifiPaymentURLCompletion:^(BOOL success, NSString *paymentURL) {
            NSLog(@"%@", paymentURL);
            if(success) {
                NSString* deviceID = DeviceID();
                NSString* countryCode = kCountryCode;
                NSString *attributedURL = [NSString stringWithFormat:@"%@?token=%@&device=%@&country=%@", paymentURL , [User activeUser].accessToken, deviceID, countryCode];
                //NSString *attributedURL = [NSString stringWithFormat:@"%@?token=%@&device=%@", paymentURL , @"", @""];
                NSURL *URL = [NSURL URLWithString:attributedURL];
                
                // load the web page of the payment provider; see delegate method for how to proceed
                service.paymentData = [PaymentURLData new];
                service.paymentData.paymentURL = URL;
                service.paymentData.cleanedURLstring = [[attributedURL stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
                completion(service.paymentData);
            }
            else {
                completion(nil);
            }
        }];
    } else {
        [[User activeUser] getWifiPaymentURLCompletion:^(BOOL success, NSString *paymentURL) {
            NSLog(@"%@", paymentURL);
            if(success) {
                NSString* deviceID = DeviceID();
                NSString* countryCode = kCountryCode;
                NSString *attributedURL = [NSString stringWithFormat:@"%@?token=%@&device=%@&country=%@", paymentURL , [User activeUser].accessToken, deviceID, countryCode];
                NSURL *URL = [NSURL URLWithString:attributedURL];
                
                // load the web page of the payment provider; see delegate method for how to proceed
                service.paymentData = [PaymentURLData new];
                service.paymentData.paymentURL = URL;
                service.paymentData.cleanedURLstring = [[attributedURL stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
                completion(service.paymentData);
            }
            else {
                completion(nil);
            }
            completion(service.paymentData);
        }];
    }
}

@end
