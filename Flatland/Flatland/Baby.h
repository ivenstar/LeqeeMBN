//
//  Baby.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 03.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Gender) {
    GenderNone = 0,
    GenderMale = 1,
    GenderFemale = 2
};

@interface Baby : NSObject

@property (nonatomic, assign) Gender gender;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pictureURL;
@property (nonatomic, copy) NSDate *birthday;
@property (nonatomic, assign) long weight; //current weight in gramms

/// init from json object
- (id)initWithJSONObject:(id)JSONObject;

/// save object to server either creates or updates - depends on ID field
- (void)save:(void (^)(BOOL success))completion;

@end
