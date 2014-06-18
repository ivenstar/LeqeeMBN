//
//  TimelineEntryCell.h
//  Flatland
//
//  Created by Bogdan Chitu on 15/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TimelineEntry;

@interface TimelineEntryCell : UITableViewCell
{
    TimelineEntry* _entry;
}

@property (weak, nonatomic) IBOutlet UIView *topLine;//Top part of vertical line
@property (weak, nonatomic) IBOutlet UIView *bottomLine;//bottom part of vertical line



@end
