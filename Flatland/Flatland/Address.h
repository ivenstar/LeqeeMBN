//
//  Address.h
//  Flatland
//
//  Created by Stefan Aust on 22.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AddressTitle) {
    AddressTitleNone = 0,
    AddressTitleMadam = 1,
    AddressTitleMister = 2,
};

@interface Address : NSObject

@property (nonatomic, assign) AddressTitle title;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *streetExtra;
@property (nonatomic, strong) NSString *ZIP;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *phone;

- (NSString *)titleString;

@end
