//
//  Capsule.m
//  Flatland
//
//  Created by Stefan Aust on 24.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Capsule.h"

@implementation Capsule

+ (Capsule *)capsuleForType:(NSString *)type {
    for (Capsule *capsule in [self capsules]) {
        if ([capsule.type isEqualToString:type]) {
            return capsule;
        }
    }
    return nil;
}

+ (Capsule*) capsuleForName: (NSString*) name
{
    NSString* capsuleNameLower = [name lowercaseString];
    
    Capsule *capsule = nil;
    if ([capsuleNameLower rangeOfString:@"firstmonth"].location != NSNotFound )
    {
        capsule = [Capsule capsuleForType:@"FirstMonth"];
    }
    else if ([capsuleNameLower rangeOfString:@"secondmonth"].location != NSNotFound )
    {
        capsule = [Capsule capsuleForType:@"SecondMonth"];
    }
    else if ([capsuleNameLower rangeOfString:@"thirdtosixthmonth"].location != NSNotFound )
    {
        capsule = [Capsule capsuleForType:@"ThirdToSixthMonth"];
    }
    else if ([capsuleNameLower rangeOfString:@"seventhtotwelfthmonth"].location != NSNotFound )
    {
        capsule = [Capsule capsuleForType:@"SeventhToTwelfthMonth"];
    }
    else if ([capsuleNameLower rangeOfString:@"thirteenthtotwentyfourthmonth"].location != NSNotFound )
    {
        capsule = [Capsule capsuleForType:@"ThirteenthToTwentyFourthMonth"];
    }
    else if ([capsuleNameLower rangeOfString:@"twentyfifthmonthtothirtysixthmonth"].location != NSNotFound )
    {
        capsule = [Capsule capsuleForType:@"TwentyFifthMonthToThirtySixthMonth"];
    }
    else if ([capsuleNameLower rangeOfString:@"sensitive"].location != NSNotFound )
    {
        capsule = [Capsule capsuleForType:@"Sensitive"];
    }
    
    return capsule;
}

+ (NSString*) capsuleIDforCapsule: (Capsule*) capsule withSize: (int)size
{
    if ([capsule.type isEqualToString:@"FirstMonth"])
    {
        return 0 == size ? @"firstMonthStandard" : @"firstMonthMaxi";
    }
    if ([capsule.type isEqualToString:@"SecondMonth"])
    {
        return 0 == size ? @"secondMonthStandard" : @"secondMonthMaxi";
    }
    if ([capsule.type isEqualToString:@"ThirdToSixthMonth"])
    {
        return 0 == size ? @"thirdToSixthMonthStandard" : @"thirdToSixthMonthMaxi";
    }
    if ([capsule.type isEqualToString:@"SeventhToTwelfthMonth"])
    {
        return @"seventhToTwelfthMonth";
    }
    if ([capsule.type isEqualToString:@"ThirteenthToTwentyFourthMonth"])
    {
        return @"thirteenthToTwentyFourthMonth";
    }
    if ([capsule.type isEqualToString:@"TwentyFifthMonthToThirtySixthMonth"])
    {
        return @"twentyFifthMonthToThirtySixthMonth";
    }
    if ([capsule.type isEqualToString:@"Sensitive"])
    {
        return @"sensitive";
    }
    

    
    return @""; //TODO decide what to do in this case
}

+ (int)sizeForCapsuleName:(NSString *)capsuleName
{
    NSString *capsuleNameLower = [capsuleName lowercaseString];
    Capsule *capsule = [self capsuleForName:capsuleName];
    
    //calculate capsule size
    int capsuleSize = [[capsule.sizes objectAtIndex:0] intValue];
    
    if ([capsuleNameLower rangeOfString:@"maxi"].location != NSNotFound && capsule.sizes.count > 1)
    {
        capsuleSize = [[capsule.sizes objectAtIndex:1] intValue];
    }

    return capsuleSize;
}

+ (NSArray *)capsules {
    static NSArray *capsules;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *array = [NSMutableArray array];
        for (id value in GetJSONResource(@"capsules")) {
            [array addObject:[[Capsule alloc] initWithJSONValue:value]];
        }
        capsules = [array copy];
    });
    return capsules;
}

- (id)initWithJSONValue:(id)JSONValue {
    self = [self init];
    if (self) {
        self.type = ObjectFromJSONValue(JSONValue[@"type"]);
        self.imageName = ObjectFromJSONValue(JSONValue[@"imageName"]);
        self.sizes = ObjectFromJSONValue(JSONValue[@"sizes"]);
        self.prices = ObjectFromJSONValue(JSONValue[@"prices"]);
        self.name = ObjectFromJSONValue(JSONValue[@"name"]);
        self.title = ObjectFromJSONValue(JSONValue[@"title"]);
        self.shortDescription = ObjectFromJSONValue(JSONValue[@"shortDescription"]);
        self.longDescription = ObjectFromJSONValue(JSONValue[@"longDescription"]);
        self.linkDescription = ObjectFromJSONValue(JSONValue[@"link"]);
        self.dailyRecommendation = ObjectFromJSONValue(JSONValue[@"dailyRecommendation"]);
    }
    return self;
}

@end
