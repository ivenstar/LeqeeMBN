//
//  TimelineMoodCell.m
//  Flatland
//
//  Created by Bogdan Chitu on 15/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineMoodCell.h"

@interface TimelineMoodCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;


@end

@implementation TimelineMoodCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setUpWithMoodEntry: (TimelineEntryMood*) mood
{
    self.titleLabel.text = mood.title;
    self.dateLabel.text = FormattedDateForTimeline(mood.date);
    
    self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.text = mood.comment;
    
    //setup comment frame
    CGRect commentFrame = self.commentLabel.frame;
    CGSize commentFrameOriginalSize = commentFrame.size;
    
    self.commentLabel.preferredMaxLayoutWidth = self.commentLabel.frame.size.width;
    [self.commentLabel sizeToFit];
    
    
    CGFloat heightDif = self.commentLabel.frame.size.height - commentFrameOriginalSize.height;
    UIView* superView = self.commentLabel.superview;
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
    
    _entry = mood;
}

@end
