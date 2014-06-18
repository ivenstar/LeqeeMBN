//
//  EditBreastfeedingViewController.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 23.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "EditBreastfeedingViewController.h"
#import "FlatRadioButtonGroup.h"
#import "CalendarView.h"
#import "AlertView.h"
#import "WaitIndicator.h"
#import "OverlaySaveView.h"
#import "ListBreastfeedingViewController.h"

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

static NSDateFormatter *timeFormatter = nil;

@interface EditBreastfeedingViewController () <UITextFieldDelegate, CalendarViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startStopBtn;
@property (weak, nonatomic) IBOutlet UIImageView *progressImageView;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet FlatRadioButtonGroup *breastSideButtons;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIToolbar *accessoryView;

@property (weak, nonatomic) IBOutlet UITextField *startTimeField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeField;

@property (weak, nonatomic) IBOutlet CalendarView *calendarView;

@end

@implementation EditBreastfeedingViewController {
    BOOL _running;
    NSTimer *stopTimer;
    CGFloat totalDegrees;
    NSInteger minutes, seconds;
    NSDate *startDate, *endDate;
    UITextField *currentTimeField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = MakeImageBarButton(@"barbutton-done", self, @selector(donePressed));
    
    //setup all the views
    self.formScrollView.contentSize = CGSizeMake(320, 512);
    self.breastSideButtons.selectedIndex = 0;
    if (_isEditing) {
        timeFormatter = [NSDateFormatter new];
        [timeFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [timeFormatter setDateFormat:@"HH'h'mm"];
        
        [_startStopBtn setEnabled:NO];
    }else{
        timeFormatter = [NSDateFormatter new];
        [timeFormatter setDateFormat:@"HH'h'mm"];
        [_startStopBtn setEnabled:YES];
    }
    
    if (self.datePicker == nil) {
        self.datePicker = [UIDatePicker new];
        
        self.accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
        self.accessoryView.barStyle = UIBarStyleBlackTranslucent;
        self.accessoryView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(datePickerDonePressed)];
        UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.accessoryView.items = [NSArray arrayWithObjects:flexibleSpace, doneButton, nil];
        
        self.datePicker.datePickerMode = UIDatePickerModeTime;
        
        if(_isEditing){
            self.datePicker.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
            self.datePicker.date = self.breastfeeding.startTime;
        }
        
        self.startTimeField.inputView = self.datePicker;
        self.endTimeField.inputView = self.datePicker;
        self.startTimeField.inputAccessoryView = self.accessoryView;
        self.endTimeField.inputAccessoryView = self.accessoryView;
    }

    self.endTimeField.delegate = self;
    self.startTimeField.delegate = self;
    
    startDate = [self combineDate:_date withTime:[NSDate date]];
    if (self.breastfeeding) {
        // init fields with data
        self.breastSideButtons.selectedIndex = self.breastfeeding.breastSide;
        startDate = self.breastfeeding.startTime;
        endDate = self.breastfeeding.endTime;
        minutes = self.breastfeeding.duration / 60;
        seconds = self.breastfeeding.duration % 60;
    }

    if (_isEditing)
    {
        [self.calendarView setBaseDate:self.breastfeeding.startTime];
    }
    else
    {
        [self.calendarView setBaseDate:self.date];
    }
    [self.calendarView setDelegate:self];
    
    [self updateTimeLabel];
    [self updateStartEndTextFields];
}


- (void)viewWillAppear:(BOOL)animated {

}

#pragma mark - Actions
- (IBAction)startStopPressed {
    if(!_running){
        [self startTimer];
    } else {
        [self stopTimer];
    }
}

- (IBAction)resetPressed {
    ///reset everything
    [self resetTimer];
    startDate = nil;
    endDate = nil;
    [self updateStartEndTextFields];
}

