//
//  Bottle.m
//  Flatland
//
//  Created by Jochen Block on 23.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Bottle.h"
#import "RESTService.h"
#import "Capsule.h"

@implementation Bottle

- (id)initWithBabyId:(NSString *)babyId withQuantity:(NSString *)quantity atDate:(NSDate *)date {
    self = [self init];
    if (self) {
        _babyID = babyId;
        _quantity = quantity;
        _date = date;
    }
    return self;
}

- (id)initWithJSONObject:(id)JSONObject {
    self = [self init];
    if (self) {
        [self updateWithJSONObject:JSONObject];
    }
    return self;
}

- (void)updateWithJSONObject:(id)JSONObject
{
    _date = DateWithoutTimezoneFromJSONValue([JSONObject valueForKey:@"time"]);
    _capsuleType = StringFromJSONObject([JSONObject valueForKey:@"capsuleType"]);
    NSString *capsuleAux = StringFromJSONObject([JSONObject valueForKey:@"capsule_type"]);
    _capsuleType = (capsuleAux == nil) ? _capsuleType : capsuleAux;
    _consumptionId = StringFromJSONObject([JSONObject valueForKey:@"id"]);
    
    float percentConsumed = [StringFromJSONObject([JSONObject valueForKey:@"quantity"]) floatValue];
    int capsuleSize = [Capsule sizeForCapsuleName:self.capsuleType];
    _bottleQuantity = percentConsumed*capsuleSize;
    
    if (_bottleQuantity == (int) _bottleQuantity)
    {
        _quantity = [NSString stringWithFormat:@"%i",(int)_bottleQuantity];
    }
    else
    {
        _quantity = [NSString stringWithFormat:@"%.1f",_bottleQuantity];
    }
}

- (id)createData {
    return @{@"babyId" : _babyID,
             @"quantity" : [NSNumber numberWithFloat:[_quantity floatValue]],
             @"time" : JSONValueFromDate(_date),
             @"capsuleType" : _capsuleType
             };
}

- (id)data {
    return @{@"babyId" : _baby.ID,
             @"id" : _consumptionId,
             @"quantity" : _quantity,
             @"capsuleType" : _capsuleType,
             @"time" : JSONValueFromDate(_date)};
}

- (id)dataUpdate {
    return @{@"babyId" : _baby.ID,
             @"id" : _consumptionId,
             @"quantity" : _quantity,
             @"capsuleType" : _capsuleType,
             @"time" : JSONValueFromDateWithoutAddingTimeZoneDiff(_date)};
}

- (void)createBottle:(void (^)(BOOL))completion {
    [[RESTService sharedService]
     queueRequest:[RESTRequest postURL:WS_babyBottleConsumptionCreate object:[self createData]]
     completion:^(RESTResponse *response) {
         if (response.success) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWidgetNotification" object:nil];
             completion(YES);
         }else{
             completion(NO);
         }
     }];
}

- (void)updateBottle:(void (^)(BOOL))completion {
    [[RESTService sharedService]
    queueRequest:[RESTRequest postURL:WS_babyBottleConsumptionUpdate object:[self dataUpdate]]
    completion:^(RESTResponse *response) {
          if (response.success) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWidgetNotification" object:nil];
             completion(YES);
         }else{
             completion(NO);
         }
     }];
}

- (void)removeBottle:(void (^)(BOOL))completion {
    NSString* url = [NSString stringWithFormat:WS_babyBottleConsumptionDelete, _consumptionId];
    [[RESTService sharedService]
     queueRequest:[RESTRequest postURL:url object:nil]
     completion:^(RESTResponse *response) {
         if (response.success) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWidgetNotification" object:nil];
             completion(YES);
         }else{
             completion(NO);
         }
     }];
}

- (NSString *) bottleImageName
{
    int capsuleSize = [Capsule sizeForCapsuleName:self.capsuleType];
    float percent = _bottleQuantity / capsuleSize;
    
    if (percent == 0)
    {
        return @"bottle_00.png";
    }
    if (percent == 0.25f)
    {
        return @"bottle_01.png";
    }
    if (percent == 0.5f)
    {
        return @"bottle_02.png";
    }
    if (percent == 0.75f)
    {
        return @"bottle_03.png";
    }
    
    return @"bottle_04.png";
}

@end
