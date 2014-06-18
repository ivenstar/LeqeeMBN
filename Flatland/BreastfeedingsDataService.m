//
//  BreastfeedingsDataService.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 30.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BreastfeedingsDataService.h"
#import "RESTRequest.h"
#import "RESTService.h"
#import "BreastDaily.h"
#import "BreastWeekly.h"
#import "BreastMonthly.h"

@implementation BreastfeedingsDataService

+ (void)loadBreastfeedingsForBaby:(Baby *)baby withStartDate:(NSDate *)startDate timeSpanDays:(NSInteger)days completion:(void (^)(NSArray *))completion {
    
    if (!baby) {
        completion(nil);
        return;
    }
    
    id data = @{@"babyId": baby.ID,
                @"date": JSONValueFromDate(startDate),
                @"daysInThePast": [NSString stringWithFormat:@"%d", days ]};
    
    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_breastFeedings object:data] completion:^(RESTResponse *response) {
        NSMutableArray *feedings = nil;
        if(response.statusCode == 200) {
            NSArray *jsonArray = ArrayFromJSONObject(response.object);
            feedings = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            for (id object in jsonArray) {
                Breastfeeding *bf = [[Breastfeeding alloc] initWithJSONObject:object];
                [feedings addObject:bf];
            }
        }
        
        // and return
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BreastfeedingFinishedNotification" object:nil];
        completion(feedings);
        
    }];
}

+ (void)loadBreastfeedingsForBaby:(Baby *)baby forExactDate:(NSDate *)date completion:(void (^)(NSArray *breastfeedings))completion
{
    if (!baby) {
        completion(nil);
        return;
    }
    //IOnel temp hack
    id data;
    
    if ([JSONValueFromDateWithoutAddingTimeZoneDiff(date) longLongValue] % 86400 == 0){
        date = [date dateByAddingTimeInterval:(24*60*60 -10)];
    data = @{@"babyId": baby.ID,
                @"date": JSONValueFromDateWithoutAddingTimeZoneDiff(date)};
    }
    else
        data = @{@"babyId": baby.ID,
                    @"date": JSONValueFromDate(date)};
    ///
    
    //NSLog(@"epic date of actual breast list request getByDay: %@", JSONValueFromDate(date));
    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_breastFeedingsByDay object:data] completion:^(RESTResponse *response)
     {
        NSMutableArray *feedings = nil;
        if(response.statusCode == 200) {
            NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
            feedings = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            for (id object in jsonArray) {
                Breastfeeding *bf = [[Breastfeeding alloc] initWithJSONObjectByDay:object];
                [feedings addObject:bf];
            }
        }
        
        completion(feedings);
        
    }];
    
}

+ (void)loadBreastfeedingsDailyForBaby:(Baby *)baby withDate:(NSDate *)date completion:(void (^)(NSArray *))completion {
    
    if (!baby || [[User activeUser] pregnant]) {
        completion(nil);
        return;
    }
    
    id data = @{@"babyId": baby.ID,
                @"date": JSONValueFromDate(date)};
    
    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_babyBreastConsumptionDaily object:data] completion:^(RESTResponse *response) {
        if(response.statusCode == 200) {
            
            
            NSLog(@"breast daily ::%@",response.object);
            
            NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
            NSMutableArray *breasts = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            
            for (id object in jsonArray) {
                BreastDaily *breast = [[BreastDaily alloc] initWithJSONObject:object];
                [breasts addObject:breast];
            }
            completion(breasts);
//            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
//            int weekday = components.weekday;
//            if(weekday < 7)
//                //Ionel hack bypass
//                if ([breasts count])
//                {
//                    NSDate *newDate = [date dateByAddingTimeInterval:-604800];
//                    
//                    id newData = @{@"babyId": baby.ID,
//                                   @"date": JSONValueFromDate(newDate)};
//                    
//                    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_babyBreastConsumptionDaily object:newData] completion:^(RESTResponse *response) {
//                        if(response.statusCode == 200) {
//                            NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
//                            NSMutableArray *newBreasts = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
//                            for (id object in jsonArray)
//                            {
//                                BreastDaily *breast = [[BreastDaily alloc] initWithJSONObject:object];
//                                [newBreasts addObject:breast];
//                            }
//                            
//                            NSMutableArray *arr = [NSMutableArray new];
//                            for(int i = weekday-1; i >= 0; i--) {
//                                [arr addObject:breasts[i]];
//                            }
//                            int k = 6;
//                            
//                            for(int j = 6-weekday; j >= 0; j--) {
//                                [arr addObject:newBreasts[k--]];
//                            }
//                            [arr reverse];
//                            completion(arr);
//                        } else completion(nil);
//                    }];
//                }
//                else
//                {
//                    NSMutableArray *arr = [NSMutableArray new];
//                    weekday--;
//                    //Ionel hack bypass
//                    if ([breasts count])
//                        for(int i = 6; i >= 0; i--) {
//                            [arr addObject:breasts[weekday--]];
//                        }
//                    [arr reverse];
//                    completion(arr);
//                }
        } else
        {
            completion(nil);
        }
    }];
}


