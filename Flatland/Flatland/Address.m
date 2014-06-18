//
//  Address.m
//  Flatland
//
//  Created by Stefan Aust on 22.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Address.h"

@implementation Address

- (NSString *)titleString {
    if (self.title == AddressTitleMadam) {
        return @"Mme";
    }
    if (self.title == AddressTitleMister) {
        return @"M";
    }
    return @"";
}

@end
