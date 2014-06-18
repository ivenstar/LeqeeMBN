//
//  BreastDaily.m
//  Flatland
//
//  Created by Pirlitu Vasilica on 1/27/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "BreastDaily.h"

@implementation BreastDaily
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
    NSString *breast = StringFromJSONObject([JSONObject valueForKey:@"breast"]);
    _breastSide = [breast isEqualToString:@"left"] ? BreastsideLeft : BreastsiteRight;
    
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
