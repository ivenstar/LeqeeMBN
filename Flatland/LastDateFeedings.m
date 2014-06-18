//
//  LastDateFeedings.m
//  Flatland
//
//  Created by Pirlitu Vasilica on 1/15/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "LastDateFeedings.h"

@implementation LastDateFeedings

- (id)initWithJSONObject:(id)JSONObject {
    self = [self init];
    if (self)
    {
        [self updateWithJSONObject:JSONObject];
    }
    return self;
}


- (void)updateWithJSONObject:(id)JSONObject
{
    _lastBottleFeedDate = DateWithoutTimezoneFromJSONValue([JSONObject valueForKey:@"last_bottlefeed_date"]);
    _lastBreastFeedDate = DateWithoutTimezoneFromJSONValue([JSONObject valueForKey:@"last_breastfeed_date"]);
    _lastEventDate = DateWithoutTimezoneFromJSONValue([JSONObject valueForKey:@"last_event_date"]);
    _lastWeightDate = DateWithoutTimezoneFromJSONValue([JSONObject valueForKey:@"last_weight_date"]);
}

@end
