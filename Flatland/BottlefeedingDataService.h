//
//  BottlefeedingDataService.h
//  Flatland
//
//  Created by Jochen Block on 07.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baby.h"

@interface BottlefeedingDataService : NSObject

/// load list of bottlefeeding per baby based on a date and a time span in the past
+ (void)loadBottlefeedingsForBaby:(Baby *)baby withDate:(NSDate *)date completion:(void (^)(NSArray *bottles))completion; //loads last feedings for baby(until the date)

+ (void)loadBottlefeedingsForBaby:(Baby *)baby forExactDate:(NSDate *)date completion:(void (^)(NSArray *bottles))completion; //loads feedings only for the date

+ (void)loadBottlefeedingsDailyForBaby:(Baby *)baby withDate:(NSDate *)date completion:(void (^)(NSArray *bottles))completion;

+ (void)loadBottlefeedingsWeeklyForBaby:(Baby *)baby withDate:(NSDate *)date completion:(void (^)(NSArray *bottles))completion;

+ (void)loadBottlefeedingsMonthlyForBaby:(Baby *)baby withDate:(NSDate *)date completion:(void (^)(NSArray *bottles))completion;

+(void)getLastBottlefeedingsWithBaby:(Baby*)baby date:(NSDate*)date completion:(void (^)(NSArray *))completion;

@end
