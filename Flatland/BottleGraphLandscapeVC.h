//
//  BottleGraphLandscapeVC.h
//  Flatland
//
//  Created by Ionel Pascu on 10/16/13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BottlefeedingWidgetViewController.h"
#import "BottlefeedingDailyGraph.h"
#import "BottlefeedingWeeklyGraph.h"
#import "BottleFeedingMonthlyGraph.h"

@interface BottleGraphLandscapeVC : BottlefeedingWidgetViewController{
    BottlefeedingDailyGraph *bottleGraph;
}
@property (strong, nonatomic) IBOutlet UIImageView *header;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, copy) NSString *descriptionLabelText;
@property (nonatomic, strong) BottlefeedingDailyGraph *bottleGraphDaily;
@property (nonatomic, strong) BottleFeedingWeeklyGraph *bottleGraphWeekly;
@property (nonatomic, strong) BottlefeedingMonthlyGraph *bottleGraphMonthly;
@property (strong, nonatomic) IBOutlet SwipeView *swipe;
@property (strong, nonatomic) IBOutlet UIButton *but1;
@property (strong, nonatomic) IBOutlet UIButton *but2;
@property (strong, nonatomic) IBOutlet UIButton *but3;
@property (strong, nonatomic) IBOutlet UIButton *but4;
@property (nonatomic, copy) NSArray *bottlesDaily;
@property (nonatomic, copy) NSArray *bottlesWeekly;
@property (nonatomic, copy) NSArray *bottlesMonthly;
@property (nonatomic) int selectedPeriod;
- (void)presentGraph;
- (IBAction)backAction:(id)sender;
- (IBAction)selectPeriod:(UIButton *)sender;
- (IBAction)share:(id)sender;


@end
