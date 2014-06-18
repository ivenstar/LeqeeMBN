//
//  BreastfeedingGraphLandscapeVC.h
//  Flatland
//
//  Created by Ionel Pascu on 10/16/13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BreastfeedingWidgetViewController.h"
#import "BreastfeedingsCountGraphView.h"
#import "BreastFeedMonthlyGraph.h"
#import "BreastFeedYearlyGraph.h"

@interface BreastfeedingGraphLandscapeVC : BreastfeedingWidgetViewController{
    BreastfeedingsCountGraphView *breastGraph;
}

@property (strong, nonatomic) IBOutlet UIImageView *header;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, copy) NSString *descriptionLabelText;
@property (strong, nonatomic) IBOutlet SwipeView *swipe;
@property (strong, nonatomic) IBOutlet UIButton *but1;
@property (strong, nonatomic) IBOutlet UIButton *but2;
@property (strong, nonatomic) IBOutlet UIButton *but3;
@property (strong, nonatomic) IBOutlet UIButton *but4;
@property (weak, nonatomic) IBOutlet UIImageView *leftDrop;
@property (weak, nonatomic) IBOutlet UIImageView *rightDrop;

@property (nonatomic, strong) BreastfeedingsCountGraphView *breastGraphDaily;
@property (nonatomic, strong) BreastFeedMonthlyGraph *breastGraphMonthly;
@property (nonatomic, strong) BreastFeedYearlyGraph *breastGraphYearly;

@property (nonatomic, copy) NSArray *breastsDaily;
@property (nonatomic, copy) NSArray *breastsWeekly;
@property (nonatomic, copy) NSArray *breastsMonthly;

@property (nonatomic) int selectedPeriod;


- (void)presentGraph;
- (IBAction)backAction:(id)sender;
- (IBAction)selectPeriod:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelPeriodDescription;

@end
