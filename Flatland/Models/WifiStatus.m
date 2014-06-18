//
//  WifiStatus.m
//  Flatland
//
//  Created by Bogdan Chitu on 17/03/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "WifiStatus.h"

static NSDictionary* WifiStatusStringIDs;

@implementation WifiStatusIDs

+ (void) initialize
{
    WifiStatusStringIDs = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"Unknown", [NSNumber numberWithInt:WIFI_STATUS_UNKNOWN],
                           @"NoWifi", [NSNumber numberWithInt:WIFI_STATUS_NO_WIFI],
                           @"Connected", [NSNumber numberWithInt:WIFI_STATUS_CONNECTED],
                           @"Configuring", [NSNumber numberWithInt:WIFI_STATUS_CONFIGURING],
                           @"Configured", [NSNumber numberWithInt:WIFI_STATUS_CONFIGURED],
                           @"Deactivated", [NSNumber numberWithInt:WIFI_STATUS_DEACTIVATED],
                           nil];
}


+ (NSString*) idForValue:(WifiStatus) value
{
    NSString* retVal = [WifiStatusStringIDs objectForKey:[NSNumber numberWithInt:value]];
    if (retVal == nil)
    {
        retVal = [WifiStatusStringIDs objectForKey:[NSNumber numberWithInt:WIFI_STATUS_UNKNOWN]];
    }

    return retVal;
}

+ (WifiStatus) valueForID: (NSString*) stringID;
{
    for (NSNumber* key in [WifiStatusStringIDs allKeys])
    {
        if ([[WifiStatusStringIDs objectForKey:key] isEqualToString:stringID])
        {
            return (WifiStatus)[key intValue];
        }
    }
    
    return WIFI_STATUS_UNKNOWN;
}

@end

