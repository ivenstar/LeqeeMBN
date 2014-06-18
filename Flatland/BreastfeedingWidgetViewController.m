//
//  BreastfeedingWidgetViewController.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 30.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BreastfeedingWidgetViewController.h"
#import "ListBreastfeedingViewController.h"
#import "EditBreastfeedingViewController.h"
#import "BreastfeedingWidgetSummaryView.h"
#import "BreastfeedingsDataService.h"
#import "BreastfeedingsCountGraphView.h"
#import "WidgetView.h"
#import "User.h"
#import "BreastfeedingGraphLandscapeVC.h"
#import "BreastFeedMonthlyGraph.h"
#import "BreastFeedYearlyGraph.h"
#import "LastDateService.h"


@interface BreastfeedingWidgetViewController () <SwipeViewDataSource, SwipeViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *dummy;
@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, copy) NSString *descriptionLabelText;
@property (nonatomic, copy) NSArray *feedings;
@property (weak, nonatomic) IBOutlet UIButton *editbutton;
@property (nonatomic, copy) NSArray *dailyFeedings;


@property (nonatomic, copy) NSArray *lastFeedings;

@property (nonatomic, copy) NSArray * dailyAllFeedings;
@property (nonatomic, copy) NSArray * monthlyFeedings;
@property (nonatomic, copy) NSArray * weeklyFeedings;


@property (weak, nonatomic) IBOutlet UIImageView *drop_L;
@property (weak, nonatomic) IBOutlet UIImageView *drop_R;
@property (nonatomic) int index;
@end

@implementation BreastfeedingWidgetViewController 
@synthesize baby = _baby;
@synthesize date = _date;

+(NSString *)widgetIdentifier {
    return @"BreastfeedingWidget";
}

- (void)setBaby:(Baby *)baby {
    _baby = baby;
    [self updateFeedingsDataFromServer];
}

- (void)setDate:(NSDate *)date {
    if (_date != date)
    {
        _date = date;
        [self updateFeedingsDataFromServer];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishedSetup)
                                                 name:@"BreastfeedingFinishedNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateWidget)
                                                 name:@"UpdateBreastfeedingFinishedNotification"
                                               object:nil];
    [self showLoadingOverlay];
    
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    //self.swipeView.truncateFinalPage = YES;
    
    if([[User activeUser].babies count] == 0)
    {
        self.pageControl.numberOfPages = 0;
        self.editbutton.hidden = YES;
    }else{
        self.pageControl.numberOfPages = 4;
        self.editbutton.hidden = NO;
    }
    [self.pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
    //[self.pageControl setUserInteractionEnabled:NO];
    [self updateFeedingsDataFromServer];
}

#pragma mark - SwipeViewDelegate

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    if(_index >= 0){
        //self.editbutton.hidden = NO;
        self.pageControl.currentPage = _index;
        if(_index == 0){
            //self.descriptionLabel.text = @"";
            self.editbutton.hidden = NO;
            self.zoomButton.hidden = YES;
        }else{
            self.editbutton.hidden = NO;
            self.zoomButton.hidden = NO;
            //self.descriptionLabel.text = self.descriptionLabelText;
        }
    }
}

#pragma mark - SwipeViewDataSource

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    if([[User activeUser].babies count] == 0){
        return 1;
    }else{
        return 4;
    }
}

