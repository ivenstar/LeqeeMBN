//
//  Weight.h
//  Flatland
//
//  Created by Jochen Block on 26.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baby.h"

@interface Weight : NSObject
@property (nonatomic) double weight;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, copy) NSString *babyWeightId;

@property (nonatomic, strong) Baby *baby; //the baby

- (id)initWithJSONObject:(id)JSONObject;

- (void)createWeight:(void (^)(BOOL success))completion;

- (void)updateWeight:(void (^)(BOOL success))completion;
@end
