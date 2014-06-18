//
//  ShopAnnotation.m
//  Flatland
//
//  Created by Jochen Block on 10.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "ShopAnnotation.h"

@interface ShopAnnotation()
{
    CLLocationCoordinate2D coordinate;
}

@end

@implementation ShopAnnotation

@synthesize store;

- (id)initWithStore:(NSArray *)newStore {
    if ((self = [self init])) {
        self.store = newStore;
    }
    return self;
}

- (void)setStore:(NSArray *)newStore {
    if (store != newStore) {
        store = nil;
        store = [newStore copy];
        
        // extract and cache the coordinate because it's requested often
        CLLocationDegrees latitude = [[store valueForKey:@"latitude"] doubleValue];
        CLLocationDegrees longitude = [[store valueForKey:@"longitude"] doubleValue];
        coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    }
}

- (CLLocationCoordinate2D)coordinate {
    return coordinate;
}

- (NSString *)title {
    return [store valueForKey:@"name"];
}

@end