- (BOOL)swipeView:(SwipeView *)swipeView shouldSelectItemAtIndex:(NSInteger)index {
    return TRUE;
}
- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"selected swipe: %d", index);
    [self zoomGraph:nil];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {    
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 40, 130, 21)];
    descriptionLabel.font = [UIFont systemFontOfSize:12];
    [descriptionLabel setTextAlignment:NSTextAlignmentLeft];
    
    UILabel *periodLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 20, 124, 21)];
    periodLabel.font = [UIFont systemFontOfSize:11];
    [periodLabel setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *periodDescription = [[UILabel alloc] initWithFrame:CGRectMake(20, 152, 280, 21)];
    periodDescription.font = [UIFont systemFontOfSize:11];
    [periodDescription setTextAlignment:NSTextAlignmentCenter];

    
    _index = index;
    
    //    NSLog(@"%d",index);
    
    if([[User activeUser].babies count] == 0){
        self.pageControl.numberOfPages = 0;
        self.editbutton.hidden = YES;
    }
    else
    {
        self.pageControl.numberOfPages = 4;
        self.editbutton.hidden = NO;
    }
    
    if(index == 0)
    {
        //self.periodLabel.text=@"";
        //self.periodDescription.text=@"";
        self.zoomButton.hidden = YES;
        self.drop_L.hidden=YES;
        self.drop_R.hidden=YES;
        
        BreastfeedingWidgetSummaryView *summaryView = [BreastfeedingWidgetSummaryView summaryView];
        //test
        //self.dailyFeedings=nil;
        
        //self.dailyFeedings = [NSArray array];
        if (FALSE)
        //if([self.dailyFeedings count] == 0 || self.dailyFeedings == nil)
        {
            NSDate * d=  [[LastDateService sharedInstance] feedings].lastBottleFeedDate;
            NSLog(@"%@",d);
            
            if ([self.lastFeedings count])
            {
                //test
                [summaryView setUpThirdScreen];
                //[summaryView.viewPreviousButton addTarget:self action:@selector(viewPreviousFeeds) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [summaryView setUpFirstScreen ];
            }
            
            //          test
            //            [summaryView setUpThirdScreen];
            ////            [summaryView setUpFirstScreen];
            //            [summaryView.viewPreviousButton addTarget:self action:@selector(viewPreviousFeeds) forControlEvents:UIControlEventTouchUpInside];
            
            //            UIColor *color = [UIColor colorWithRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha: 1];
            //            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 13, 180, 40)];
            //            timeLabel.textColor = color;
            //            timeLabel.textAlignment = NSTextAlignmentCenter;
            //            timeLabel.font = [UIFont fontWithName:@"Bariol-Regular" size:15.0];
            //            timeLabel.text = T(@"%bottlefeeding.noEntry");
            //            [summaryView addSubview:timeLabel];
            //
            //            UIButton * but =[[UIButton alloc]initWithFrame:CGRectMake(60, 73, 180, 40)];
            //            but.titleLabel.textColor = color;
            //            but.titleLabel.textAlignment = NSTextAlignmentCenter;
            //            but.titleLabel.font = [UIFont fontWithName:@"Bariol-Regular" size:15.0];
            //            but.titleLabel.text = T(@"%bottlefeeding.noEntry");
            //            [but addTarget:self action:@selector(viewPrevious) forControlEvents:UIControlEventTouchUpInside];
            //            [summaryView addSubview:but];
            //            return summaryView;
        }
        
        if ([self.lastFeedings count]!=0)
        {
            [summaryView setUpThirdScreen];
            
            if([self.lastFeedings count] == 1)
            {
                summaryView.firstFeeding = [self.lastFeedings objectAtIndex:0];
            }
            
            else if ([self.lastFeedings count] >= 2)
            {
                summaryView.firstFeeding = [self.lastFeedings objectAtIndex:0];
                summaryView.secondFeeding = [self.lastFeedings objectAtIndex:1];
            }
        }

//        else if ([self.dailyFeedings count]!=0)
//        {
//            [summaryView setUpThirdScreen];
//            
//            if([self.dailyFeedings count] >= 1)
//            {
//                summaryView.firstFeeding = [self.dailyFeedings objectAtIndex:[self.dailyFeedings count] - 1];
//            }
//            
//            if ([self.dailyFeedings count] >= 2)
//            {
//                summaryView.secondFeeding = [self.dailyFeedings objectAtIndex:[self.dailyFeedings count] - 2];
//            }
//        }
        
        
        else [summaryView setUpFirstScreen];
        if (self.baby == nil) {
            [summaryView setUpFirstScreen ];
        }
        
        return summaryView;
    }
    else
        if (index == 1)
        {
        self.drop_L.hidden=NO;
        self.drop_R.hidden=NO;
        
        periodLabel.text=T(@"%graph.bottleWeekly");
        periodDescription.text=T(@"%graph.breastWeeklyDescription");
        
        BreastfeedingsCountGraphView *v = [[BreastfeedingsCountGraphView alloc] initWithFrame:self.dummy.frame];
        
        NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
        NSDate *today = _date;
        
        NSMutableArray *fullMonthNames = [NSMutableArray arrayWithCapacity:2];
        NSMutableArray *labelDates = [NSMutableArray arrayWithCapacity:2];
        NSString *year = [[NSString alloc] init];
        
        NSDateFormatter *startDateFormatter = [[NSDateFormatter alloc] init];
        [startDateFormatter setDateFormat:@"dd"];
        
        [labelDates addObject:[startDateFormatter stringFromDate:[today dateByAddingTimeInterval:-6*24*60*60]]];
        [labelDates addObject:[startDateFormatter stringFromDate:today]];
        
        NSDateFormatter *startMonthFormatter = [[NSDateFormatter alloc] init];
        [startMonthFormatter setDateFormat:@"MMM"];
        NSString *month = [startMonthFormatter stringFromDate:[today dateByAddingTimeInterval:-6*24*60*60]];
        [fullMonthNames addObject:month];
        
        month = [startMonthFormatter stringFromDate:today];
        [fullMonthNames addObject:month];
        
        NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
        [yearFormatter setDateFormat:@"yy"];
        year = [yearFormatter stringFromDate:[NSDate new]];
        
        _descriptionLabelText = [[NSString alloc] initWithFormat:@"%@ %@ - %@ %@ %@",labelDates[0], fullMonthNames[0],labelDates[1], fullMonthNames[1],year ];
        
        v.breastfeedings = self.dailyAllFeedings; //self.feedings;
        v.startDate = self.date;
            UIView *v2 = [[UIView alloc] initWithFrame:self.swipeView.frame];
            [v2 addSubview:v];
            [v2 addSubview:periodLabel];
            [v2 addSubview:periodDescription];
            [v2 addSubview:descriptionLabel];
            [v createGraph];
            descriptionLabel.text = self.descriptionLabelText;

        return v2;
    }
    
    else if (index == 2)
    {
        self.drop_L.hidden=NO;
        self.drop_R.hidden=NO;
        
        periodLabel.text=T(@"%graph.bottleMonthly");
        periodDescription.text=T(@"%graph.bottleMonthlyDescription");
        
        BreastFeedMonthlyGraph *v = [[BreastFeedMonthlyGraph alloc] initWithFrame:self.dummy.frame];
        
        
        v.breastfeedings = self.weeklyFeedings;
        v.startDate = self.date;
        v.parentVC = self;
        UIView *v2 = [[UIView alloc] initWithFrame:self.swipeView.frame];
        [v2 addSubview:v];
        [v2 addSubview:periodLabel];
        [v2 addSubview:periodDescription];
        [v2 addSubview:descriptionLabel];
        [v createGraph];
        descriptionLabel.text = self.descriptionText;

        return v2;
    }
    else if (index == 3)
    {
        self.drop_L.hidden=NO;
        self.drop_R.hidden=NO;
        
        periodLabel.text=T(@"%graph.bottleYearly");
        periodDescription.text=T(@"%graph.bottleYearlyDescription");
        
        BreastFeedYearlyGraph *v = [[BreastFeedYearlyGraph alloc] initWithFrame:self.dummy.frame];
        
        v.breastfeedings = self.monthlyFeedings;
        v.startDate = self.date;
        v.parentVC = self;
        UIView *v2 = [[UIView alloc] initWithFrame:self.swipeView.frame];
        [v2 addSubview:v];
        [v2 addSubview:periodLabel];
        [v2 addSubview:periodDescription];
        [v2 addSubview:descriptionLabel];
        [v createGraph];
        descriptionLabel.text = self.descriptionText;
        return v2;
    }
    return nil;
}


