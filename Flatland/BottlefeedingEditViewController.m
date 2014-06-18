//
//  BottlefeedingEditViewController.m
//  Flatland
//
//  Created by Jochen Block on 24.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BottlefeedingEditViewController.h"
#import "AlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "BottlefeedingScale.h"
#import "OverlaySaveView.h"
#import "Capsule.h"
#import "WaitIndicator.h"
#import "FlatSmallLabel.h"
#import "BottlefeedingViewController.h"
#import "BabyNesCapsulePicker.h"

@interface BottlefeedingEditViewController ()
{
    float percent; //[0..1]
    int bottleSize;
    
    int filledViewOriginalY;
    int filledViewOriginalHeight;

    BabyNesSlider *slider;
    NSString* m_capsuleType;
}

@property (strong, nonatomic) IBOutlet UITextField *hourTextInput;
@property (weak, nonatomic) IBOutlet FlatSmallLabel *hourLabel;
@property (weak, nonatomic) IBOutlet FlatSmallLabel *capsuleLabel;
@property (weak, nonatomic) IBOutlet UIButton *capsuleButton;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic) NSInteger counter;
@property (nonatomic) float lastEntry;
@property (nonatomic) BOOL isTimePickerVisible;
@property (strong, nonatomic) IBOutlet UIImageView *emptyImage;
@property (strong, nonatomic) IBOutlet UILabel *filledLabel;
@property (strong, nonatomic) IBOutlet UIView *filledView;
@property (strong, nonatomic) UIDatePicker *timePicker;

