//
//  BottleMonthly.h
//  Flatland
//
//  Created by Jochen Block on 13.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BottleMonthly : NSObject

@property (nonatomic) NSString *month;
@property (nonatomic) float average;

- (id)initWithJSONObject:(id)JSONObject;

@end
