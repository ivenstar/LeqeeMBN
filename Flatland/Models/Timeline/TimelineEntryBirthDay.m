//
//  TimelineEntryBirthDay.m
//  Flatland
//
//  Created by Bogdan Chitu on 22/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineEntryBirthDay.h"
#import "TimelineBirthDayCell.h"

@implementation TimelineEntryBirthDay

- (TimelineEntryCell*) cellForEntry
{
    TimelineBirthDayCell *birthDayCell = [[[NSBundle mainBundle] loadNibNamed:@"TimelineBirthDayCell" owner:self options:nil] objectAtIndex:0];
    [birthDayCell setUpWithBirthDayEntry:self];
    return birthDayCell;
}

@end
