//
//  BreastfeedingsDataService.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 30.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baby.h"
#import "Breastfeeding.h"
#import "User.h"

/// Data service for Breastfeedings
@interface BreastfeedingsDataService : NSObject

/// load list of breastfeedings per baby based on a date and a time span in the past
+ (void)loadBreastfeedingsForBaby:(Baby *)baby withStartDate:(NSDate *)startDate timeSpanDays:(NSInteger)days completion:(void (^)(NSArray *breastfeedings))completion;
+ (void)loadBreastfeedingsForBaby:(Baby *)baby forExactDate:(NSDate *)date completion:(void (^)(NSArray *breastfeedings))completion;
+ (void)getLastBreastfeedingsWithBaby:(Baby*)baby date:(NSDate*)date completion:(void (^)(NSArray *))completion;
+ (void)loadBreastfeedingsDailyForBaby:(Baby *)baby withDate:(NSDate *)date completion:(void (^)(NSArray *))completion;
+ (void)loadBreastfeedingsWeeklyForBaby:(Baby *)baby withDate:(NSDate *)date completion:(void (^)(NSArray *))completion ;
+ (void)loadBreastfeedingsMonthlyForBaby:(Baby *)baby withDate:(NSDate *)date completion:(void (^)(NSArray *))completion ;


@end
