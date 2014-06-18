//
//  BreastWeekly.h
//  Flatland
//
//  Created by Pirlitu Vasilica on 1/27/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BreastWeekly : NSObject
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic) float average;
@property (nonatomic) NSString * breast;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, assign) Breastside breastSide;

- (id)initWithJSONObject:(id)JSONObject;

@end
