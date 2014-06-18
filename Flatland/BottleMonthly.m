//
//  BottleMonthly.m
//  Flatland
//
//  Created by Jochen Block on 13.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BottleMonthly.h"

@implementation BottleMonthly

- (id)initWithJSONObject:(id)JSONObject {
    self = [self init];
    if (self) {
        [self updateWithJSONObject:JSONObject];
    }
    return self;
}

- (void)updateWithJSONObject:(id)JSONObject {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMM"];
    _month = [df stringFromDate:DateFromJSONValue([JSONObject valueForKey:@"date"])];
    _average = [StringFromJSONObject([JSONObject valueForKey:@"average"]) floatValue];
}

@end
