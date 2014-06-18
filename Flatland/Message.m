//
//  Message.m
//  Flatland
//
//  Created by Magdalena Kamrowska on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Message.h"

@implementation NotificationMessage

-(id)initWithJSONObject:(id)object {
    self = [super init];
    if (self) {
        _babyMessage = StringFromJSONObject([object valueForKey:@"babyMessage"]);
        _date = DateWithoutTimezoneFromJSONValue([object valueForKey:@"date"]);
    }
    return self;
}

@end
