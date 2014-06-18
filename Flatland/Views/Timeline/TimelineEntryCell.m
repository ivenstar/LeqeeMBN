//
//  TimelineEntryCell.m
//  Flatland
//
//  Created by Bogdan Chitu on 15/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineEntryCell.h"
#import "TimelineEntry.h"
#import "TimelineSharingView.h"

@interface TimelineEntryCell()
@property (weak, nonatomic) IBOutlet UIImageView *entryThumbImage;
@property (weak, nonatomic) IBOutlet UIView *bubbleView;

//share
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@end

@implementation TimelineEntryCell

- (void) setUpCell
{
    self.bubbleView.cornerRadius = 8;
    self.bubbleView.layer.masksToBounds = YES;
    [self icnhLocalizeSubviews];
    [self changeSystemFontToApplicationFont];
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setUpCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)doShare:(id)sender
{
    TimelineSharingView* sv =  [[[NSBundle mainBundle] loadNibNamed:@"TimelineSharingView" owner:self options:nil] objectAtIndex:0];
    CGRect svFrame = sv.frame;
    svFrame.origin.x = self.shareButton.frame.origin.x - (svFrame.size.width/2) - 30;
    svFrame.origin.y = self.shareButton.frame.origin.y + self.shareButton.frame.size.height - 10;
    sv.frame = svFrame;
    
    sv.timelineEntry = _entry;
    
    [self.shareButton.superview addSubview:sv];
    

}

@end
