//
//  WeightDataService.h
//  Flatland
//
//  Created by Jochen Block on 14.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baby.h"
#import "Weight.h"

@interface WeightDataService : NSObject

+ (void)loadWeightsForBaby:(Baby *)baby withDate:(NSDate *)date completion:(void (^)(NSArray *))completion;

+ (void)loadLastWeightForBaby:(Baby *)baby before:(NSDate *)date completion:(void (^)(Weight *))completion;

+ (void) loadUrlcompletion:(void (^)(Weight *))completion;

+(void)getLastWeightsWithBaby:(Baby*)baby date:(NSDate*)date completion:(void (^)(NSArray *))completion;

@end