+ (void)loadBreastfeedingsWeeklyForBaby:(Baby *)baby withDate:(NSDate *)date completion:(void (^)(NSArray *))completion {
    
    if (!baby || [[User activeUser] pregnant]) {
        completion(nil);
        return;
    }
    
    id data = @{@"babyId": baby.ID,
                @"date": JSONValueFromDate(date)};
    
    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_babyBreastConsumptionWeekly object:data] completion:^(RESTResponse *response) {
        if(response.statusCode == 200) {
            NSLog(@"breast weekly ::%@",response.object);
            
            NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
            NSMutableArray *breasts = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            for (id object in jsonArray) {
                BreastWeekly *breast = [[BreastWeekly alloc] initWithJSONObject:object];
                [breasts addObject:breast];
            }
//            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekOfMonthCalendarUnit fromDate:date];
//            int weekOfMonth = components.weekOfMonth;
//            if(weekOfMonth < 5)
//                //Ionel hack bypass
//                if ([breasts count])
//                {
//                    NSDate *newDate = [date dateByAddingTimeInterval:-2419200];
//                    id newData = @{@"babyId": baby.ID,
//                                   @"date": JSONValueFromDate(newDate)};
//                    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_babyBreastConsumptionWeekly object:newData] completion:^(RESTResponse *response) {
//                        if(response.statusCode == 200) {
//                            NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
//                            NSMutableArray *newBottles = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
//                            for (id object in jsonArray) {
//                                BreastWeekly *breast = [[BreastWeekly alloc] initWithJSONObject:object];
//                                [newBottles addObject:breast];
//                            }
//                            NSMutableArray *arr = [NSMutableArray new];
//                            for(int i = weekOfMonth-1; i >= 0; i--)
//                            {
//                                [arr addObject:breasts[i]];
//                            }
//                            int k = 4;
//                            BreastWeekly *first = [arr lastObject];
//                            BreastWeekly *last = [newBottles lastObject];
//                            if([first.startDate isEqualToDate:last.startDate]) {
//                                k--;
//                            }
//                            for(int j = 4-weekOfMonth; j >= 0; j--) {
//                                [arr addObject:newBottles[k--]];
//                            }
//                            [arr reverse];
//                            completion(arr);
//                        } else completion(nil);
//                    }];
//                } else {
//                    NSMutableArray *arr = [NSMutableArray new];
//                    weekOfMonth--;
//                    //Ionel hack bypass
//                    if ([breasts count])
//                        for(int i = 4; i >= 0; i--) {
//                            [arr addObject:breasts[weekOfMonth--]];
//                        }
//                    [arr reverse];
//                    completion(arr);
//                }
            completion(breasts);
        } else {
            completion(nil);
        }
    }];
}




+ (void)loadBreastfeedingsMonthlyForBaby:(Baby *)baby withDate:(NSDate *)date completion:(void (^)(NSArray *))completion {
    
    if (!baby || [[User activeUser] pregnant]) {
        completion(nil);
        return;
    }
    
    id data = @{@"babyId": baby.ID,
                @"date": JSONValueFromDate(date)};
    NSLog(@"/breastConsumption/monthly: %@", data);
    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_babyBreastConsumptionMonthly object:data] completion:^(RESTResponse *response) {
        if(response.statusCode == 200) {
            
            NSLog(@"breast monthly ::%@",response.object);
            
            NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
            NSMutableArray *breasts = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            
            for (id object in jsonArray) {
                BreastMonthly *breast = [[BreastMonthly alloc] initWithJSONObject:object];
                [breasts addObject:breast];
            }
            //Ionel quick validation check
            if (![breasts count]) {
                completion(nil);
                return;
            }
            completion(breasts);
            //
//            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
//            int month = components.month;
//            if(month < 7) {
//                NSDate *newDate = [date dateByAddingTimeInterval:-15768000];
//                id newData = @{@"babyId": baby.ID,
//                               @"date": JSONValueFromDate(newDate)};
//                [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_babyBreastConsumptionMonthly object:newData] completion:^(RESTResponse *response) {
//                    if(response.statusCode == 200) {
//                        NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
//                        NSMutableArray *newBreasts = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
//                    
//                        for (id object in jsonArray) {
//                            BreastMonthly * breast = [[BreastMonthly alloc] initWithJSONObject:object];
//                            [newBreasts addObject:breast];
//                        }
//                        
//                        NSMutableArray *arr = [NSMutableArray new];
//                        for(int i = month-1; i >= 0; i--) {
//                            [arr addObject:breasts[i]];
//                        }
//                        int k = 11;
//                        for(int j = 6-month; j >= 0; j--) {
//                            [arr addObject:newBreasts[k--]];
//                        }
//                        [arr reverse];
//                        completion(arr);
//                    } else completion(nil);
//                }];
//            }
//            else
//            {
//                NSMutableArray *arr = [NSMutableArray new];
//                month--;
//                //Ionel hack bypass
//                if ([breasts count])
//                    for(int i = 6; i >= 0; i--) {
//                        [arr addObject:breasts[month--]];
//                    }
//                [arr reverse];
//                completion(arr);
//            }
        }
        else
        {
            completion(nil);
        }
    }];
}


+(void)getLastBreastfeedingsWithBaby:(Baby*)baby date:(NSDate*)date completion:(void (^)(NSArray *))completion
{
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@",WS_getLastBreastfeedings];
    //NSLog(@"URL:::%@",url);
    //NSLog(@"URL:::%@",baby.ID);
    
    
    if (!baby)
    {
        completion(nil);
        return;
    }
    
    id data = @{@"babyId": baby.ID,
                @"date": JSONValueFromDate(date),
                };
    
    [[RESTService sharedService] queueRequest:[RESTRequest postURL:url object:data] completion:^(RESTResponse *response) {NSMutableArray *feedings = nil;
        if(response.statusCode == 200) {
            NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
            feedings = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            for (id object in jsonArray) {
                Breastfeeding *bf = [[Breastfeeding alloc] initWithJSONObjectNew:object];
                [feedings addObject:bf];
            }
        }
        
        // and return
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BreastfeedingFinishedNotification" object:nil];
        completion(feedings);
        
    }];

}

@end
