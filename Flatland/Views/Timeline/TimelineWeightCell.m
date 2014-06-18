//
//  TimelineWeightCell.m
//  Flatland
//
//  Created by Bogdan Chitu on 29/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineWeightCell.h"

@interface TimelineWeightCell()
//TODO CHANGE ICON
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation TimelineWeightCell

- (void) setUpWithWeight:(TimelineEntryWeight*) entry
{
    self.titleLabel.text = entry.title;
    self.dateLabel.text = FormattedDateForTimeline(entry.date);
    
    _entry = entry;
}

@end
