//
//  BottleWeekly.h
//  Flatland
//
//  Created by Jochen Block on 13.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BottleWeekly : NSObject

@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic) float average;

- (id)initWithJSONObject:(id)JSONObject;

@end
