//
//  BreastDaily.h
//  Flatland
//
//  Created by Pirlitu Vasilica on 1/27/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baby.h"


@interface BreastDaily : NSObject
@property (nonatomic, copy) NSDate *date;
@property (nonatomic) float times;
@property (nonatomic, assign) Breastside breastSide;

- (id)initWithJSONObject:(id)JSONObject;
//Ionel
- (id) initWithTime: (int) time;
///
@end
