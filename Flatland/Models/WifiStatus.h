//
//  WifiStatus.h
//  Flatland
//
//  Created by Bogdan Chitu on 17/03/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _WifiStatus {
    WIFI_STATUS_UNKNOWN = 0,
    WIFI_STATUS_NO_WIFI,
    WIFI_STATUS_CONNECTED,
    WIFI_STATUS_CONFIGURING,
    WIFI_STATUS_CONFIGURED,
    WIFI_STATUS_DEACTIVATED
}WifiStatus;
//If you add a new value,add it to the string ids dictionary also(see the m file)

@interface WifiStatusIDs : NSObject

//returns string id for enum value
+ (NSString*) idForValue:(WifiStatus) value;

//returns enum value for string id
+ (WifiStatus) valueForID: (NSString*) stringID;

@end
