//
//  CalenderView.m
//  Flatland
//
//  Created by Stefan Aust on 22.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CalendarPopupView.h"

@interface CalenderDaysView : UIView

@property (nonatomic, strong) NSCalendar *calender;

@end


@interface CalendarPopupView ()

@property (nonatomic, strong) IBOutlet UIView *weekdaysView;
@property (nonatomic, strong) IBOutlet CalenderDaysView *calenderDaysView;
@property (nonatomic, strong) IBOutlet UILabel *monthLabel;
@property (nonatomic, strong) IBOutlet UILabel *yearLabel;

@end


@interface CalenderDayView : UIButton

@property (nonatomic, assign) NSUInteger day;

@end


@implementation CalendarPopupView

- (IBAction)closeCalender:(id)sender {
    if([self.delegate respondsToSelector:@selector(closeCalendar)])
    {
        [self.delegate closeCalendar];
    }
    else
    {
        [self.view removeFromSuperview];
    }
}

+ (CalendarPopupView *)calendarViewWith:(NSDate *)baseDate calender:(NSCalendar *)calender {
    CalendarPopupView *calenderView = [self new];
    [[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] instantiateWithOwner:calenderView options:nil];
    [calenderView.view changeSystemFontToApplicationFont];
    calenderView.calender = calender;
    calenderView.baseDate = baseDate;
    return calenderView;
}

- (void)setBaseDate:(NSDate *)baseDate
{
    if (![_baseDate isEqualToDate:baseDate])
    {
        _baseDate = baseDate;
        [self refreshView];
    }
}

