//
//  TimelineEntryWeight.m
//  Flatland
//
//  Created by Bogdan Chitu on 29/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineEntryWeight.h"
#import "TimelineWeightCell.h"

@implementation TimelineEntryWeight


- (TimelineEntryCell*) cellForEntry
{
    TimelineWeightCell *weightCell = [[[NSBundle mainBundle] loadNibNamed:@"TimelineWeightCell" owner:self options:nil] objectAtIndex:0];
    [weightCell setUpWithWeight:self];
    return weightCell;
}

@end
