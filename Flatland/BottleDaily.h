//
//  BottleDaily.h
//  Flatland
//
//  Created by Jochen Block on 13.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BottleDaily : NSObject

@property (nonatomic, copy) NSDate *date;
@property (nonatomic) float times;

- (id)initWithJSONObject:(id)JSONObject;
//Ionel
- (id) initWithTime: (int) time;
///
@end
