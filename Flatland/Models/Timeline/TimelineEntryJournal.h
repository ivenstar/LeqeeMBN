//
//  TimelineEntryJournal.h
//  Flatland
//
//  Created by Bogdan Chitu on 11/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineEntry.h"

@interface TimelineEntryJournal : TimelineEntry
{
}

@property (nonatomic, strong) NSString* comment;

- (TimelineEntryCell*) cellForEntry;

@end