@property (weak, nonatomic) IBOutlet UIView *scaleContainerView;
@property (strong, nonatomic) IBOutlet BottlefeedingScale *scaleView;
@property (strong, nonatomic) IBOutlet UILabel *maxLabel;
@property (strong, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (nonatomic) BOOL isFirst;
@property (nonatomic) BOOL isFirstTouch;
@property (weak, nonatomic) IBOutlet UIView *topContainer;

@property (strong, nonatomic) UIToolbar *accessoryView;

@property (weak, nonatomic) IBOutlet UIButton *topArrowButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomArrowButton;

@property (weak, nonatomic) IBOutlet CalendarView *calendarView;

@property (weak, nonatomic) IBOutlet BabyNesCapsulePicker *capsulePicker;
- (void)donePressed;

@end

#define STEP_SIZE 0.25f//25%
#define BOTTLE_DEFAULT_VALUE 0.5f

@implementation BottlefeedingEditViewController

- (void)sliderValueChanged: (float) newValue;
{
    percent = newValue;
    [self updateBottleSize];
}

- (void) setupViewForCapsuleName: (NSString*) capsuleName
{
    //get the capsule
    Capsule *capsule = [Capsule capsuleForName:capsuleName];
    
    //set capsule image
    [self.capsuleButton setImage:[UIImage imageNamed:capsule.imageName] forState: UIControlStateNormal];

    //set volume labels
    float middle = bottleSize/2.0;
    if ((middle) == (int)(middle))
    {
        [_middleLabel setText:[NSString stringWithFormat: @"%i",(int)middle]];
    }
    else
    {
        [_middleLabel setText:[NSString stringWithFormat: @"%.1f",middle]];
    }
    
    [_maxLabel setText:[NSString stringWithFormat:@"%i",bottleSize]];
    [self updateBottleSize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Not nice but it works - no, it doesn't. changed.
    [self.view endEditing:NO];
    self.formScrollView.contentSize = CGSizeMake(320, 1012);
    
    self.navigationItem.rightBarButtonItem = MakeImageBarButton(@"barbutton-done", self, @selector(donePressed));
    
    [self.view setNeedsLayout];
    
    
    _scaleView.scaleMax = 200;
    
    filledViewOriginalY = -400;
    filledViewOriginalHeight = 0;
    
    [_filledView setHidden:NO];

    _hourTextInput.delegate = self;
    _isTimePickerVisible = NO;
    _isFirst = YES;
    _isFirstTouch = YES;
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [_dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    
    if (_timePicker == nil) {
        _timePicker = [UIDatePicker new];
        
        self.accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
        self.accessoryView.barStyle = UIBarStyleBlackTranslucent;
        self.accessoryView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(setDateAndClosePicker:)];
        UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.accessoryView.items = [NSArray arrayWithObjects:flexibleSpace, doneButton, nil];
        
        _timePicker.datePickerMode = UIDatePickerModeTime;
        
        _hourTextInput.inputView = _timePicker;
        _hourTextInput.inputAccessoryView = self.accessoryView;
        _hourTextInput.layer.cornerRadius = 5;
    }
    
    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH'h'mm"];
   
    if(!_isEditing){
        NSDate *currentTime = [NSDate new];
        _hourTextInput.text = [dateFormatter stringFromDate:currentTime];
    }else{
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        _hourTextInput.text = [dateFormatter stringFromDate:self.bottle.date];
        _timePicker.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        _timePicker.date = _bottle.date;
        _date = _bottle.date;
    }
    
    [self.calendarView setBaseDate:_date];
		
    m_capsuleType = _isEditing ? self.bottle.capsuleType : self.baby.capsuleType;
    
    [self.calendarView setDelegate:self];
    [self.capsulePicker setCapsulePickerDelegate:self];
    
#ifndef USE_BUTTONS_INSTEAD_OF_SLIDER
    [self.topArrowButton removeFromSuperview];
    [self.bottomArrowButton removeFromSuperview];
#endif //USE_BUTTONS_INSTEAD_OF_SLIDER
    
}

- (void)viewWillAppear:(BOOL)animated
{

    if ([[UIScreen mainScreen] bounds].size.height == 480)//if iphone 4
    {
        NSArray *viewsToShiftDown = [NSArray arrayWithObjects:self.emptyImage,self.scaleContainerView,self.filledView,nil];
        for (UIView *view in viewsToShiftDown)
        {
            view.center = CGPointMake(view.center.x, view.center.y + 20);
        }
        
        NSArray *viewsToTheLeft = [NSArray arrayWithObjects:self.hourLabel,self.hourTextInput,nil];
        for (UIView *view in viewsToTheLeft)
        {
            view.center = CGPointMake(view.center.x - 15 , view.center.y);
        }
        
        NSArray *viewsToTheRight = [NSArray arrayWithObjects:self.capsuleButton,self.capsuleLabel,nil];
        for (UIView *view in viewsToTheRight)
        {
            view.center = CGPointMake(view.center.x + 15, view.center.y);
        }
        
    }
    
    bottleSize = [Capsule sizeForCapsuleName:m_capsuleType];
    
    //calculate percent and update bottle size
    if (_isEditing)
    {
        if (bottleSize == 0) //just to be safe
        {
            percent = BOTTLE_DEFAULT_VALUE;
        }
        else
        {
            percent = [self.bottle.quantity floatValue]/bottleSize;
        }
    }
    else
    {
        percent = BOTTLE_DEFAULT_VALUE;
    }
    
    if (percent < STEP_SIZE)
    {
        percent = STEP_SIZE;
    }
    
    filledViewOriginalY = self.filledView.frame.origin.y;
    filledViewOriginalHeight = self.filledView.frame.size.height;
    
#ifndef USE_BUTTONS_INSTEAD_OF_SLIDER
    slider = [[BabyNesSlider alloc] initWithFrame:self.filledView.frame];
    [slider setDelegate:self];
    [slider setValue:percent];
    
    [self.view addSubview:slider];
    [self updateBottleSize];
#endif //USE_BUTTONS_INSTEAD_OF_SLIDER
    
    //get current capsule
    NSString* capsuleName = _isEditing ? [self.bottle.capsuleType lowercaseString] : [self.baby.capsuleType lowercaseString];
    [self setupViewForCapsuleName:capsuleName];
}


- (void)revealGesture {
    
}


#pragma Picker delegate

- (IBAction)setDateAndClosePicker:(id)sender {
    [_hourTextInput resignFirstResponder];
    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH'h'mm"];
    if(_isEditing){
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; 
    }
    NSDate *selectedTime = [_timePicker date];
    NSString *time = [dateFormatter stringFromDate:selectedTime];
    _hourTextInput.text = time;

}


- (void) updateBottleSize
{
    _filledView.frame = CGRectMake( _filledView.frame.origin.x,
                                    filledViewOriginalY + (filledViewOriginalHeight * (1 - percent)),
                                    _filledView.frame.size.width,
                                    filledViewOriginalHeight * percent);
    
    float bottleVal = percent * bottleSize;
    if(bottleVal == (int) bottleVal)
    {
        _filledLabel.text = [NSString stringWithFormat:@"%i", (int) bottleVal];
    }
    else
    {
        _filledLabel.text = [NSString stringWithFormat:@"%.1f", bottleVal];
    }
}

- (IBAction)plusButton:(id)sender
{
    percent += STEP_SIZE;
    if (percent > 1)
    {
        percent = 1;
    }
    
    [self updateBottleSize];
}

- (IBAction)minusButton:(id)sender
{
    percent -= STEP_SIZE;
    if (percent < STEP_SIZE)
    {
        percent = STEP_SIZE;
    }
    
    [self updateBottleSize];
}


- (IBAction)selectCapsule:(id)sender
{
    if ([self.capsulePicker isHidden])
    {
        [self.capsulePicker setHidden:NO];
    }
}


- (void)donePressed
{
    [self.view endEditing:YES];
    [WaitIndicator waitOnView:self.view];
    if(!_isEditing)
    {
        if (!self.bottle)
        {
            self.bottle = [[Bottle alloc] initWithBabyId:self.baby.ID withQuantity:@"0" atDate:[self combineDate:_date withTime:[_timePicker date]]];
            self.bottle.baby = _baby;
        }
    
        self.bottle.quantity = [NSString stringWithFormat:@"%f",percent];
        self.bottle.date = [self combineDate:_date withTime:_timePicker.date];
        self.bottle.capsuleType = m_capsuleType;
        
        if ([self.bottle.date timeIntervalSinceNow] > 0)
        {
            [self.view stopWaiting];
            [[AlertView alertViewFromString:T(@"%general.alert.dateInFuture") buttonClicked:nil] show];
            return;
        }
        
    
        //[WaitIndicator waitOnView:self.view];
        [self.bottle createBottle:^(BOOL success)
        {
            [self.view stopWaiting];
            if (success)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBottleFinishedNotification" object:nil];
                [OverlaySaveView showOverlayWithMessage:T(@"%general.added") afterDelay:2 performBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
            else
            {
                [[AlertView alertViewFromString:T(@"%bottlefeeding.error") buttonClicked:nil] show];
            }
        }];
    }
    else
    {
        self.bottle.baby = _baby;
        self.bottle.quantity = [NSString stringWithFormat:@"%f",(percent)];
        self.bottle.date = [self combineDate:_date withTime:_timePicker.date];
        self.bottle.capsuleType = m_capsuleType;
        
        NSTimeZone *systemTimeZone = [NSTimeZone systemTimeZone];
        NSInteger interval = [systemTimeZone secondsFromGMT];
        
        if ([self.bottle.date timeIntervalSinceNow] - interval> 0)
        {
            [self.view stopWaiting];
            [[AlertView alertViewFromString:T(@"%general.alert.dateInFuture") buttonClicked:nil] show];
            return;
        }
        
        //[WaitIndicator waitOnView:self.view];
        [self.bottle updateBottle:^(BOOL success) {
            [self.view stopWaiting];
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBottleFinishedNotification" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WidgetsHadChangedNotification" object:nil];
                [OverlaySaveView showOverlayWithMessage:T(@"%general.modified") afterDelay:2 performBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
            }
        }];
    }
}

/// combine the date part with the given time part
-(NSDate *)combineDate:(NSDate *)date withTime:(NSDate *)time
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *timeComponents = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:time];
    NSDateComponents *result = [NSDateComponents new];
    [result setYear:dateComponents.year];
    [result setMonth:dateComponents.month];
    [result setDay:dateComponents.day];
    [result setHour:timeComponents.hour];
    [result setMinute:timeComponents.minute];
    return [calendar dateFromComponents:result];
}

#pragma mark CalendarViewDelegate Methods

- (void)calenderView:(CalendarView *)calenderView didSelectDate:(NSDate *)date
{
    self.date = date;
    if (_parentView)
    {
        [_parentView setDate:date];
    }
}

- (void) picker:(BabyNesCapsulePicker*)picker didSelectCapsule: (Capsule*) selectedCapsule capsuleSize:(int) capsuleSize
{
    m_capsuleType = [Capsule capsuleIDforCapsule:selectedCapsule withSize:capsuleSize];
    bottleSize = [Capsule sizeForCapsuleName:m_capsuleType];
    [self setupViewForCapsuleName:m_capsuleType];
}


@end
