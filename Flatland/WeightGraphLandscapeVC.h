//
//  WeightGraphLandscapeVC.h
//  Flatland
//
//  Created by Ionel Pascu on 10/11/13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeightWidgetViewController.h"
#import "BabyWeightGraph.h"
#import "RoundButton.h"

@interface WeightGraphLandscapeVC : WeightWidgetViewController
{
    BabyWeightGraph *babyGraph;
    //SwipeView *swipeView;
}
@property (strong, nonatomic) IBOutlet UIImageView *header;
@property (nonatomic, strong) UINavigationController *originNavigationController;
@property (strong, nonatomic) IBOutlet SwipeView *swipeView;
@property (strong, nonatomic) IBOutlet SwipeView *swipe;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *periodButtons;
@property (strong, nonatomic) IBOutlet UIButton *but1;
@property (strong, nonatomic) IBOutlet UIButton *but2;
@property (strong, nonatomic) IBOutlet UIButton *but3;
@property (strong, nonatomic) IBOutlet UIButton *but4;
@property (nonatomic, strong) NSArray *babyWeights;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) BabyWeightGraph *babyGraph;
@property (nonatomic, copy) NSArray *growth3;
@property (nonatomic, copy) NSArray *growth6;
@property (nonatomic, copy) NSArray *growth12;
@property (nonatomic) int selectedPeriod;
//@property (strong, nonatomic) IBOutlet RoundButton *but1;
//@property (strong, nonatomic) IBOutlet RoundButton *but2;
//@property (strong, nonatomic) IBOutlet RoundButton *but3;
//@property (strong, nonatomic) IBOutlet RoundButton *but4;
- (IBAction)click:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)selectPeriod:(UIButton*)sender;
- (void)presentGraph;
@property (weak, nonatomic) IBOutlet UILabel *labelPeriodDescription;
@end
