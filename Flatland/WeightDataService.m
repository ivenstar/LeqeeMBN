//
//  WeightDataService.m
//  Flatland
//
//  Created by Jochen Block on 07.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WeightDataService.h"
#import "RESTRequest.h"
#import "RESTService.h"
#import "User.h"

@implementation WeightDataService

//old API
//+ (void)loadWeightsForBaby:(Baby *)baby withDate:(NSDate *)date completion:(void (^)(NSArray *))completion {
//    
//    
//    NSLog(@"URL:::%@",baby.ID);
//    
//    if (!baby || [[User activeUser] pregnant]) {
//        completion(nil);
//        return;
//    }
//    
//    id data = @{@"babyId": baby.ID,
//                @"date": JSONValueFromDate(date),
//                @"weeksInThePast": [NSNumber numberWithInt:4]};
//    
//    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_babyWeights object:data] completion:^(RESTResponse *response) {
//        if(response.statusCode == 200) {
//            NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
//            NSMutableArray *weights = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
//            for (id object in jsonArray) {
//                Weight *weight = [[Weight alloc] initWithJSONObject:object];
//                [weights addObject:weight];
//            }
//            //IOnel temp hack: add the last item again
//            //[weights addObject:[[Weight alloc] initWithJSONObject:[jsonArray objectAtIndex:3]]];
//            completion(weights);
//        } else {
//            completion(nil);
//        }
//    }];
//}


+ (void)loadWeightsForBaby:(Baby *)baby withDate:(NSDate *)date completion:(void (^)(NSArray *))completion {
    
    
    NSLog(@"WeightDataService loadWeightsForBaby DEBUG 00: URL:::%@",baby.ID);
    
    if (!baby || [[User activeUser] pregnant]) {
        completion(nil);
        return;
    }
     NSLog(@"WeightDataService loadWeightsForBaby DEBUG 000: URL:::%@",baby.ID);
    id data = @{@"babyId": baby.ID
                //@"date": JSONValueFromDate(date),
                //@"weeksInThePast": [NSNumber numberWithInt:4]
                };
    NSLog(@"WeightDataService loadWeightsForBaby DEBUG 01: data=%@",data);
    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_babyWeights object:data] completion:^(RESTResponse *response) {
        if(response.statusCode == 200) {
            NSLog(@"WeightDataService loadWeightsForBaby DEBUG 01: response.data=%@",response.object[@"data"]);
            NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
            NSMutableArray *weights = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
            for (id object in jsonArray) {
                Weight *weight = [[Weight alloc] initWithJSONObject:object];
                [weights addObject:weight];
            }
            //IOnel temp hack: add the last item again
            //[weights addObject:[[Weight alloc] initWithJSONObject:[jsonArray objectAtIndex:3]]];
            completion(weights);
        } else {
            completion(nil);
        }
    }];
}


+ (void)loadLastWeightForBaby:(Baby *)baby before:(NSDate *)date completion:(void (^)(Weight *))completion {
    
    if (!baby || [[User activeUser] pregnant]) {
        completion(nil);
        return;
    }
    
    NSString *url = [[NSString alloc] initWithFormat:WS_lastBabyWeight, baby.ID, (long long)[date timeIntervalSince1970] * 1000];
    
    [[RESTService sharedService] queueRequest:[RESTRequest getURL:url] completion:^(RESTResponse *response) {
        if(response.statusCode == 200) {
            Weight *weight = [[Weight alloc] initWithJSONObject:response.object];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"WeightFinishedNotification" object:nil];
            completion(weight);
        } else {
            completion(nil);
        }
    }];
}


+(void)getLastWeightsWithBaby:(Baby*)baby date:(NSDate*)date completion:(void (^)(NSArray *))completion
{
    NSLog(@"Sinri0529debug Into getLastWeightsWithBaby baby=%p,ID=%@,birthday=%@,name=%@, date=%@ ",baby,baby.ID,baby.birthday.description,baby.name,date.description);
    if (!baby) {
        completion(nil);NSLog(@"Sinri0529debug Baby Nasi");
        return;
    }else{
        NSLog(@"Sinri0529debug Baby Ari");
    }

    NSLog(@"URL-DATE:WS_getLastWeights:::%@",date);
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@",WS_getLastWeights];
    
    NSLog(@"URL-WS_getLastWeights:::%@",url);
    NSLog(@"URL-id-WS_getLastWeights:::%@",baby.ID);
    
    //Here, even if baby is not nil, baby.ID is null so that crash
    /*
    id data = @{@"babyId":baby.ID,//only this died
                @"date": JSONValueFromDate(date)//only this is okay
                };
    */
    id data = [NSDictionary dictionaryWithObjectsAndKeys:baby.ID,@"babyId",JSONValueFromDate(date), @"date", nil];
    NSLog(@"Sinri0529debug id data created %p=%@",data,data);
    
    [[RESTService sharedService] queueRequest:[RESTRequest postURL:url object:data] completion:^(RESTResponse *response)
     {
         if(response.statusCode == 200) {
             NSArray *jsonArray = ArrayFromJSONObject(response.object[@"data"]);
             NSMutableArray *weights = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
             for (id object in jsonArray) {
                 Weight *weight = [[Weight alloc] initWithJSONObject:object];
                 [weights addObject:weight];
             }
             //IOnel temp hack: add the last item again
             //[weights addObject:[[Weight alloc] initWithJSONObject:[jsonArray objectAtIndex:3]]];
             //[[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWeightFinishedNotification" object:nil];
             //[weights reverse];
             completion(weights);NSLog(@"Sinri0529debug Weight Ari");
         } else {
             completion(nil);NSLog(@"Sinri0529debug Weight Nasi res: %i",response.statusCode);
         }
     }];
}

@end
