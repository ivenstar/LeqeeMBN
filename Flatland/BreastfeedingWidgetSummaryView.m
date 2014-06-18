//
//  BreastfeedingWidgetSummaryView.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 06.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BreastfeedingWidgetSummaryView.h"
#import "FlatProgressView.h"

static NSDateFormatter *dateFormatter = nil;
static NSDateFormatter *dateFormatterDay = nil;

@interface BreastfeedingWidgetSummaryView()

@property (weak, nonatomic) IBOutlet UIImageView *firstSideImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondSideImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstStartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondStartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondDayLabel;
@property (weak, nonatomic) IBOutlet FlatProgressView *firstProgressView;
@property (weak, nonatomic) IBOutlet FlatProgressView *secondProgressView;
@property (weak, nonatomic) IBOutlet UIView *firstEntryView;
@property (weak, nonatomic) IBOutlet UIView *secondEntryView;

@end

@implementation BreastfeedingWidgetSummaryView

+ (BreastfeedingWidgetSummaryView*) summaryView
{
    if (dateFormatter == nil)
    {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormatter setDateFormat:@"HH'h'mm"];
    }
    if (dateFormatterDay == nil)
    {
        dateFormatterDay = [NSDateFormatter new];
        [dateFormatterDay setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormatterDay setDateFormat:T(@"%general.dateFormat2")];
    }
    BreastfeedingWidgetSummaryView *view = [[[UINib nibWithNibName:@"BreastfeedingWidgetSummaryView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [view.firstEntryView setHidden:YES];
    [view.secondEntryView setHidden:YES];
    
    return view;
}


-(void)setUpFirstScreen
{
    self.thirdView.hidden=YES;
    self.secondView.hidden=YES;
    self.firstView.hidden=NO;
    self.messageLabel.text=T(@"%defaultscreen.breast1");
    self.secondMessageLabel.text=T(@"%defaultscreen.breast2");
    self.secondMessageLabel.font=[UIFont systemFontOfSize:9];
}

-(void)setUpThirdScreen
{
    self.firstView.hidden=YES;
    self.secondView.hidden=YES;
    self.thirdView.hidden=NO;
    
    self.thirdScreenMessage.text=T(@"%defaultscreen.breast3");
    self.viewPreviousButton.titleLabel.text=T(@"%default.buttonPrevious");
    [self.viewPreviousButton setTitle:T(@"%default.buttonPrevious") forState:UIControlStateNormal];

}

-(void)setUpSecondScreen
{
    self.firstView.hidden=YES;
    self.thirdView.hidden=YES;
    self.secondView.hidden=NO;
}

-(void)setFirstFeeding:(Breastfeeding *)firstFeeding
{
    _firstFeeding = firstFeeding;
    [self.firstEntryView setHidden:NO];
    [self setupFirstEntry:firstFeeding];
}

-(void)setSecondFeeding:(Breastfeeding *)secondFeeding
{
    _secondFeeding = secondFeeding;
    [self.secondEntryView setHidden:NO];
    [self setupSecondEntry:secondFeeding];
}

- (void)setupFirstEntry:(Breastfeeding*) firstFeeding
{
    //first entry
    self.firstSideImageView.image = firstFeeding.breastSide == BreastsideLeft ? [UIImage imageNamed:@"icon-drop_g"] : [UIImage imageNamed:@"icon-drop_d"];
    
    self.firstStartTimeLabel.text = [dateFormatter stringFromDate:firstFeeding.startTime];
    self.firstEndTimeLabel.text = [dateFormatter stringFromDate:firstFeeding.endTime];
    self.firstDurationLabel.text = [NSString stringWithFormat:@"%dmin", firstFeeding.duration / 60 ];
    self.firstDayLabel.text = [dateFormatterDay stringFromDate:firstFeeding.startTime];
    //30 mit = 1800 sec = 100%
    self.firstProgressView.progress = firstFeeding.duration / 18.0 / 100.0;
    self.firstProgressView.progressBarColor = firstFeeding.breastSide == BreastsideLeft ? [UIColor colorWithRGBString:@"#4b4a63"]: [UIColor colorWithRGBString:@"#9793bb"];
    
}

- (void)setupSecondEntry:(Breastfeeding*) secondFeeding
{
    //second entry
    self.secondSideImageView.image = secondFeeding.breastSide == BreastsideLeft ? [UIImage imageNamed:@"icon-drop_g"] : [UIImage imageNamed:@"icon-drop_d"];
    
    self.secondStartTimeLabel.text = [dateFormatter stringFromDate:secondFeeding.startTime];
    self.secondEndTimeLabel.text = [dateFormatter stringFromDate:secondFeeding.endTime];
    self.secondDurationLabel.text = [NSString stringWithFormat:@"%dmin", secondFeeding.duration / 60 ];
    self.secondDayLabel.text = [dateFormatterDay stringFromDate:secondFeeding.startTime];
    //30 mit = 1800 sec = 100%
    self.secondProgressView.progress = secondFeeding.duration / 18.0 / 100.0;
    self.secondProgressView.progressBarColor = secondFeeding.breastSide == BreastsideLeft ? [UIColor colorWithRGBString:@"#4b4a63"]: [UIColor colorWithRGBString:@"#9793bb"];
}

@end
