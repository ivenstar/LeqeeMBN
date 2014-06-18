//
//  TimelineService.h
//  Flatland
//
//  Created by Bogdan Chitu on 18/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baby.h"
#import "TimelineEntry.h"
#import "TimelineEntryPhoto.h"

@interface TimelineService : NSObject


/**
 Requests entries from server and calls block with an array containing them and the last timestamp from the array
 @param baby            the babay for witch to load the entries
 @param date            the date from witch to load entries
 @param entriesPerPage  the number of entries that should be returned
 
 @return nothing
 
 @block param entries       the array of entries
 @block param lasttimestamp the timestamp of the last entry.-1 if null is returned from server,-2 for errors.
 **/
+ (void)getEntriesForBaby:(Baby*)baby withDate:(NSDate*)date andEntriesPerPage:(NSUInteger)entriesPerPage completion:(void (^)(NSArray *entries,NSTimeInterval lastTimeStamp))completion;

+ (void) saveEntry:(TimelineEntry*) entry forBaby:(Baby*)baby completion:(void (^)(BOOL success, NSArray* errors))completion;

+ (void) savePhotoEntry: (TimelineEntryPhoto*) photoEntry forBaby: (Baby*) baby withCompletion:(void (^)(BOOL success))uploadCompletion;

@end
