//
//  Address.m
//  Flatland
//
//  Created by Stefan Aust on 22.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Address.h"

@implementation Address

- (id)initWithJSONValue:(id)JSONValue {
    self = [self init];
    if (self) {
        NSString *salutation = ObjectFromJSONValue(JSONValue[@"salutation"]);
       
        if ([salutation isEqualToString:@"Mr"]) {
            self.title = AddressTitleMister;
        } else if ([salutation isEqualToString:@"Ms"]) {
            self.title = AddressTitleMadam;
        } else if ([salutation isEqualToString:@"Mrs"]) {
            self.title = AddressTitleMisses;
        }else {
            self.title = AddressTitleNone;
        }
        self.firstName = ObjectFromJSONValue(JSONValue[@"firstName"]);
        self.lastName = ObjectFromJSONValue(JSONValue[@"lastName"]);
        self.street = ObjectFromJSONValue(JSONValue[@"street"]);
        self.streetExtra = ObjectFromJSONValue(JSONValue[@"complementaryAddress"]);
        self.ZIP = ObjectFromJSONValue(JSONValue[@"zipCode"]);
        self.city = ObjectFromJSONValue(JSONValue[@"city"]);
        self.mobile = ObjectFromJSONValue(JSONValue[@"mobile"]);
        self.ID = ObjectFromJSONValue(JSONValue[@"id"]);
        self.country = ObjectFromJSONValue(JSONValue[@"country"]);
#ifdef BABY_NES_US
        self.state = ObjectFromJSONValue(JSONValue[@"region"]);
#else
        self.state = @"null";
#endif //BABY_NES_US
        self.preferred = [JSONValue[@"isPreferredAddress"] isKindOfClass:[NSNull class]] ? YES : [(JSONValue[@"isPreferredAddress"]) boolValue];
    }
    return self;
}

- (id)initWithNonCamelCaseJSONValue:(id)JSONValue {
    self = [self init];
    if (self) {
        NSString *salutation = ObjectFromJSONValue(JSONValue[@"salutation"]);
        if ([salutation isEqualToString:@"Mr"]) {
            self.title = AddressTitleMister;
        } else if ([salutation isEqualToString:@"Ms"]) {
            self.title = AddressTitleMadam;
        } else if ([salutation isEqualToString:@"Mrs"]) {
            self.title = AddressTitleMisses;
        }else {
            self.title = AddressTitleNone;
        }
        self.firstName = ObjectFromJSONValue(JSONValue[@"firstname"]);
        self.lastName = ObjectFromJSONValue(JSONValue[@"lastname"]);
        self.street = ObjectFromJSONValue(JSONValue[@"address"]);
        self.streetExtra = ObjectFromJSONValue(JSONValue[@"complementaryaddress"]);
        self.ZIP = ObjectFromJSONValue(JSONValue[@"zipcode"]);
        self.city = ObjectFromJSONValue(JSONValue[@"city"]);
        self.mobile = ObjectFromJSONValue(JSONValue[@"mobile"]);
        self.ID = ObjectFromJSONValue(JSONValue[@"id"]);
        self.country = ObjectFromJSONValue(JSONValue[@"country"]);
#ifdef BABY_NES_US
        self.state = ObjectFromJSONValue(JSONValue[@"region"]);
#endif //BABY_NES_US
        self.preferred = [JSONValue[@"ispreferredaddress"] isKindOfClass:[NSNull class]] ? YES : [(JSONValue[@"ispreferredaddress"]) boolValue];
    }
    return self;
}

- (id)JSONValue {
    id salutation;
    switch (self.title) {
        case AddressTitleNone:
            salutation = [NSNull null];
            break;
        case AddressTitleMadam:
            salutation = @"Ms";
            break;
        case AddressTitleMister:
            salutation = @"Mr";
            break;
        case AddressTitleMisses:
            salutation = @"Mrs";
            break;
    }
    return @{@"salutation": salutation,
             @"firstName": JSONValueFromObject(self.firstName),
             @"lastName": JSONValueFromObject(self.lastName),
             @"street": JSONValueFromObject(self.street),
             @"complementaryAddress": JSONValueFromObject(self.streetExtra),
             @"zipCode": JSONValueFromObject(self.ZIP),
             @"city": JSONValueFromObject(self.city),
             @"mobile": JSONValueFromObject(self.mobile),
             @"country": JSONValueFromObject(self.country),
#ifdef BABY_NES_US
             @"region": JSONValueFromObject(self.state),
#endif //BABY_NES_US
             //@"id": JSONValueFromObject(self.ID),
             @"isPreferredAddress" : @(self.preferred)
             };
    
}

- (id)JSONValueNonCamelCase {
    id salutation;
    switch (self.title) {
        case AddressTitleNone:
            salutation = [NSNull null];
            break;
        case AddressTitleMadam:
            salutation = @"Ms";
            break;
        case AddressTitleMister:
            salutation = @"Mr";
            break;
        case AddressTitleMisses:
            salutation = @"Mrs";
            break;
    }
    return @{@"salutation": salutation,
             @"firstname": JSONValueFromObject(self.firstName),
             @"lastname": JSONValueFromObject(self.lastName),
             @"address": JSONValueFromObject(self.street),
             @"complementaryAddress": JSONValueFromObject(self.streetExtra),
             @"zipcode": JSONValueFromObject(self.ZIP),
             @"city": JSONValueFromObject(self.city),
             @"country": JSONValueFromObject(self.country),
#ifdef BABY_NES_US
             @"region": JSONValueFromObject(self.state),
#endif //BABY_NES_US
             @"mobile": JSONValueFromObject(self.mobile),
             @"id": JSONValueFromObject(self.ID),
             @"ispreferredaddress" : @(self.preferred)};
}


- (NSString *)localizedTitle {
    if (self.title == AddressTitleMadam)
    {
        return T(@"%profile.miss");
    }
    if (self.title == AddressTitleMister)
    {
        return T(@"%profile.mister");
    }
    if (self.title == AddressTitleMisses)
    {
        return T(@"%profile.title.f");
    }
    
    return @"";
}

@end
