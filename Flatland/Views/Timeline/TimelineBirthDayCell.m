//
//  TimelineBirthDayCell.m
//  Flatland
//
//  Created by Bogdan Chitu on 22/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineBirthDayCell.h"
@interface TimelineBirthDayCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation TimelineBirthDayCell

- (void) setUpWithBirthDayEntry: (TimelineEntryBirthDay*) entry
{
    self.titleLabel.text = entry.title;
    self.dateLabel.text = FormattedDateForTimeline(entry.date);
    
    _entry = entry;
}

@end
