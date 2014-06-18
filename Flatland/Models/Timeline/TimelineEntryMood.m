//
//  TimelineEntryMood.m
//  Flatland
//
//  Created by Bogdan Chitu on 11/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineEntryMood.h"
#import "TimelineMoodCell.h"

static NSArray* _moodStrings;
NSString* StringFroMood(Mood mood)
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _moodStrings = @[@"hungry",
                         @"fussy",
                         @"silly",
                         @"grumpy",
                         @"happy",
                         @"sad",
                         @"tired",
                         @"rebelious"];
    });
    
    return [_moodStrings objectAtIndex:(int) mood - 1];
}

@implementation TimelineEntryMood

- (void)setComment:(NSString *)comment
{
    _comment = comment;
    _dirty = YES;
}

- (TimelineEntryCell*) cellForEntry
{
    TimelineMoodCell *moodCell = [[[NSBundle mainBundle] loadNibNamed:@"TimelineMoodCell" owner:self options:nil] objectAtIndex:0];
    [moodCell setUpWithMoodEntry:self];
    return moodCell;
}

- (id) data
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    
     NSMutableDictionary* data = [[NSMutableDictionary alloc] init];

    [data setObject:StringFroMood(self.mood) forKey:@"mood"];
    [data setObject:self.comment forKey:@"description"];
    [data setObject:JSONValueFromDate(self.date) forKey:@"time"];
    [data setObject:@"mood" forKey:@"type"];
    
    return data;
}

@end
