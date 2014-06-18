//
//  TimelineFeedingCell.m
//  Flatland
//
//  Created by Bogdan Chitu on 28/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineFeedingCell.h"

@interface TimelineFeedingCell()
//TODO CHANGE ICON
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation TimelineFeedingCell

- (void) setUpWithFeeding: (TimelineEntryFeeding*) entry
{
    self.titleLabel.text = entry.title;
    self.dateLabel.text = FormattedDateForTimeline(entry.date);
    
   _entry = entry; 
}

@end
