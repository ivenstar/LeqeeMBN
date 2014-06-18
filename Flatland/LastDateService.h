//
//  LastDateService.h
//  Flatland
//
//  Created by Pirlitu Vasilica on 1/13/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baby.h"
#import "LastDateFeedings.h"

@interface LastDateService : NSObject
+ (id)sharedInstance;
- (void) loadLastDate:(Baby*)baby;
@property (nonatomic,strong) LastDateFeedings * feedings;
@end