- (void)refreshView
{
    // initialize a date formatter to get localized week names and month names
    NSDateFormatter *df = [NSDateFormatter new];
    [df setCalendar:self.calender];
    //[df setLocale:[self.calender locale]];
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:language];
    [df setLocale:locale];

    // set the current month and the year from the date formatter
    [df setDateFormat:@"MMMM"];
    self.monthLabel.text = [[df stringFromDate:self.baseDate] capitalizedString];
    [df setDateFormat:@"YYYY"];
    self.yearLabel.text = [df stringFromDate:self.baseDate];

    // get the number of days per week (which might be != 7 for strange calendars)
    // then compute the maximum number of (partial) weeks per month
    NSUInteger daysPerWeek = [self.calender maximumRangeOfUnit:NSWeekdayCalendarUnit].length;
    NSUInteger daysPerMonth = [self.calender maximumRangeOfUnit:NSDayCalendarUnit].length;
    NSUInteger weeksPerMonth = (daysPerMonth + (daysPerWeek - 1) * 2) / daysPerWeek;
    
    // get the number of the first day of the week (sunday is always 1, monday is 2, etc.)
    NSUInteger firstWeekday = [self.calender firstWeekday] - 1;

    // there should be at least on view to copy settings from
    UILabel *cloneLabel = [self.weekdaysView.subviews lastObject];

    // remove the old weekday labels and create new one
    // we might be able to keep them as they will not change
    for (UIView *view in self.weekdaysView.subviews)
    {
        [view removeFromSuperview];
    }
    
    CGSize size = self.weekdaysView.bounds.size;
    CGFloat w = size.width / daysPerWeek, h = size.height;
    
    for (NSUInteger i = 0; i < daysPerWeek; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * w, 0, w, h)];
        label.backgroundColor = cloneLabel.backgroundColor;
        label.font = cloneLabel.font;
        label.text = [[df shortWeekdaySymbols][(i + firstWeekday) % daysPerWeek] capitalizedString];
        label.textColor = cloneLabel.textColor;
        label.textAlignment = cloneLabel.textAlignment;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight +
            UIViewAutoresizingFlexibleLeftMargin + UIViewAutoresizingFlexibleRightMargin;
        [self.weekdaysView addSubview:label];
    }

    // get the number of days in the current month
    NSUInteger daysInMonth = [self.calender rangeOfUnit:NSDayCalendarUnit
                                                 inUnit:NSMonthCalendarUnit
                                                forDate:self.baseDate].length;
    
    // get the weekday of the first day of the current month
    NSUInteger options = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [self.calender components:options fromDate:self.baseDate];
    [components setDay:1];
    NSDate *firstDayOfMonthDate = [self.calender dateFromComponents:components];
    NSUInteger weekdayOfFirstDayOfMonth = [[self.calender components:NSWeekdayCalendarUnit
                                                            fromDate:firstDayOfMonthDate] weekday];
    
    // there should be at least one view to copy settings from
    UIButton *cloneButton = [self.calenderDaysView.subviews lastObject];
    
    // remove the old day buttons and create new one
    // we might be able to reuse most of them, but that was too difficult...
    for (UIView *view in self.calenderDaysView.subviews) {
        [view removeFromSuperview];
    }

    for (NSUInteger i = 0; i < daysPerWeek * weeksPerMonth; i++)
    {
        NSInteger day = i - weekdayOfFirstDayOfMonth + firstWeekday - 5;
        CalenderDayView *view = [CalenderDayView new];
        view.titleLabel.font = cloneButton.titleLabel.font;
        view.backgroundColor = [UIColor colorWithRGBString:@"4B4965"];
        [view setTitleColor:[cloneButton titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
        [view setTitleColor:[cloneButton titleColorForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
        [view setTitleColor:[cloneButton titleColorForState:UIControlStateSelected] forState:UIControlStateSelected];
        
        if (day < 1 || day > daysInMonth) {
            view.enabled = NO;
        }
        else
        {
            view.day = day;
            [view addTarget:self action:@selector(selectDay:) forControlEvents:UIControlEventTouchUpInside];
            if ([self isDayBaseDay:day]) {
                [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [view setBackgroundColor:[UIColor colorWithRGBString:@"9792BF"]];
            }
        }
        [self.calenderDaysView addSubview:view];
    }
    self.calenderDaysView.calender = self.calender;
}

- (BOOL)isDayBaseDay:(NSUInteger)day {
    NSUInteger options = NSYearCalendarUnit+NSMonthCalendarUnit+NSDayCalendarUnit;
    NSDateComponents *baseComponents = [self.calender components:options fromDate:self.baseDate];
    return day == baseComponents.day;
}

- (IBAction)previousMonth {
    NSDateComponents *c = [NSDateComponents new];
    c.month = -1;
    self.baseDate = [self.calender dateByAddingComponents:c toDate:self.baseDate options:0];
}

- (IBAction)nextMonth {
    NSDateComponents *c = [NSDateComponents new];
    c.month = +1;
    self.baseDate = [self.calender dateByAddingComponents:c toDate:self.baseDate options:0];
}

- (IBAction)previousYear {
    NSDateComponents *c = [NSDateComponents new];
    c.year = -1;
    self.baseDate = [self.calender dateByAddingComponents:c toDate:self.baseDate options:0];
}

- (IBAction)nextYear {
    NSDateComponents *c = [NSDateComponents new];
    c.year = +1;
    self.baseDate = [self.calender dateByAddingComponents:c toDate:self.baseDate options:0];
}

- (IBAction)selectDay:(CalenderDayView *)view {
    NSUInteger options = NSYearCalendarUnit+NSMonthCalendarUnit+NSDayCalendarUnit+NSHourCalendarUnit+NSMinuteCalendarUnit+NSSecondCalendarUnit;
    NSDateComponents *base = [self.calender components:options fromDate:self.baseDate];
    base.day = view.day;
    self.selectedDate = [self.calender dateFromComponents:base];
    [self.delegate calenderView:self didSelectDate:self.selectedDate];
}

@end


@implementation CalenderDaysView

- (void)layoutSubviews {
    // get the number of days per week (which might be != 7 for strange calendars)
    NSUInteger daysPerWeek = [self.calender maximumRangeOfUnit:NSWeekdayCalendarUnit].length;
    NSUInteger daysPerMonth = [self.calender maximumRangeOfUnit:NSDayCalendarUnit].length;
    NSUInteger weeksPerMonth = (daysPerMonth + (daysPerWeek - 1) * 2) / daysPerWeek;

    // layout day components
    CGSize size = self.bounds.size;
    CGFloat width = roundf(size.width / daysPerWeek);
    CGFloat height = roundf(size.height / weeksPerMonth); // maximum number of weeks per month

    NSUInteger i = 0;
    for (UIView *view in self.subviews) {
        NSUInteger j = i / daysPerWeek;
        view.frame = CGRectMake((i % daysPerWeek) * width, j * height, width - 1, height - 1);
        i++;
    }
}

@end


@implementation CalenderDayView {
    UIColor *_originalBackgroundColor;
}

- (void)setDay:(NSUInteger)day {
    if (_day != day) {
        _day = day;
        [self setTitle:[NSString stringWithFormat:@"%d", day] forState:UIControlStateNormal];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    if (self.highlighted != highlighted) {
        [super setHighlighted:highlighted];
        if (highlighted) {
            _originalBackgroundColor = self.backgroundColor;
            self.backgroundColor = [UIColor colorWithRGBString:@"9792BF"];
        } else {
            self.backgroundColor = _originalBackgroundColor;
        }
    }
}

@end
