//
//  Bottle.h
//  Flatland
//
//  Created by Jochen Block on 24.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baby.h"

@interface Bottle : NSObject

@property (nonatomic, copy) NSString *babyID;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *capsuleId;
@property (nonatomic, copy) NSString *consumptionId;
@property (nonatomic, copy) NSString *capsuleImage;
@property (nonatomic, copy) NSString *capsuleType;
@property (nonatomic, readonly) float bottleQuantity;
@property (nonatomic, strong) Baby *baby; //the baby 

- (id)initWithBabyId:(NSString *)babyId withQuantity:(NSString *)quantity atDate:(NSDate *)date;

- (id)initWithJSONObject:(id)JSONObject;

- (void)updateBottle:(void (^)(BOOL success))completion;

- (void)createBottle:(void (^)(BOOL success))completion;

- (void)removeBottle:(void (^)(BOOL success))completion;

- (NSString *) bottleImageName;
@end
