//
//  TimelineEntryPhoto.h
//  Flatland
//
//  Created by Bogdan Chitu on 11/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineEntry.h"

@interface TimelineEntryPhoto : TimelineEntry
{
}

@property (nonatomic, strong) NSString* pictureUrl;
@property (nonatomic, strong) NSString* comment;
@property (nonatomic, strong) UIImage* image;

@end
