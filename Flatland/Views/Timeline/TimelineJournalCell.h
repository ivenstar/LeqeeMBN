//
//  TimelineJournalCell.h
//  Flatland
//
//  Created by Bogdan Chitu on 15/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineEntryCell.h"
#import "TimelineEntryJournal.h"

@interface TimelineJournalCell : TimelineEntryCell

- (void) setUpWithJournalEntry: (TimelineEntryJournal*) journalEntry;

@end
