//
//  TimelineFeedingCell.h
//  Flatland
//
//  Created by Bogdan Chitu on 28/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineEntryCell.h"
#import "TimelineEntryFeeding.h"

@interface TimelineFeedingCell : TimelineEntryCell

- (void) setUpWithFeeding: (TimelineEntryFeeding*) entry; 

@end
