//
//  InAppNotificationSettings.m
//  Flatland
//
//  Created by Bogdan Chitu on 28/02/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "InAppNotificationSettings.h"

#define INAPP_SETTINGS_TIPS_KEY @"tips"
#define INAPP_SETTINGS_STOCK_KEY @"stock"

@implementation InAppNotificationSettings

- (id) init
{
    if (self = [super init])
    {
        self.tips = true;
        self.stock = true;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    if (self = [self init])
    {
        self.tips = [aDecoder decodeBoolForKey:INAPP_SETTINGS_TIPS_KEY];
        self.stock = [aDecoder decodeBoolForKey:INAPP_SETTINGS_STOCK_KEY];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.tips forKey:INAPP_SETTINGS_TIPS_KEY];
    [aCoder encodeBool:self.stock forKey:INAPP_SETTINGS_STOCK_KEY];
}

@end
