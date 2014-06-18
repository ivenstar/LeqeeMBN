//
//  Capsule.h
//  Flatland
//
//  Created by Stefan Aust on 24.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Represents a capsule type. See `capsules.json`.
 */
@interface Capsule : NSObject

/// return the capsule description for the given capsule type
+ (Capsule *)capsuleForType:(NSString *)type;


//returns the capsule for the given name (used for serever data)
+ (Capsule*) capsuleForName: (NSString*) name;

//returns the size for the given capsule name
+ (int)sizeForCapsuleName:(NSString *)capsuleName;

//returns capsule ID for server
+ (NSString*) capsuleIDforCapsule: (Capsule*) capsule withSize: (int)size;

/// return an array with all available capsule descriptions
+ (NSArray *)capsules;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSArray *sizes; // int values of sizes
@property (nonatomic, copy) NSArray *prices; // prices in cents
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *shortDescription;
@property (nonatomic, copy) NSString *longDescription;
@property (nonatomic, copy) NSString *linkDescription;
@property (nonatomic, copy) NSString *dailyRecommendation;

- (id)initWithJSONValue:(id)JSONValue;



@end
