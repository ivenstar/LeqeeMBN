//
//  GraphSwipeLandscapeVC.h
//  Flatland
//
//  Created by Ionel Pascu on 10/15/13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"
#import "WeightGraphLandscapeVC.h"
#import "BreastfeedingGraphLandscapeVC.h" //to be replaced with BreastfeedingGraphLandscapeVC
#import "BottleGraphLandscapeVC.h"


@interface GraphSwipeLandscapeVC : UIViewController <SwipeViewDataSource, SwipeViewDelegate>
@property (strong, nonatomic) IBOutlet SwipeView *swipeView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) UINavigationController *originNavigationController;
@property (nonatomic, strong) WeightGraphLandscapeVC *graphVC;
@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, strong) NSArray *babyWeights;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) BabyWeightGraph *babyGraph;
@property (nonatomic, strong) BreastfeedingGraphLandscapeVC *graph2VC;
@property (nonatomic, strong) BreastfeedingsCountGraphView *breastGraph;
@property (nonatomic, strong) BottlefeedingDailyGraph *bottleGraph;

@end
