//
//  RESTResponse.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 19.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "RESTResponse.h"

@implementation RESTResponse

- (BOOL)success; {
    if (self.error) {
        return NO;
    }
    if (self.statusCode == 200) {
        if ([self.object isKindOfClass:[NSDictionary class]]) {
            return [self.object[@"success"] boolValue];
        }
        return YES;
    }
    if (self.statusCode == 201 || self.statusCode == 204) {
        return YES;
    }
    return NO;
}

@end
