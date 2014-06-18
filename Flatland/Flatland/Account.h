//
//  Account.h
//  Flatland
//
//  Created by Stefan Aust on 22.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "LoginData.h"
#import "RegistrationData.h"

@interface Account : NSObject

@property (nonatomic, copy) NSArray *babies;
/// the global access token which shall be passed with every request
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *email;

/// returns the active account or nil if not logged in
+ (Account *)activeAccount;

+ (void)login:(LoginData *)loginData completion:(void (^)(BOOL success))completion;

+ (void)register:(RegistrationData *)registrationData completion:(void (^)(BOOL success))completion;

+ (void)recoverPasswordForEmail:(NSString *)email completion:(void (^)(BOOL success))completion;

/// logout the user
- (void)logout;

/// YES if the account is logged in otherwise no
- (BOOL)isLoggedIn;

/// loads baby descriptions with capsule recommendations and feeding preferences,
/// calling the completion block once the data is available
- (void)loadBabies:(void (^)(BOOL success))completion;

@end
