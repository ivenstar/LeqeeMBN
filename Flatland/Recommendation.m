//
//  Recommendation.m
//  Flatland
//
//  Created by Stefan Aust on 13.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Recommendation.h"
#import "RESTService.h"
#import "Order.h"

@implementation Recommendation

+ (void)get:(void (^)(Recommendation *recommendation))callback {
    [[RESTService sharedService]
     queueRequest:[RESTRequest getURL:WS_ordersRecommendation]
     completion:^(RESTResponse *response) {
         if (response.success) {
             callback([[Recommendation alloc] initWithJSONValue:response.object]);
         } else {
             callback(nil);
         }
     }];
}

- (id)initWithJSONValue:(id)JSONValue {
    self = [self init];
    if (self) {
        self.since = DateFromJSONValue(JSONValue[@"firstdaywithoutcapsules"]);
        self.needsReplenishment = (BOOL)((NSNumber* )JSONValue[@"needsreplenishment"]).integerValue;
        NSMutableArray *orderItems = [NSMutableArray new];
        NSArray *keys = [JSONValue allKeys];
        for(NSString *key in keys) {
            if(![key isEqualToString:@"success"] && ![key isEqualToString:@"needsreplenishment"] && ![key isEqualToString:@"total"] && ![key isEqualToString:@"message"] && ![key isEqualToString:@"firstdaywithoutcapsules"] )
            {
//                if([key isEqualToString:@"firstdaywithoutcapsules"]){
//                    NSString *testString = StringFromJSONObject(JSONValue[key]);
//                    if(!testString){
//                        continue;
//                    }
//                }
                
                int quantity = ((NSNumber* )JSONValue[key]).integerValue;
                if(quantity > 0)
                {
                    
                    [orderItems addObject:[[OrderItem alloc] initWithString:key andQuantity:quantity]];
                }
            }
        }

        self.orderItems = orderItems;
        self.capsulesLeft = [JSONValue[@"total"] integerValue];
    }
    return self;
}

@end
