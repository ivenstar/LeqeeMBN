//
//  TimelinePhotoCell.m
//  Flatland
//
//  Created by Bogdan Chitu on 15/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelinePhotoCell.h"
#import "TimelineEntryPhoto.h"

@interface TimelinePhotoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;


@end

@implementation TimelinePhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setupWithPhotoEntry: (TimelineEntryPhoto*) photoEntry
{
    self.titleLabel.text = photoEntry.title;
    self.dateLabel.text = FormattedDateForTimeline(photoEntry.date);
    self.captionLabel.text = photoEntry.comment;
    
    //resize the caption uilabel
    CGRect captionLabelFrame = self.captionLabel.frame;
    CGSize newCaptionLabelSize = [self.captionLabel sizeThatFits:CGSizeMake(captionLabelFrame.size.width, CGFLOAT_MAX)];
    CGFloat heightDif = newCaptionLabelSize.height - captionLabelFrame.size.height;
    
    captionLabelFrame.size = newCaptionLabelSize;
    self.captionLabel.frame = captionLabelFrame;
    
    //resize image view
    CGSize imageviewDefaultSize = self.image.frame.size;
    CGPoint imageviewDefaultCenter = self.image.center;
    
    UIImage* image = [photoEntry.image copy];
    CGSize imageSize = image.size;
    
    float newScale = imageSize.width == 0 ? 0 : imageviewDefaultSize.width/imageSize.width;
    
    
    if (newScale < 1)
    {
        imageSize.width = imageSize.width * newScale;
        imageSize.height = imageSize.height * newScale;
    }
    
    CGRect imageFrame = self.image.frame;
    imageFrame.size = imageSize;
    self.image.frame = imageFrame;
    
    //move it to the old center y and add height dif for the caption label frame previous resize
    CGPoint newCenter = self.image.center;
    newCenter.x = imageviewDefaultCenter.x;
    newCenter.y += heightDif;
    self.image.center = newCenter;
    self.image.image = image;
    
    heightDif += imageSize.height - imageviewDefaultSize.height;
    
    UIView* superView = self.image.superview;
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
    
    _entry = photoEntry;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
