//
//  TimelineEntryMood.h
//  Flatland
//
//  Created by Bogdan Chitu on 11/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineEntry.h"

typedef enum _Moods
{
    MOOD_UNKNOWN = 0,
    MOOD_HUNGRY,
    MOOD_FUSSY,
    MOOD_SILLY,
    MOOD_GRUMPY,
    MOOD_HAPPY,
    MOOD_SAD,
    MOOD_TIRED,
    MOOD_REBELIOUS
}Mood;

extern NSString* StringFroMood(Mood mood);

@interface TimelineEntryMood : TimelineEntry
{
}

@property (nonatomic, readwrite) Mood mood;
@property (nonatomic, strong) NSString* comment;

- (TimelineEntryCell*) cellForEntry;

@end
