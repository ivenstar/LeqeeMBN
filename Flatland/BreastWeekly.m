//
//  BreastWeekly.m
//  Flatland
//
//  Created by Pirlitu Vasilica on 1/27/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "BreastWeekly.h"

@implementation BreastWeekly

- (id)initWithJSONObject:(id)JSONObject {
    self = [self init];
    if (self) {
        [self updateWithJSONObject:JSONObject];
    }
    return self;
}

- (void)updateWithJSONObject:(id)JSONObject
{
    _startDate = DateWithoutTimezoneFromJSONValue([JSONObject valueForKey:@"date"]);
    _endDate = DateWithoutTimezoneFromJSONValue([JSONObject valueForKey:@"date"]);
    _date = DateWithoutTimezoneFromJSONValue([JSONObject valueForKey:@"date"]);
    _average = [StringFromJSONObject([JSONObject valueForKey:@"average"]) floatValue];
    NSString *breast = StringFromJSONObject([JSONObject valueForKey:@"breast"]);
    _breastSide = [breast isEqualToString:@"left"] ? BreastsideLeft : BreastsiteRight;
}

@end
