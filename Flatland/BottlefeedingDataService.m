//
//  BottlefeedingDataService.m
//  Flatland
//
//  Created by Jochen Block on 07.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BottlefeedingDataService.h"
#import "RESTRequest.h"
#import "RESTService.h"
#import "Bottle.h"
#import "BottleDaily.h"
#import "BottleWeekly.h"
#import "BottleMonthly.h"
#import "User.h"

@implementation BottlefeedingDataService

+ (void)loadBottlefeedingsForBaby:(Baby *)baby withDate:(NSDate *)date completion:(void (^)(NSArray *))completion {
    
    if (!baby || [[User activeUser] pregnant]) {
        completion(nil);
        return;
    }
    //NSLog(@"URL:::%@",baby.ID);
    //NSLog(@"DATE:::%@",date);
    
    id data = @{@"babyId": baby.ID,
                @"date": JSONValueFromDate(date)
                };
    
    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_getLastBottlefeedings object:data] completion:^(RESTResponse *response) {
        if(response.statusCode == 200) {
            NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
            NSMutableArray *bottles = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
         
            NSLog(@"REsponse bottle today ::%@",response.object[@"data"]);
            
            for (id object in jsonArray)
            {
                Bottle *bottle = [[Bottle alloc] initWithJSONObject:object];
                [bottles addObject:bottle];
            }
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"BottlefeedingFinishedNotification" object:nil];
            completion(bottles);
        }
        else
        {
            completion(nil);
        }
    }];
}

+ (void)loadBottlefeedingsForBaby:(Baby *)baby forExactDate:(NSDate *)date completion:(void (^)(NSArray *bottles))completion
{
    if (!baby || [[User activeUser] pregnant]) {
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

    
    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_babyBottleConsumptionByDay object:data] completion:^(RESTResponse *response) {
        if(response.statusCode == 200)
        {
            NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
            NSMutableArray *bottles = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            for (id object in jsonArray)
            {
                Bottle *bottle = [[Bottle alloc] initWithJSONObject:object];
                [bottles addObject:bottle];
            }
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"BottlefeedingFinishedNotification" object:nil];
            completion(bottles);
        }
        else
        {
            completion(nil);
        }
    }];
}

+ (void)loadBottlefeedingsDailyForBaby:(Baby *)baby withDate:(NSDate *)date completion:(void (^)(NSArray *))completion {
    
    if (!baby || [[User activeUser] pregnant]) {
        completion(nil);
        return;
    }
    
    id data = @{@"babyId": baby.ID,
                @"date": JSONValueFromDate(date)};
    
    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_babyBottleConsumptionDaily object:data] completion:^(RESTResponse *response) {
        if(response.statusCode == 200) {
            NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
            NSMutableArray *bottles = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
           
            for (id object in jsonArray) {
                BottleDaily *bottle = [[BottleDaily alloc] initWithJSONObject:object];
                [bottles addObject:bottle];
            }
            completion(bottles);
            
//            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
//            int weekday = components.weekday;
//            if(weekday < 7)
//                
//                {
//                    NSDate *newDate = [date dateByAddingTimeInterval:-604800];
//                    
//                    id newData = @{@"babyId": baby.ID,
//                                   @"date": JSONValueFromDate(newDate)};
//                    
//                    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_babyBottleConsumptionDaily object:newData] completion:^(RESTResponse *response) {
//                        if(response.statusCode == 200) {
//                            NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
//                            NSMutableArray *newBottles = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
//                            for (id object in jsonArray)
//                            {
//                                BottleDaily *bottle = [[BottleDaily alloc] initWithJSONObject:object];
//                                [newBottles addObject:bottle];
//                            }
//                            
//                            NSMutableArray *arr = [NSMutableArray new];
//                            for(int i = weekday-1; i >= 0; i--) {
//                                [arr addObject:bottles[i]];
//                            }
//                            int k = 6;
//                            
//                            for(int j = 6-weekday; j >= 0; j--) {
//                                [arr addObject:newBottles[k--]];
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
//                    if ([bottles count])
//                        for(int i = 6; i >= 0; i--) {
//                            [arr addObject:bottles[weekday--]];
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

+ (void)loadBottlefeedingsWeeklyForBaby:(Baby *)baby withDate:(NSDate *)date completion:(void (^)(NSArray *))completion {
    
    if (!baby || [[User activeUser] pregnant]) {
        completion(nil);
        return;
    }
    
    id data = @{@"babyId": baby.ID,
                @"date": JSONValueFromDate(date)};
    
    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_babyBottleConsumptionWeekly object:data] completion:^(RESTResponse *response) {
        if(response.statusCode == 200) {
            NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
            NSMutableArray *bottles = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            for (id object in jsonArray) {
                BottleWeekly *bottle = [[BottleWeekly alloc] initWithJSONObject:object];
                [bottles addObject:bottle];
            }
            completion(bottles);
            //            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekOfMonthCalendarUnit fromDate:date];
//            int weekOfMonth = components.weekOfMonth;
//            if(weekOfMonth < 5)
//                
//                {
//                    NSDate *newDate = [date dateByAddingTimeInterval:-2419200];
//                    id newData = @{@"babyId": baby.ID,
//                                   @"date": JSONValueFromDate(newDate)};
//                    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_babyBottleConsumptionWeekly object:newData] completion:^(RESTResponse *response) {
//                        if(response.statusCode == 200) {
//                            NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
//                            NSMutableArray *newBottles = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
//                            for (id object in jsonArray) {
//                                BottleWeekly *bottle = [[BottleWeekly alloc] initWithJSONObject:object];
//                                [newBottles addObject:bottle];
//                            }
//                            NSMutableArray *arr = [NSMutableArray new];
//                            for(int i = weekOfMonth-1; i >= 0; i--) {
//                                [arr addObject:bottles[i]];
//                            }
//                            int k = 4;
//                            BottleWeekly *first = [arr lastObject];
//                            BottleWeekly *last = [newBottles lastObject];
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
//                    if ([bottles count])
//                        for(int i = 4; i >= 0; i--) {
//                            [arr addObject:bottles[weekOfMonth--]];
//                        }
//                    [arr reverse];
//                    completion(arr);
//                }
        } else {
            completion(nil);
        }
    }];
}


