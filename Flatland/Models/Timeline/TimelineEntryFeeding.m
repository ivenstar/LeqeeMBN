//
//  TimelineEntryFeeding.m
//  Flatland
//
//  Created by Bogdan Chitu on 28/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineEntryFeeding.h"
#import "TimelineFeedingCell.h"

@implementation TimelineEntryFeeding

- (TimelineEntryCell*) cellForEntry
{
    TimelineFeedingCell *feedingCell = [[[NSBundle mainBundle] loadNibNamed:@"TimelineFeedingCell" owner:self options:nil] objectAtIndex:0];
    [feedingCell setUpWithFeeding:self];
    return feedingCell;
}

@end
