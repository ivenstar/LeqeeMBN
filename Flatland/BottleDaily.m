//
//  BottleDaily.m
//  Flatland
//
//  Created by Jochen Block on 13.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BottleDaily.h"

@implementation BottleDaily

- (id)initWithJSONObject:(id)JSONObject {
    self = [self init];
    if (self) {
        [self updateWithJSONObject:JSONObject];
    }
    return self;
}

- (void)updateWithJSONObject:(id)JSONObject {
    _date = DateWithoutTimezoneFromJSONValue([JSONObject valueForKey:@"date"]);
    _times = [StringFromJSONObject([JSONObject valueForKey:@"average"]) floatValue];
}
//Ionel:
- (id) initWithTime:(int)time{
    self = [self init];
    if (self) {
        _times = time;
    }
    return self;
///
}

@end