+ (void)loadBottlefeedingsMonthlyForBaby:(Baby *)baby withDate:(NSDate *)date completion:(void (^)(NSArray *))completion {
    
    if (!baby || [[User activeUser] pregnant]) {
        completion(nil);
        return;
    }
    
    id data = @{@"babyId": baby.ID,
                @"date": JSONValueFromDate(date)};
    //NSLog(@"/bottleConsumption/monthly: %@", data);
    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_babyBottleConsumptionMonthly object:data] completion:^(RESTResponse *response) {
        if(response.statusCode == 200) {
            NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
            NSMutableArray *bottles = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            
            for (id object in jsonArray) {
                BottleMonthly *bottle = [[BottleMonthly alloc] initWithJSONObject:object];
                [bottles addObject:bottle];
            }
//            //Ionel quick validation check
//            if (![bottles count]) {
//                completion(nil);
//                return;
//            }
            completion(bottles);
//            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
//            int month = components.month;
//            if(month < 7) {
//                NSDate *newDate = [date dateByAddingTimeInterval:-15768000];
//                id newData = @{@"babyId": baby.ID,
//                               @"date": JSONValueFromDate(newDate)};
//                [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_babyBottleConsumptionMonthly object:newData] completion:^(RESTResponse *response) {
//                    if(response.statusCode == 200) {
//                        NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
//                        NSMutableArray *newBottles = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
//                        for (id object in jsonArray) {
//                            BottleMonthly *bottle = [[BottleMonthly alloc] initWithJSONObject:object];
//                            [newBottles addObject:bottle];
//                        }
//                        
//                        NSMutableArray *arr = [NSMutableArray new];
//                        for(int i = month-1; i >= 0; i--) {
//                            [arr addObject:bottles[i]];
//                        }
//                        int k = 11;
//                        for(int j = 6-month; j >= 0; j--) {
//                            [arr addObject:newBottles[k--]];
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
////                //Ionel hack bypass
////                if ([bottles count])
//                    for(int i = 6; i >= 0; i--) {
//                        [arr addObject:bottles[month--]];
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


+(void)getLastBottlefeedingsWithBaby:(Baby*)baby date:(NSDate*)date completion:(void (^)(NSArray *))completion
{
    NSString *url = [[NSString alloc] initWithFormat:@"%@",WS_getLastBottlefeedings];
    //NSLog(@"URL:::%@",url);
    //NSLog(@"URL:::%@",baby.ID);
    //NSLog(@"DATE:::%@",date);
    
    if (!baby || [[User activeUser] pregnant])
    {
        completion(nil);
        return;
    }
    
    [[RESTService sharedService] queueRequest:[RESTRequest postURL:url object:@{@"babyId":baby.ID , @"date": JSONValueFromDate(date)}] completion:^(RESTResponse *response) {
        if(response.statusCode == 200)
        {
            int responseStatus = [StringFromJSONObject([response.object valueForKey:@"success"]) doubleValue];
            NSLog(@"responseStatus --%d",responseStatus);
            if (responseStatus!=0)
            {
                NSLog(@"Response bottle getlast %@",response.object );

                NSLog(@"Response bottle getlast %@",[response.object objectForKey:@"data"]);
                if([[response.object objectForKey:@"data"] isKindOfClass:[NSArray class]])
                {
                    NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);

                    NSMutableArray *bottles = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];

                    for (id object in jsonArray)
                    {
                        Bottle *bottle = [[Bottle alloc] initWithJSONObject:object];
                        [bottles addObject:bottle];
                    }
                    completion(bottles);
                }
                    else
                    completion (nil);
            }
            else
                completion(nil);
        }
        else
        {
            completion(nil);
        }
    }];
}

@end
