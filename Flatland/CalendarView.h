//
//  HomeCalendarView.h
//  Flatland
//
//  Created by Stefan Aust on 15.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarView;

@protocol CalendarViewDelegate <NSObject>

- (void)calenderView:(CalendarView *)calenderView didSelectDate:(NSDate *)date;

@end

@interface CalendarView : UIView

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic) int didSelectDate;
@property (nonatomic, weak) id<CalendarViewDelegate> delegate;
-(int)getIndexOfDate:(NSDate *) date;
-(void)setBaseDate:(NSDate *)dt;

@end
