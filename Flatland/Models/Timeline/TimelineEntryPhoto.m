//
//  TimelineEntryPhoto.m
//  Flatland
//
//  Created by Bogdan Chitu on 11/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineEntryPhoto.h"
#import "TimelinePhotoCell.h"

@implementation TimelineEntryPhoto
{
}

- (void)setComment:(NSString *)comment
{
    _comment = comment;
    _dirty = YES;
}

- (void) setImage:(UIImage *)image
{
    _image = image;
    _dirty = YES;
}


- (TimelineEntryCell*) cellForEntry
{
    TimelinePhotoCell *photoCell = [[[NSBundle mainBundle] loadNibNamed:@"TimelinePhotoCell" owner:self options:nil] objectAtIndex:0];
    [photoCell setupWithPhotoEntry:self];
    return photoCell;
}


@end
