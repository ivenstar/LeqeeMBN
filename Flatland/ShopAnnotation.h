//
//  ShopAnnotation.h
//  Flatland
//
//  Created by Jochen Block on 10.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ShopAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSArray *store;
- (id)initWithStore:(NSArray *)newStore;

@end
