//
//  Breastfeeding.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 25.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Breastfeeding.h"
#import "RESTService.h"
#import "RESTRequest.h"

@implementation Breastfeeding

- (id)initWithJSONObject:(id)JSONObject {
    self = [self init];
    if (self) {
        [self updateWithJSONObject:JSONObject];
    }
    return self;
}

- (id)initWithJSONObjectNew:(id)JSONObject {
    self = [self init];
    if (self) {
        [self updateWithJSONObjectNew:JSONObject];
    }
    return self;
}

- (id)initWithJSONObjectByDay:(id)JSONObject {
    self = [self init];
    if (self) {
        [self updateWithJSONObjectByDay:JSONObject];
    }
    return self;
}

- (void)updateWithJSONObject:(id)JSONObject {
    
    _ID = StringFromJSONObject([JSONObject valueForKey:@"breastFeedingId"]);
    NSString *breast = StringFromJSONObject([JSONObject valueForKey:@"breast"]);
    _breastSide = [breast isEqualToString:@"left"] ? BreastsideLeft : BreastsiteRight;
    _duration = [StringFromJSONObject([JSONObject valueForKey:@"duration"]) integerValue];
    _startTime = DateFromJSONValue([JSONObject valueForKey:@"startTime"]);
    _endTime = DateFromJSONValue([JSONObject valueForKey:@"endTime"]);
}

- (void)updateWithJSONObjectByDay:(id)JSONObject {
    
    _ID = StringFromJSONObject([JSONObject valueForKey:@"id"]);
    NSString *breast = StringFromJSONObject([JSONObject valueForKey:@"breast"]);
    _breastSide = [breast isEqualToString:@"left"] ? BreastsideLeft : BreastsiteRight;
    _duration = [StringFromJSONObject([JSONObject valueForKey:@"duration"]) integerValue];
    _startTime = DateFromJSONValue([JSONObject valueForKey:@"startTime"]);
    _endTime = DateFromJSONValue([JSONObject valueForKey:@"endTime"]);
}


- (void)updateWithJSONObjectNew:(id)JSONObject {
    _ID = StringFromJSONObject([JSONObject valueForKey:@"id"]);
    NSString *breast = StringFromJSONObject([JSONObject valueForKey:@"breast"]);
    _breastSide = [breast isEqualToString:@"left"] ? BreastsideLeft : BreastsiteRight;
    _duration = [StringFromJSONObject([JSONObject valueForKey:@"duration"]) integerValue];
    _startTime = DateFromJSONValue([JSONObject valueForKey:@"start_time"]);
    _endTime = DateFromJSONValue([JSONObject valueForKey:@"end_time"]);
}

- (id)data {
    return @{@"babyId": self.baby ? self.baby.ID : @"",
             @"breast" : self.breastSide == BreastsideLeft ? @"left" : @"right" ,
             @"duration" : [NSNumber numberWithInteger:self.duration],
             @"startTime" : JSONValueFromDate(self.startTime),
             @"endTime" : JSONValueFromDate(self.endTime)};
}

- (id)dataUpdate {
    return @{@"babyId": self.baby ? self.baby.ID : @"",
             @"breast" : self.breastSide == BreastsideLeft ? @"left" : @"right" ,
             @"duration" : [NSNumber numberWithInteger:self.duration],
             @"startTime" : JSONValueFromDateWithoutAddingTimeZoneDiff(self.startTime),
             @"endTime" : JSONValueFromDateWithoutAddingTimeZoneDiff(self.endTime)};
}

- (void)save:(void (^)(BOOL))completion {
    if (!self.ID) {
        [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_breastfeedingCreate object:self.data] completion:^(RESTResponse *response) {
            if (response.success) {
                //update the ID value
                self.ID = StringFromJSONObject([response.object valueForKey:@"breastFeedingId"]);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWidgetNotification" object:nil];
                completion(YES);
            } else {
                completion(NO);
            }
        }];
    }
}

- (void)remove:(void (^)(BOOL))completion {
    if (self.ID) {
        NSString *url = [[NSString alloc] initWithFormat:WS_breastfeedingDelete, self.ID];
                 [[RESTService sharedService] queueRequest:[RESTRequest getURL:url] completion:^(RESTResponse *response) {
                     if (response.success) {
                         //update the ID value
                         self.ID = StringFromJSONObject([response.object valueForKey:@"breastFeedingId"]);
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWidgetNotification" object:nil];
                         completion(YES);
                     } else {
                         completion(NO);
                     }
                 }];
             }
            
}

- (void)update:(void (^)(BOOL))completion {
    if (self.ID) {
        NSString *url = [[NSString alloc] initWithFormat:WS_breastfeedingUpdate, self.ID];
        [[RESTService sharedService] queueRequest:[RESTRequest postURL:url object:self.dataUpdate] completion:^(RESTResponse *response) {
            if (response.success) {
                self.ID = StringFromJSONObject([response.object valueForKey:@"breastFeedingId"]);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTableDataNotification" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWidgetNotification" object:nil];
                completion(YES);
            } else {
                completion(NO);
            }
        }];
    }
}

@end
