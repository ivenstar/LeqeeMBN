//
//  TimelineEntryJournal.m
//  Flatland
//
//  Created by Bogdan Chitu on 11/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineEntryJournal.h"
#import "TimelineJournalCell.h"

@implementation TimelineEntryJournal

- (void) setComment:(NSString *)comment
{
    _comment = comment;
    _dirty = YES;
}

- (TimelineEntryCell*) cellForEntry;
{
    TimelineJournalCell *jourlanCell = [[[NSBundle mainBundle] loadNibNamed:@"TimelineJournalCell" owner:self options:nil] objectAtIndex:0];
    [jourlanCell setUpWithJournalEntry:self];
    return jourlanCell;
}

- (id) data
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    
    [data setObject:self.title forKey:@"title"];
    [data setObject:self.comment forKey:@"description"];
    [data setObject:JSONValueFromDate(self.date) forKey:@"time"];
    [data setObject:@"journal" forKey:@"type"];
    
    return data;
}

@end
