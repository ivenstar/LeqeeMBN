//
//  TimelineJournalCell.m
//  Flatland
//
//  Created by Bogdan Chitu on 15/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineJournalCell.h"

@interface TimelineJournalCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end


@implementation TimelineJournalCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setUpWithJournalEntry: (TimelineEntryJournal*) journalEntry
{
    self.titleLabel.text = journalEntry.title;
    self.dateLabel.text = FormattedDateForTimeline(journalEntry.date);
    
    self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.text = journalEntry.comment;
    
    //setup description frame
    CGSize descriptionOriginalSize = self.descriptionLabel.frame.size;
    
    self.descriptionLabel.preferredMaxLayoutWidth = self.descriptionLabel.frame.size.width;
    [self.descriptionLabel sizeToFit];
    
    
    CGFloat heightDif = self.descriptionLabel.frame.size.height - descriptionOriginalSize.height;
    
    UIView* superView = self.descriptionLabel.superview;
    do
    {
        CGRect superViewFrame = superView.frame;
        superViewFrame.size.height += heightDif;
        superView.frame = superViewFrame;
        
        superView = superView.superview;
    }while (superView != nil);
    
    //increase frame of bottom bar
    CGRect bottomBarFrame = self.bottomLine.frame;
    bottomBarFrame.size.height += heightDif;
    self.bottomLine.frame = bottomBarFrame;
    
    _entry = journalEntry;
}

@end
