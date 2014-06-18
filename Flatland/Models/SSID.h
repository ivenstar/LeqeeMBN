//
//  SSID.h
//  Flatland
//
//  Created by Ionel Pascu on 12/9/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSID : NSObject
@property (nonatomic, copy) NSString *ssid;
@property (nonatomic, copy) NSString *strength;
@property (nonatomic, copy) NSString *encryption;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *auth;

- (id)initWithJSONObject:(id)JSONObject;
@end
