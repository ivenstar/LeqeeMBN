//
//  BreastfeedingCell.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 29.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BreastfeedingCell.h"
#import "FlatProgressView.h"

static NSDateFormatter *dateFormatter = nil;

@interface BreastfeedingCell() 

@property (weak, nonatomic) IBOutlet UIImageView *sideImageView;
@property (weak, nonatomic) IBOutlet UILabel *sideLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet FlatProgressView *durationProgressView;
@end

@implementation BreastfeedingCell

- (void)setFeeding:(Breastfeeding *)feeding {
    _feeding = feeding;
    
    if (dateFormatter == nil) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormatter setDateFormat:@"HH'h'mm"];
    }
    
    
    self.sideLabel.text = feeding.breastSide == BreastsideLeft ? T(@"%breastfeeding.left") : T(@"%breastfeeding.right");
    self.sideImageView.image =     feeding.breastSide == BreastsideLeft ? [UIImage imageNamed:@"icon-drop_g"] : [UIImage imageNamed:@"icon-drop_d"];
    
    self.startTimeLabel.text = [dateFormatter stringFromDate:feeding.startTime];
    self.endTimeLabel.text = [dateFormatter stringFromDate:feeding.endTime];
    self.durationLabel.text = [NSString stringWithFormat:@"%dmin", feeding.duration / 60 ];
    
    //30 mit = 1800 sec = 100%
    self.durationProgressView.progress = feeding.duration / 18.0 / 100.0;
    self.durationProgressView.progressBarColor = feeding.breastSide == BreastsideLeft ? [UIColor colorWithRGBString:@"#4b4a63"]: [UIColor colorWithRGBString:@"#9793bb"];
}

@end
