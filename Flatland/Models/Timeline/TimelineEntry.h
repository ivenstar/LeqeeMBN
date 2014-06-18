//
//  TimelineEntry.h
//  Flatland
//
//  Created by Bogdan Chitu on 11/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimelineEntryCell.h"

@interface TimelineEntry : NSObject
{
    GLfloat _cellHeight;
    BOOL _dirty;
}

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString* title;

@property (nonatomic, readonly) BOOL dirty; //causes recalculation of cell height after data modifications

- (GLfloat) cellHeightForEntry; //cell height for current entry

- (TimelineEntryCell*) cellForEntry;

- (id) data;//returns NSdictionary of data(for server)

@end
