//
//  Country.m
//  Flatland
//
//  Created by Bogdan Chitu on 13/02/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "Country.h"

@implementation Country

@synthesize code,name;

- (id) initWithCode:(NSString*) stateCode andName: (NSString*) stateName
{
    if(self = [super init])
    {
        self.code = stateCode;
        self.name = stateName;
    }
    
    return self;
}

@end
