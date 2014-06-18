//
//  CalenderView.h
//  Flatland
//
//  Created by Stefan Aust on 22.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarPopupView;

@protocol CalendarPopupViewDelegate <NSObject>

- (void)calenderView:(CalendarPopupView *)calenderView didSelectDate:(NSDate *)date;

@optional
- (void)closeCalendar;

@end


@interface CalendarPopupView : NSObject

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) NSCalendar *calender;
@property (nonatomic, strong) NSDate *baseDate;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, weak) id<CalendarPopupViewDelegate> delegate;

/// create a calendar view with the preselected date and a calendar object
+ (CalendarPopupView *)calendarViewWith:(NSDate *)baseDate calender:(NSCalendar *)calender;

@end
