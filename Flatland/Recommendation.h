//
//  Recommendation.h
//  Flatland
//
//  Created by Stefan Aust on 13.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Represents the order recommendation computed by the server.
 */
@interface Recommendation : NSObject

@property (nonatomic, strong) NSDate *since;
@property (nonatomic) BOOL needsReplenishment;
@property (nonatomic, copy) NSArray *orderItems; // of type OrderItem
@property (nonatomic, assign) NSInteger capsulesLeft;

/// loads the order recommendation from the server
+ (void)get:(void (^)(Recommendation *recommendation))callback;

/// initialize a new instance from the given JSON value
- (id)initWithJSONValue:(id)JSONValue;

@end