#pragma mark - Actions
- (void)changePage {
    [self.swipeView setCurrentItemIndex:self.pageControl.currentPage];
}

- (IBAction)openList:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Breastfeeding" bundle:nil];
    ListBreastfeedingViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"BreastfeedingOverview"];
    vc.baby = self.baby;
    vc.date = _date;
    NSLog(@"epic date when open breast list: %@", vc.date);
    vc.parentView = self.parentView;
    [self.originNavigationController pushViewController:vc animated:YES];
}

- (IBAction)createNewEntry:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Breastfeeding" bundle:nil];
    EditBreastfeedingViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Breastfeeding"];
    vc.baby = self.baby;
    vc.date = _date;
    [self.originNavigationController pushViewController:vc animated:YES];
}

#pragma mark - Helpers

- (void)updateFeedingsDataFromServer {
    
    [self showLoadingOverlay];
    __block int serverCalls = 6;
    
    [self.swipeView scrollToPage:0 duration:0];
    
    [BreastfeedingsDataService loadBreastfeedingsForBaby:self.baby withStartDate:self.date timeSpanDays:7 completion:^(NSArray *breastfeedings) {
        serverCalls--;
        if (serverCalls == 0) {
            [self hideLoadingOverlay];
            [self.swipeView reloadData];
        }
        
        if (breastfeedings) {
            self.feedings = breastfeedings;
            [self.swipeView reloadData];
        }
    }];
    
    [BreastfeedingsDataService loadBreastfeedingsForBaby:self.baby withStartDate:self.date timeSpanDays:0 completion:^(NSArray *breastfeedings) {
        serverCalls--;
        if (serverCalls == 0)
        {
            [self hideLoadingOverlay];
            [self.swipeView reloadData];
        }
        
        if (breastfeedings) {
            self.dailyFeedings = breastfeedings;
            [self.swipeView reloadData];
        }
    }];
    
    [BreastfeedingsDataService loadBreastfeedingsDailyForBaby:self.baby withDate:self.date completion:^(NSArray * array) {
        serverCalls--;
        if (serverCalls == 0)
        {
            [self hideLoadingOverlay];
            [self.swipeView reloadData];
        }
        
        if (array)
        {
            self.dailyAllFeedings = array;
            [self.swipeView reloadData];
        }
    }];

    
    [BreastfeedingsDataService loadBreastfeedingsMonthlyForBaby:self.baby withDate:self.date completion:^(NSArray *array) {
        serverCalls--;
        if (serverCalls == 0)
        {
            [self hideLoadingOverlay];
            [self.swipeView reloadData];
        }
        
        if (array)
        {
            self.monthlyFeedings = array;
            [self.swipeView reloadData];
        }
    }];


    [BreastfeedingsDataService loadBreastfeedingsWeeklyForBaby:self.baby withDate:self.date completion:^(NSArray *array) {
        serverCalls--;
        if (serverCalls == 0)
        {
            [self hideLoadingOverlay];
            [self.swipeView reloadData];
        }
        
        if (array)
        {
            self.weeklyFeedings = array;
            [self.swipeView reloadData];
        }
    }];
    
    if (TRUE)
    {
        [BreastfeedingsDataService getLastBreastfeedingsWithBaby:self.baby date:self.date completion:^(NSArray * breastfeedings) {
            serverCalls--;
            if (serverCalls == 0)
            {
                [self hideLoadingOverlay];
                [self.swipeView reloadData];
            }
            
            if (breastfeedings)
            {
                self.lastFeedings = breastfeedings;
                [self.swipeView reloadData];
            }
        }];
        
    }
    
    
}

- (void)updateWidget
{
    [self updateFeedingsDataFromServer]; 
}

- (void)finishedSetup
{
   
}

- (IBAction)zoomGraph:(id)sender {
    BreastfeedingGraphLandscapeVC *vc = [[BreastfeedingGraphLandscapeVC alloc] initWithNibName:NSStringFromClass([BreastfeedingGraphLandscapeVC class]) bundle:nil];
    vc.originNavigationController = self.originNavigationController;
    //vc.babyWeights = self.weights;
    vc.date = self.date;
    vc.breastsDaily = self.dailyAllFeedings; //self.feedings;
    vc.breastsWeekly = self.weeklyFeedings;
    vc.breastsMonthly = self.monthlyFeedings;
    switch (self.pageControl.currentPage) {
        case 0:
        case 1:
            vc.selectedPeriod = 1;
            break;
        case 2:
            vc.selectedPeriod = 2;
            break;
        case 3:
            vc.selectedPeriod = 3;
            break;
        default:
            vc.selectedPeriod = 1;
            break;
    }

    //vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self.originNavigationController presentViewController:vc animated:YES completion:^(void){//NSLog(@"gataaaaaaaa");
        //animate graph - fade in
        //[vc presentGraph];
        
    }];

}
@end
