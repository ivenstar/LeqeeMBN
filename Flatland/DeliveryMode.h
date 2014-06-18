//
//  DeliveryMode.h
//  Flatland
//
//  Created by Stefan Aust on 24.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Represents the delivery mode.
 */
@interface DeliveryMode : NSObject

/// return the delivery mode identified by the given ID
+ (DeliveryMode *)deliveryModeForID:(NSString *)ID;

/// return an array with all available delivery modes
+ (NSArray *)deliveryModes;

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *line1;
@property (nonatomic, copy) NSString *line2;
@property (nonatomic, copy) NSString *line3;
@property (nonatomic, copy) NSString *line4;
@property (nonatomic, assign) NSInteger price; // price in cents

/// initialize a new instance from the given JSON value
- (id)initWithJSONValue:(id)JSONValue;

/// Returns the estimated delivery date
- (NSDate *)deliveryDate;

@end
