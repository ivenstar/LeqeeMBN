//
//  SSID.m
//  Flatland
//
//  Created by Ionel Pascu on 12/9/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "SSID.h"

@implementation SSID
-(id)initWithJSONObject:(id)JSONObject{
    self = [self init];
    if (self){
        _ssid = StringFromJSONObject([JSONObject valueForKey:@"ssid"]);
        _strength = StringFromJSONObject([JSONObject valueForKey:@"strength"]);
        _encryption = StringFromJSONObject([JSONObject valueForKey:@"enc"]);
        _channel = StringFromJSONObject([JSONObject valueForKey:@"channel"]);
        _auth = StringFromJSONObject([JSONObject valueForKey:@"auth"]);
    }
    return self;
}

@end
