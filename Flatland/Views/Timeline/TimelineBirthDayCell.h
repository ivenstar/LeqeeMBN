//
//  TimelineBirthDayCell.h
//  Flatland
//
//  Created by Bogdan Chitu on 22/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineEntryBirthDay.h"

@interface TimelineBirthDayCell : TimelineEntryCell

- (void) setUpWithBirthDayEntry: (TimelineEntryBirthDay*) entry;

@end
