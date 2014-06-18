//
//  BottleWeekly.m
//  Flatland
//
//  Created by Jochen Block on 13.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BottleWeekly.h"

@implementation BottleWeekly

- (id)initWithJSONObject:(id)JSONObject {
    self = [self init];
    if (self) {
        [self updateWithJSONObject:JSONObject];
    }
    return self;
}

- (void)updateWithJSONObject:(id)JSONObject {
    _startDate = DateWithoutTimezoneFromJSONValue([JSONObject valueForKey:@"date"]);
    _endDate = DateWithoutTimezoneFromJSONValue([JSONObject valueForKey:@"date"]);
    _average = [StringFromJSONObject([JSONObject valueForKey:@"average"]) floatValue];
}

@end
