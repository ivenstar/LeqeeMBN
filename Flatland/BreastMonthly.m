//
//  BreastMonthly.m
//  Flatland
//
//  Created by Pirlitu Vasilica on 1/27/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "BreastMonthly.h"

@implementation BreastMonthly
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
    _date = DateFromJSONValue([JSONObject valueForKey:@"date"]);
    _average = [StringFromJSONObject([JSONObject valueForKey:@"average"]) floatValue];
    NSString *breast = StringFromJSONObject([JSONObject valueForKey:@"breast"]);
    _breastSide = [breast isEqualToString:@"left"] ? BreastsideLeft : BreastsiteRight;

}

@end
