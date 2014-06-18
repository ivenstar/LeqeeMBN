//
//  AppDelegate.m
//  Flatland
//
//  Created by Stefan Aust on 13.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import "FlatAppearance.h"

#import "Account.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FlatAppearance setup];
    
//    [[Account activeAccount] logout];
//    
//    RegistrationData *data = [RegistrationData new];
//    data.salutation = @"Mr";
//    data.firstName = @"Frodo";
//    data.lastName = @"Beutlin";
//    data.email = @"frodo@dev.isc4u.net";
//    data.password = @"xxxxxx";
//    data.phone = @"0791234455";
//    
//    [[Account activeAccount] register:data completion:^(BOOL success) {
//        if (success) {
//            [[Account activeAccount] loadBabies:^(NSError *error, NSArray *babies) {
//                NSLog(@"%@ %@", error, babies);
//            }];
//        } else {
//            NSLog(@"Registration failed");
//        }
//    }];
//    
//    return YES;
//    
//    [[Account activeAccount] loadBabies:^(NSError *error, NSArray *babies) {
//        if (error.code == 401) {
//            LoginData *data = [LoginData new];
//            data.email = @"sma@icnh.de";
//            data.password = @"xxxxxx";
//            [[Account activeAccount] login:data completion:^(BOOL success) {
//                if (success) {
//                    [[Account activeAccount] loadBabies:^(NSError *error, NSArray *babies) {
//                        NSLog(@"%@ %@", error, babies);
//                    }];
//                } else {
//                    NSLog(@"Login failed");
//                }
//            }];
//        }
//        NSLog(@"%@ %@", error, babies);
//    }];    
    
    return YES;
}

@end
