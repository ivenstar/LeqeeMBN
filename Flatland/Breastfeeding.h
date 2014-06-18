//
//  Breastfeeding.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 25.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baby.h"



/// Represents one breastfeeding entry
@interface Breastfeeding : NSObject


@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) Breastside breastSide;
@property (nonatomic, assign) NSInteger duration; //in seconds
@property (nonatomic, copy) NSDate *startTime; //datetime
@property (nonatomic, copy) NSDate *endTime; //datetime
@property (nonatomic, strong) Baby *baby; //the baby we feeding

@property (nonatomic, readonly) id data; //as json data

/// init from json object
- (id)initWithJSONObject:(id)JSONObject;
- (id)initWithJSONObjectNew:(id)JSONObject;
- (id)initWithJSONObjectByDay:(id)JSONObject;

/// CRUD Methods

/// save object to server either creates or updates - depends on ID field
- (void)save:(void (^)(BOOL success))completion;

/// delete the entry
- (void)remove:(void (^)(BOOL success))completion;

/// delete the entry
- (void)update:(void (^)(BOOL success))completion;

@end
