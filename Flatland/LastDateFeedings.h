//
//  LastDateFeedings.h
//  Flatland
//
//  Created by Pirlitu Vasilica on 1/15/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LastDateFeedings : NSObject
@property (nonatomic,strong)NSDate *lastBottleFeedDate;
@property (nonatomic,strong)NSDate *lastBreastFeedDate;
@property (nonatomic,strong)NSDate *lastEventDate;
@property (nonatomic,strong)NSDate *lastWeightDate;
- (void)updateWithJSONObject:(id)JSONObject ;
- (id)initWithJSONObject:(id)JSONObject ;

@end
