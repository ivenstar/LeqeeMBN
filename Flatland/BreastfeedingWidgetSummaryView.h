//
//  BreastfeedingWidgetSummaryView.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 06.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Breastfeeding.h"
#import "Baby.h"
@interface BreastfeedingWidgetSummaryView : UIView

+ (BreastfeedingWidgetSummaryView*) summaryView;
@property (nonatomic, strong) Breastfeeding *firstFeeding;
@property (nonatomic, strong) Breastfeeding *secondFeeding;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

@property (weak, nonatomic) IBOutlet UIView *firstView;


//@property (weak, nonatomic) IBOutlet UIView *firstScreen;
//@property (weak, nonatomic) IBOutlet UIView *secondScreen;
//@property (weak, nonatomic) IBOutlet UIView *thirdScreen;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdScreenMessage;
@property (weak, nonatomic) IBOutlet UIButton *viewPreviousButton;
-(void)setUpThirdScreen;
-(void)setUpFirstScreen;
-(void)setUpSecondScreen;

@end