- (void)datePickerDonePressed {
    [currentTimeField resignFirstResponder];
    currentTimeField.text = [timeFormatter stringFromDate:self.datePicker.date];
    NSDate *pickedDate = [self combineDate:_date withTime:self.datePicker.date];
    
    if( [currentTimeField isEqual:self.startTimeField]) {
        startDate = pickedDate;
    } else if ([currentTimeField isEqual:self.endTimeField]) {
        endDate = pickedDate;
    }
    
    if (startDate && endDate) {
        if ([endDate compare:startDate] == NSOrderedAscending) {
            [[AlertView alertViewFromString:T(@"%breastfeeding.alert.endDateEarlier") buttonClicked:nil] show];
            return;
        }
        //when the user chooses the start and end time, we calculate the duration
        //and reset the timer if it is running
        [self resetTimer];
        //calculate
        NSDateComponents *durationComponents = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:startDate toDate:endDate options:0];
        NSInteger diff = durationComponents.second;
        
        float res = diff / 60.0f;
        
        if (res > 60)
        {
            [[AlertView alertViewFromString:T(@"%breastfeeding.alert.sessionLength") buttonClicked:nil] show];
            return;
        }
        minutes = diff / 60;
        seconds = diff % 60;
        [self updateTimeLabel];
    }
}

- (void)donePressed {
    
    [self stopTimer];
    
    [self.view endEditing:YES];
    
    if (!minutes && !seconds) {
        [[AlertView alertViewFromString:T(@"%breastfeeding.alert.nothingTracked") buttonClicked:nil] show];
        return;
    }
    
    if (!endDate) {
        endDate = [self combineDate:_date withTime:[NSDate date]];
        [self updateStartEndTextFields];
    }
    
    if (!self.breastfeeding) {
        self.breastfeeding = [Breastfeeding new];
    }
    
    //update the breastfeeding entry
    self.breastfeeding.breastSide = self.breastSideButtons.selectedIndex == 0 ? BreastsideLeft : BreastsiteRight;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: startDate];
    [components setSecond: 00];
    
    NSDate *newDate = [gregorian dateFromComponents: components];
    self.breastfeeding.startTime = newDate;
    
    components = [gregorian components: NSUIntegerMax fromDate: endDate];
    [components setSecond: minutes * 60 + seconds];
    newDate = [gregorian dateFromComponents: components];
    self.breastfeeding.endTime = endDate;
    self.breastfeeding.duration = minutes * 60 + seconds;
    self.breastfeeding.baby = self.baby;
    
    NSInteger interval = self.isEditing ? [[NSTimeZone systemTimeZone] secondsFromGMT] : 0;
    
    if ([self.breastfeeding.startTime timeIntervalSinceNow] - interval > 0 || [self.breastfeeding.endTime timeIntervalSinceNow] - interval > 0)
    {
        [[AlertView alertViewFromString:T(@"%general.alert.dateInFuture") buttonClicked:nil] show];
        return;
    }
    
    [WaitIndicator waitOnView:self.view];
    if(!self.isEditing){
        [self.breastfeeding save:^(BOOL success) {
            [self.view stopWaiting];
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBreastfeedingFinishedNotification" object:nil];
                [OverlaySaveView showOverlayWithMessage:T(@"%general.added") afterDelay:2 performBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
            }
        }];
    }else{
        [self.breastfeeding update:^(BOOL success) {
            [self.view stopWaiting];
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBreastfeedingFinishedNotification" object:nil];
                [OverlaySaveView showOverlayWithMessage:T(@"%general.modified") afterDelay:2 performBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
            }
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    currentTimeField = textField;
    if(_isEditing){
        if([self.endTimeField isEqual:currentTimeField]){
            self.datePicker.date = self.breastfeeding.endTime;
        }else{
            self.datePicker.date = self.breastfeeding.startTime;
        }
    }
}

// disallow editing with keyboard when datepicker opens
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.endTimeField isEqual:textField] || [self.startTimeField isEqual:textField]) {
        return NO;
    }
    return YES;    
}

