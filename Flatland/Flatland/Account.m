//
//  Account.m
//  Flatland
//
//  Created by Stefan Aust on 22.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Account.h"
#import "RESTService.h"
#import "Baby.h"


@implementation Account

static NSString *kUserDefaultsAccount = @"account";
NSString *const AccountChangedNotification = @"AccountChangedNotification";

static Account *account = nil;

+ (Account *)activeAccount {
    if (!account) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAccount];
        if (data) {
            account = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return account;
}

+ (void)setActiveAccount:(Account *)newAccount {
    account = newAccount;
    if(account) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:account] forKey:kUserDefaultsAccount];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsAccount];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        _accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
        _email = [aDecoder decodeObjectForKey:@"email"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
    [aCoder encodeObject:self.email forKey:@"email"];
}

/// notify the observers and save the current state of the account
- (void)notifyObserversAndSaveState {
    [[NSNotificationCenter defaultCenter] postNotificationName:AccountChangedNotification object:self];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:account] forKey:kUserDefaultsAccount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isLoggedIn {
    return self.accessToken != nil;
}

- (void)logout {
    // reset the access token
    self.accessToken = nil;
    //... and save
    [self notifyObserversAndSaveState];
}

/// Login with email and password.
///
/// Calls the completion block with success or error state (and swallows any error message).
/// Saves the access token assigned by the server for future requests.
+ (void)login:(LoginData *)loginData completion:(void (^)(BOOL success))completion {
    [[RESTService sharedService]
     queueRequest:[RESTRequest postURL:@"/login" object:[loginData data]]
     completion:^(RESTRequest *request) {
         if (request.statusCode == 200 && [[request.object valueForKey:@"success"] boolValue]) {
             
             // there should be a token
             id token = [request.object valueForKey:@"token"];
             if (token == [NSNull null]) {
                 token = nil;
             }
             
             //save active account
             Account *newAccount = [Account new];
             newAccount.email = loginData.email;
             newAccount.accessToken = token;
             [Account setActiveAccount:newAccount];
             
             completion(YES);
         } else {
             completion(NO);
         }
     }];
}





+ (void)register:(RegistrationData *)registrationData completion:(void (^)(BOOL success))completion {
    [[RESTService sharedService]
     queueRequest:[RESTRequest postURL:@"/register/user" object:[registrationData data]]
     completion:^(RESTRequest *request) {
         if (request.statusCode == 200 && [[request.object valueForKey:@"success"] boolValue]) {
             
             LoginData *loginData = [LoginData new];
             loginData.email = registrationData.email;
             loginData.password = registrationData.password;
             [Account login:loginData completion:^(BOOL success) {
                 completion(success);
             }];
         } else {
             completion(NO);
         }
     }];
}

+ (void)recoverPasswordForEmail:(NSString *)email completion:(void (^)(BOOL))completion {
    id object = [NSDictionary dictionaryWithObject:email forKey:@"email"];

    [[RESTService sharedService]
     queueRequest:[RESTRequest postURL:@"/login/recover" object:object]
     completion:^(RESTRequest *request) {
         if (request.statusCode == 200 && [[request.object valueForKey:@"success"] boolValue]) {
             completion(YES);
         } else {
             completion(NO);
         }
     }];
    
}

- (void)loadBabies:(void (^)(BOOL))completion {
    if (self.babies) {
        completion(YES);
    } else {
        [[RESTService sharedService] queueRequest:[RESTRequest getURL:@"/babies"] completion:^(RESTRequest *request) {
            if (!request.error) {
                NSArray *jsonBabies = ArrayFromJSONObject(request.object);
                NSMutableArray *babies = [[NSMutableArray alloc] initWithCapacity:[jsonBabies count]];
                for (id jsonBaby in request.object) {
                    [babies addObject:[[Baby alloc] initWithJSONObject:jsonBaby]];
                    
                }
                self.babies = [babies copy];
                completion(YES);
            } else {
                completion(NO);
            }
        }];
    }
}

@end
