//
//  Section.m
//  Flatland
//
//  Created by Jochen Block on 26.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Section.h"

@implementation Section

@synthesize minValue, maxValue, midValue, value;

- (NSString *) description {
    
    return [NSString stringWithFormat:@"%i | %f, %f, %f", self.value, self.minValue, self.midValue, self.maxValue];
    
}

@end
