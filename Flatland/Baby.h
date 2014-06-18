//
//  Baby.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 03.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Notification when withings changed for any baby
extern NSString *const WithingsChangedNotification;

@class Capsule;

typedef NS_ENUM(NSInteger, Gender) {
    GenderNone = 0,
    GenderFemale = 1,
    GenderMale = 2
};

@interface Baby : NSObject <NSCopying>

@property (nonatomic, assign) Gender gender;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pictureURL;
@property (nonatomic, copy) NSString *capsuleImage;
@property (nonatomic, copy) NSString *capsuleSize;
@property (nonatomic, copy) NSString *capsuleType;
@property (nonatomic, copy) UIImage *picture; //the picture of the baby, only used for save and update
@property (nonatomic, copy) NSDate *birthday;
@property (nonatomic, assign) double weight; //current weight in gramms
@property (nonatomic, copy) NSArray *messages;
@property (nonatomic, copy) NSString *feedingPreferences;
@property (nonatomic, strong) UIImage *cachedImage;
@property (nonatomic) BOOL isEdited;
@property (nonatomic, readwrite) BOOL preganatWithThisBaby;
@property (nonatomic, readwrite,getter = isWithingsEnabled) BOOL withingsEnabled;

/// init from json object
- (id)initWithJSONObject:(id)JSONObject;

/// save object to server either creates or updates - depends on ID field
- (void)save:(void (^)(BOOL success, NSArray *errors))completion;

- (void)loadPictureWithCompletion:(void(^)(UIImage *picture))completion;

/// load/update the baby from the server and fill all the fields
- (void)refreshWithCompletion:(void (^)(BOOL success))completion;

- (void)loadMessages:(void (^)(BOOL success))completion;

/// delete baby
- (void)remove:(void (^)(BOOL success))completion;

- (Capsule*)capsuleForDate:(NSDate*)date;

@end
