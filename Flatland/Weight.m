//
//  Weight.m
//  Flatland
//
//  Created by Jochen Block on 26.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Weight.h"
#import "RESTService.h"

@implementation Weight

- (id)initWithJSONObject:(id)JSONObject {
    self = [self init];
    if (self) {
        [self updateWithJSONObject:JSONObject];
    }
    return self;
}

- (void)updateWithJSONObject:(id)JSONObject {
    _startDate = DateWithoutTimezoneFromJSONValue([JSONObject valueForKey:@"time"]);
    _endDate = DateWithoutTimezoneFromJSONValue([JSONObject valueForKey:@"time"]);
    _babyWeightId = StringFromJSONObject([JSONObject valueForKey:@"id"]);
    _weight = [StringFromJSONObject([JSONObject valueForKey:@"weight"]) doubleValue];
}

- (id)data
{
    return @{@"babyId" : _baby.ID,
             @"birthday" : JSONValueFromDate(_baby.birthday),
             @"date" : JSONValueFromDate(_date),
             @"weight" : [NSNumber numberWithDouble:_weight]};
}

- (void)createWeight:(void (^)(BOOL))completion {
    [[RESTService sharedService]
     queueRequest:[RESTRequest postURL:WS_babyWeightCreate object:[self data]]
     completion:^(RESTResponse *response) {
         if (response.success) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWidgetNotification" object:nil];
             completion(YES);
         }else{
             completion(NO);
         }
     }];
}

- (void)updateWeight:(void (^)(BOOL))completion {
    NSString *url = [[NSString alloc] initWithFormat:WS_babyWeightUpdate, self.babyWeightId];
    
    [[RESTService sharedService]
     queueRequest:[RESTRequest postURL:url object:[self data]]
     completion:^(RESTResponse *response) {
         if (response.success) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWidgetNotification" object:nil];
             completion(YES);
         }else{
             completion(NO);
         }
     }];
}


@end
