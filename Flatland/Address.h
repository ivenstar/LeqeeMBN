//
//  Address.h
//  Flatland
//
//  Created by Stefan Aust on 22.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AddressMode) {
    AddressModeDeliveryAddress,
    AddressModeBillingAddress,
    AddressModePersonalAddress,
};

typedef NS_ENUM(NSInteger, AddressTitle) {
    AddressTitleNone = 0,
    AddressTitleMadam = 1,
    AddressTitleMister = 2,
    AddressTitleMisses = 3
};

/**
 * Represents either a personal address, a delivery address or a billing address.
 */
@interface Address : NSObject

@property (nonatomic, assign) AddressTitle title;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) NSString *streetExtra;
@property (nonatomic, copy) NSString *ZIP;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state; //Only used for BabyNes Wifi US target and billing.Assigned @"null" for other targets
@property (nonatomic, copy) NSString *country; //Only used for billing
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) BOOL preferred;
@property (nonatomic, assign) AddressMode addressMode;

- (id)initWithJSONValue:(id)JSONValue;

- (id)initWithNonCamelCaseJSONValue:(id)JSONValue;

- (id)JSONValue;

- (id)JSONValueNonCamelCase;

- (NSString *)localizedTitle;

@end
