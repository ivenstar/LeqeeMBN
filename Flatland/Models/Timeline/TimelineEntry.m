//
//  TimelineEntry.m
//  Flatland
//
//  Created by Bogdan Chitu on 11/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineEntry.h"

@implementation TimelineEntry
@synthesize dirty=_dirty;

- (GLfloat) cellHeightForEntry
{
    if (_dirty)
    {
        //calculate cell height;
        TimelineEntryCell *cell = [self cellForEntry];
        _cellHeight = cell.contentView.frame.size.height;
        _dirty = NO;
    }
    
    return _cellHeight;
}

- (void) setTitle:(NSString *)title
{
    _title = title;
    _dirty = YES;
}

- (id) init
{
    if (self = [super init])
    {
        _dirty = YES;
        _cellHeight = 0;
    }
    return self;
}

- (TimelineEntryCell*) cellForEntry;
{
    return nil;
}

- (id) data
{
    return nil;
}

@end
