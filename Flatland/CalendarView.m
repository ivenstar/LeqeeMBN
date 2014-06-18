//
//  HomeCalendarView.m
//  Flatland
//
//  Created by Stefan Aust on 15.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CalendarView.h"
#import "CalendarPopupView.h"
#import <QuartzCore/QuartzCore.h>


@interface CalendarView () <CalendarPopupViewDelegate>

@end


@interface HomeCalendarViewDateView : UIView 

@property (nonatomic, getter = isSelected) BOOL selected;
@property (nonatomic, strong) NSDate *date;

@end


@implementation CalendarView {
    CalendarPopupView *_cv;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self awakeFromNib];
    return self;
}

- (void)awakeFromNib {
    CGRect frame = self.bounds;
    
    UIButton *calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    calendarButton.frame = CGRectMake(frame.size.width - 48 - 6, 6, 48, frame.size.height - 12);
    calendarButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    calendarButton.backgroundColor = [UIColor colorWithRGBString:@"9894B7"];
    calendarButton.layer.cornerRadius = 8;
    [calendarButton setImage:[UIImage imageNamed:@"icon-calendar"] forState:UIControlStateNormal];
    [calendarButton addTarget:self action:@selector(openCalendar) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:calendarButton];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(6, 6, frame.size.width - 48 - 18, frame.size.height - 12)];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.cornerRadius = 8;
    [self addSubview:containerView];
    
    if (!self.selectedDate) {
        self.selectedDate = [NSDate date];
    } else {
        [self updateView];
    }
}

- (void)setSelectedDate:(NSDate *)selectedDate
{
    if (_selectedDate != selectedDate) {
        _selectedDate = selectedDate;
        [self updateView];
    }
}

- (void)setDidSelectDate:(int)didSelectDate {
    _didSelectDate = didSelectDate;
    [self updateViewDidSelectedDate];
}

- (void)openCalendar {
    _cv = [CalendarPopupView calendarViewWith:_selectedDate calender:[NSCalendar currentCalendar]];
    int offset = 0;
    if (IS_IOS7) offset = 58;
    _cv.view.frame = CGRectMake(0, 5+offset, 320, 281);
    if([self.delegate respondsToSelector:@selector(doAdjustCapsuleStockNotification)]) {
        [self.superview.superview addSubview:_cv.view];
    } else {
        [self.superview addSubview:_cv.view];
    }                                           
    _cv.delegate = self;
}

- (void)calenderView:(CalendarPopupView *)calenderView didSelectDate:(NSDate *)date {
    [calenderView.view removeFromSuperview];
    _cv = nil;
    [self setSelectedDate:date];
    [self.delegate calenderView:self didSelectDate:date];
}

- (CGSize)sizeThatFits:(CGSize)size {
    size.width = MIN(size.width, 48 + 18);
    size.height = 48 + 12;
    return size;
}

- (void)updateView {
    
    UIView *containerView = [self.subviews objectAtIndex:1];
    for (UIView *view in containerView.subviews) {
        [view removeFromSuperview];
    }
    
    if (self.selectedDate) {
        CGSize size = containerView.bounds.size;
        CGFloat x = (size.width - 6 * 42) / 2;
        CGFloat y = (size.height - 38) / 2;
        for (int i = 0; i < 6; i++)
        {
            HomeCalendarViewDateView *view = [[HomeCalendarViewDateView alloc] initWithFrame:CGRectMake(x + i * 42, y, 42, 38)];
            view.date = [self.selectedDate dateByAddingTimeInterval:24 * 60 * 60 * (i - 5)];
            view.selected = i == 5;
            view.tag = i;
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDate:)]];
            [containerView addSubview:view];
        }
    }
}

- (void)updateViewDidSelectedDate {
    UIView *containerView = [self.subviews objectAtIndex:1];
    for (UIView *view in containerView.subviews) {
        [view removeFromSuperview];
    }
    
        CGSize size = containerView.bounds.size;
        CGFloat x = (size.width - 6 * 42) / 2;
        CGFloat y = (size.height - 38) / 2;
        for (int i = 0; i < 6; i++) {
            HomeCalendarViewDateView *view = [[HomeCalendarViewDateView alloc] initWithFrame:CGRectMake(x + i * 42, y, 42, 38)];
            view.date = [self.selectedDate dateByAddingTimeInterval:24 * 60 * 60 * (i - 5)];
            view.selected = i == _didSelectDate;
            view.tag = i;
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDate:)]];
            [containerView addSubview:view];
        }
}

- (void)selectDate:(UITapGestureRecognizer *)r
{
    UIView *containerView = [self.subviews objectAtIndex:1];
    for (HomeCalendarViewDateView *view in containerView.subviews)
    {
        view.selected = view == r.view;
    }
    
    HomeCalendarViewDateView *selectedView = (HomeCalendarViewDateView *)r.view;
    if (_selectedDate != selectedView.date) {
        _selectedDate = selectedView.date;
        _didSelectDate = r.view.tag;
        [self.delegate calenderView:self didSelectDate:selectedView.date];
    }
}

-(int)getIndexOfDate:(NSDate *) date
{
    UIView *containerView = [self.subviews objectAtIndex:1];
    for (HomeCalendarViewDateView  *  view in containerView.subviews) {
        NSLog(@"%d",view.tag);
    }
    return 1;
}

-(void)setBaseDate:(NSDate *)dt
{
    
    [_cv setBaseDate:dt];
    [self setSelectedDate:dt];
    [self.delegate calenderView:self didSelectDate:dt];
    
}

@end


@implementation HomeCalendarViewDateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self awakeFromNib];
    return self;
}

- (void)awakeFromNib
{
    self.layer.cornerRadius = 8;
    
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 42, 14)];
    dayLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    dayLabel.backgroundColor = [UIColor clearColor];
    dayLabel.font = [UIFont regularFontOfSize:14];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:dayLabel];

    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 42, 12)];
    monthLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    monthLabel.backgroundColor = [UIColor clearColor];
    monthLabel.font = [UIFont thinFontOfSize:11];
    monthLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:monthLabel];
    
    [self updateView];
}

- (void)setDate:(NSDate *)date {
    if (_date != date) {
        _date = date;
        [self updateView];
    }
}

- (void)setSelected:(BOOL)selected {
    if (_selected != selected) {
        _selected = selected;
        [self updateView];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(42, 38);
}

- (void)updateView {
    UILabel *dayLabel = [self.subviews objectAtIndex:0];
    UILabel *monthLabel = [self.subviews objectAtIndex:1];
    
    if (self.selected) {
        self.backgroundColor = [UIColor colorWithRGBString:@"45425F"];
        dayLabel.textColor = monthLabel.textColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
        dayLabel.textColor = monthLabel.textColor = [UIColor colorWithRGBString:@"4C4A5E"];
    }

    if (self.date) {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:language];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setLocale:locale];
        [df setCalendar:[NSCalendar currentCalendar]];
        [df setDateFormat:@"EEEEE dd"];
        dayLabel.text = [df stringFromDate:self.date];
        [df setDateFormat:@"MMM."];
        monthLabel.text = [df stringFromDate:self.date];
    } else {
        dayLabel.text = @"";
        monthLabel.text = @"";
    }
}

@end