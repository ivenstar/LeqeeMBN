//
//  DeliveryMode.m
//  Flatland
//
//  Created by Stefan Aust on 24.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "DeliveryMode.h"
#import "Colizen.h"

@implementation DeliveryMode

/// return the delivery mode identified by the given ID
+ (DeliveryMode *)deliveryModeForID:(NSString *)ID {
    for (DeliveryMode *deliveryMode in [self deliveryModes]) {
        if ([deliveryMode.ID isEqualToString:ID]) {
            return deliveryMode;
        }
    }
    return nil;
}

/// return an array with all available delivery modes
+ (NSArray *)deliveryModes {
    static NSArray *deliveryModes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *array = [NSMutableArray array];
        for (id value in GetJSONResource(@"deliveryModes")) {
            [array addObject:[[DeliveryMode alloc] initWithJSONValue:value]];
        }
        deliveryModes = [array copy];
    });
    return deliveryModes;
}

/// initialize a new instance from the given JSON value
- (id)initWithJSONValue:(id)JSONValue {
    self = [self init];
    if (self) {
        self.ID = JSONValue[@"id"];
        self.name = JSONValue[@"name"];
        self.line1 = JSONValue[@"line1"];
        //self.line2 = JSONValue[@"line2"];
        //self.line3 = JSONValue[@"line3"];
        self.line4 = JSONValue[@"line4"];
        self.price = [JSONValue[@"price"] integerValue];
    }
    return self;
}

#pragma mark - Deal with delivery spans

//static NSInteger default_offsets[] = {0, 3, 3, 3, 5, 5, 5, 4};
//static NSInteger express_offsets[] = {0, 2, 2, 2, 2, 4, 4, 3};


static NSInteger default_offsets[] = {0, 3, 2, 2, 2, 4, 3, 3};
static NSInteger express_offsets[] = {0, 3, 2, 2, 2, 4, 3, 3};

- (NSDate *)deliveryDate {
    // for Colizen, we know the valid date already
    if ([self.ID isEqualToString:@"Colizen"]) {
        return nil;
    }
    
    NSDate *today = [NSDate date];
    NSInteger weekday = [Colizen weekdayFromDate:today];
    if ([Colizen hoursFromDate:today] < 15) {
        weekday--;
        if (weekday == 0) {
            weekday = 7;
        }
    }
    NSInteger offset;
    if ([self.ID isEqualToString:@"Default"]) {
        offset = default_offsets[weekday];
    } else if ([self.ID isEqualToString:@"Express"]) {
        offset = express_offsets[weekday];
    } else {
        offset = 0;
    }
    return [Colizen dateInDays:offset hour:0];
}

@end
