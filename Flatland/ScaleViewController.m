//
//  ScaleViewController.m
//  Flatland
//
//  Created by Jochen Block on 26.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "ScaleViewController.h"
#import "ScaleDisk.h"
#import "FlatBigLabel.h"
#import "AlertView.h"
#import "OverlaySaveView.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "WaitIndicator.h"

@interface ScaleViewController ()
@property (strong, nonatomic) IBOutlet FlatBigLabel *valueLabel;
@property (strong, nonatomic) IBOutlet UIView *scaleView;
@property (weak, nonatomic) IBOutlet CalendarView *calendarView;
//@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation ScaleViewController {
    NSDate *calendarDate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = MakeImageBarButton(@"barbutton-done", self, @selector(donePressed));
//US scale
	float us = 1;
#ifdef BABY_NES_US
    us = 2.5;
#endif// BABY_NES_US
    
    ScaleDisk *scale = [[ScaleDisk alloc] initWithFrame:CGRectMake(0, 125, 707, 707)
                                            andDelegate:self
                                           withSections:200*us];
    
    scale.center = CGPointMake(160, self.view.bounds.size.height - 240);
    
    if(_weight){
        [scale moveScaleToWeight:_weight.weight];
    }
    
    [_scaleView addSubview:scale];
    
    UIImageView *needleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, self.view.bounds.size.height - 175, 315, 115)];
    needleImageView.contentMode = UIViewContentModeScaleAspectFit;
    needleImageView.image = [UIImage imageNamed:@"needle.png"];
    [self.view addSubview:needleImageView];
    
    [self.calendarView setDelegate:self];
    [self.calendarView setBaseDate:_date];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //_calendarView.didSelectDate = 3;//_didSelectedDate;
}

- (void) scaleDidChangeValue:(NSString *)newValue {
    
    _value = [newValue doubleValue]/1000;
    
#ifdef BABY_NES_US
    _valueLabel.text = [[NSString alloc] initWithFormat:@"%.3f lb", _value];
#else
    _valueLabel.text = [[NSString alloc] initWithFormat:@"%.3f kg", _value];
#endif// BABY_NES_US
    
    
}

- (void)donePressed {
    // Works only if time is set to 12 am!!! Do not change!
    [WaitIndicator waitOnView:self.view];
    NSDate *date =  self.date;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    [components setHour: 0];
    [components setMinute: 10];
    [components setSecond: 00];
    
    NSDate *newDate = [gregorian dateFromComponents: components];
    ////Ionel fix
    //NSDate *newDate = [NSDate date];
    //
    Weight *weight = [Weight new];
    weight = [Weight new];
    weight.weight = _value;    
    //weight.date = newDate;
    weight.date = self.date;
    weight.baby = _baby;
    weight.babyWeightId = _weight.babyWeightId;
    
    if(!_isEditing){
        
        if (weight.weight == 0) {
            [self.view stopWaiting];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:T(@"%weight.selectWeight") delegate:self cancelButtonTitle:T(@"%general.ok") otherButtonTitles:nil];
            [alert show];
        }
        else {
            
            [weight createWeight:^(BOOL success) {
                [self.view stopWaiting];
                if (success) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWeightFinishedNotification" object:nil];
                    [OverlaySaveView showOverlayWithMessage:T(@"%general.added") afterDelay:2 performBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                } else {
                    [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
            }
        }];
        }
    }else{
        [weight updateWeight:^(BOOL success) {
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWeightFinishedNotification" object:nil];
                [OverlaySaveView showOverlayWithMessage:T(@"%general.modified") afterDelay:2 performBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
            }
        }];
    }
}

#pragma mark - CalendarViewDelegate

- (void)calenderView:(CalendarView *)calenderView didSelectDate:(NSDate *)date {
    //calendarDate = [self combineDate:date withTime:nil];
    if (date!=self.date)
    {
        self.date = date;
        if (self.parentView)
        {
            [self.parentView setDate:self.date];
        }
    }
}

@end