#pragma mark - CalendarViewDelegate

- (void)calenderView:(CalendarView *)calenderView didSelectDate:(NSDate *)date {
    _date = date;
    
    if (self.parentView)
    {
        [self.parentView setDate: _date];
    }
    
    if (startDate)
    {
        startDate = [self combineDate:date withTime:startDate];
    }
    else
    {
        startDate = date;
    }
    
    if (endDate)
    {
        endDate = [self combineDate:date withTime:endDate];
    }
    else
    {
        //endDate = date;
    }
    
    [self updateStartEndTextFields];
}

#pragma mark - helpers

- (void)resetTimer {
    [stopTimer invalidate];
    stopTimer = nil;
    seconds = 0;
    minutes = 0;
    _running = FALSE;
    totalDegrees = 0;
    [self updateStartStopBtnState];
    [self rotateImage:self.progressImageView duration:0.5
                curve:UIViewAnimationCurveEaseIn degrees:totalDegrees];
    
    [self updateTimeLabel];
}

- (void)startTimer {
    _running = TRUE;
    if (!stopTimer) {
        stopTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/1.0
                                                     target:self
                                                   selector:@selector(updateTimer)
                                                   userInfo:nil
                                                    repeats:YES];
    }
    if (!startDate) {
        startDate = [NSDate date];
        [self updateStartEndTextFields];
    }
    if(endDate && !_isEditing) {  //if the user has set an endDate we have to clear it because it does not make any sence here
        endDate = nil;
        [self updateStartEndTextFields];
    }
    [self rotate];
    [self updateStartStopBtnState];
}

- (void)stopTimer {
    _running = FALSE;
    [stopTimer invalidate];
    endDate = [NSDate dateWithTimeIntervalSince1970:(startDate.timeIntervalSince1970 + minutes*60 + seconds)];
    [self.endTimeField setText:[timeFormatter stringFromDate:endDate]];
    //endDate = [NSDate date];
    stopTimer = nil;
    [self updateStartStopBtnState];
}

- (void)updateTimer {
    if(minutes == 60) {
        [self stopTimer];
    }
    if (seconds < 59) {
        seconds++;
    } else {
        minutes++;
        seconds = 0;
    }
    [self updateTimeLabel];
    [self rotate];
}

- (void)rotate {
    totalDegrees += 6;
    [self rotateImage:self.progressImageView duration:1 curve:UIViewAnimationCurveEaseIn degrees:totalDegrees];
}

- (void)updateTimeLabel {
    NSString *timeString = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    self.timeLabel.text = timeString;
}

- (void)updateStartEndTextFields {
    self.startTimeField.text = [timeFormatter stringFromDate:startDate];
    self.endTimeField.text =[timeFormatter stringFromDate:endDate];
}

- (void)updateStartStopBtnState {
    if (_running) {
        [self.startStopBtn setBackgroundImage:[UIImage imageNamed:@"pause"]  forState:UIControlStateNormal];
    } else {
        [self.startStopBtn setBackgroundImage:[UIImage imageNamed:@"start"]  forState:UIControlStateNormal];
    }
}

/// combine the date part with the given time part
- (NSDate *)combineDate:(NSDate *)date withTime:(NSDate *)time {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *timeComponents = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:time];
    NSDateComponents *result = [NSDateComponents new];
    [result setYear:dateComponents.year];
    [result setMonth:dateComponents.month];
    [result setDay:dateComponents.day];
    [result setHour:timeComponents.hour];
    [result setMinute:timeComponents.minute];
    [result setSecond:timeComponents.second];
    return [calendar dateFromComponents:result];
}

/// rotate the image view
- (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration
              curve:(int)curve degrees:(CGFloat)degrees {
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        CGAffineTransform transform =
        CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
        image.transform = transform;
    } completion:NULL];
}

-(NSString *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    return dateString;
}


@end
