//
//  BottlefeedingWidgetViewController.m
//  Flatland
//
//  Created by Jochen Block on 02.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BottlefeedingWidgetViewController.h"
#import "BottlefeedingEditViewController.h"
#import "BottlefeedingViewController.h"
#import "BottlefeedingDataService.h"
#import "AlertView.h"
#import "BottlefeedingDailyGraph.h"
#import "BottlefeedingMonthlyGraph.h"
#import "BottleFeedingWeeklyGraph.h"
#import "CorePlot-CocoaTouch.h"
#import "WaitIndicator.h"
#import "WidgetView.h"
#import "Capsule.h"
#import "User.h"
#import "BottleGraphLandscapeVC.h"
#import "BottleFeedingSummaryView.h"
#import "LastDateService.h"
#import "LastDateFeedings.h"

@interface BottlefeedingWidgetViewController ()<SwipeViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *dummy;
@property (strong, nonatomic) IBOutlet SwipeView *swipeView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic) CPTGraphHostingView *hostView;
@property (nonatomic, copy) NSArray *todayFeedings;
@property (nonatomic, copy) NSArray *dailyFeedings;
@property (nonatomic, copy) NSArray *weeklyFeedings;
@property (nonatomic, copy) NSArray *monthlyFeedings;
//last
@property (nonatomic, copy) NSArray *lastFeedings;

@property (weak, nonatomic) IBOutlet UIButton *editbutton;
@property (nonatomic) int index;
@end

@implementation BottlefeedingWidgetViewController 
@synthesize baby = _baby;
@synthesize date = _date;


- (IBAction)zoomGraph:(id)sender {
    BottleGraphLandscapeVC *vc = [[BottleGraphLandscapeVC alloc] initWithNibName:NSStringFromClass([BottleGraphLandscapeVC class]) bundle:nil];
    vc.originNavigationController = self.originNavigationController;
    //vc.babyWeights = self.weights;
    vc.bottlesDaily = self.dailyFeedings;
    vc.bottlesWeekly = self.weeklyFeedings;
    vc.bottlesMonthly = self.monthlyFeedings;
    vc.date = self.date;
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

    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self.originNavigationController presentViewController:vc animated:YES completion:^(void){//NSLog(@"gataaaaaaaa");
    }];
    
    //[self.originNavigationController pushViewController:vc animated:YES];
}



+ (BottlefeedingWidgetViewController *)widgetWithBaby:(Baby *)baby
{
    BottlefeedingWidgetViewController *vc = [[BottlefeedingWidgetViewController alloc] initWithNibName:NSStringFromClass([BottlefeedingWidgetViewController class]) bundle:nil];
    vc.baby = baby;
    return vc;
}

+(NSString *)widgetIdentifier
{
    return @"BottlefeedingWidget";
}

- (void)setBaby:(Baby *)baby
{
    _baby = baby;
    [self updateDataFromServer];
}

- (void)setDate:(NSDate *)date {
    if (_date!=date)
    {
        _date = date;
        [self updateDataFromServer];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishedSetup)
                                                 name:@"BottlefeedingFinishedNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateWidget)
                                                 name:@"UpdateBottleFinishedNotification"
                                               object:nil];
    
    [self showLoadingOverlay];
    
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    if([[User activeUser].babies count] == 0){
        self.pageControl.numberOfPages = 0;
        self.editbutton.hidden = YES;
    }else{
        self.pageControl.numberOfPages = 4;
        self.editbutton.hidden = NO;
    }

    [self.pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];

    [self updateDataFromServer];
}

#pragma mark - SwipeViewDataSource

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    if(_index >= 0){
        //self.editbutton.hidden = NO;
        self.pageControl.currentPage = _index;
        if(_index == 0){
            //self.descriptionLabel.text = @"";
            self.zoomButton.hidden = YES;
            self.editbutton.hidden = NO;
        }else{
            self.editbutton.hidden = NO;
            //self.descriptionLabel.text = self.descriptionLabelText;
            self.zoomButton.hidden = NO;
        }
    }
}


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
    
    if([[User activeUser].babies count] == 0){
        self.pageControl.numberOfPages = 0;
        self.editbutton.hidden = YES;
    }
    else
    {
        self.pageControl.numberOfPages = 4;
        self.editbutton.hidden = NO;
    }
     
     switch(index)
    {
        case 0:
        {
            //self.periodLabel.text=@"";
            //self.periodDescription.text=@"";
            self.zoomButton.hidden = YES;
            
            BottleFeedingSummaryView *v = [BottleFeedingSummaryView summaryView];
            //test
//            self.todayFeedings=[NSArray array];
//            self.lastFeedings=[NSArray array];
            
            //if (FALSE)
//            if ([self.todayFeedings count] == 0)
//            {
//                
////                NSDate * d=  [[LastDateService sharedInstance] feedings].lastBottleFeedDate;
////                if (d)
////                {
////                    //test
////                    [v setUpThirdScreen];
////                    [v.viewPreviousButton addTarget:self action:@selector(viewPreviousFeeds) forControlEvents:UIControlEventTouchUpInside];
////                }
////                else
////                {
//                    [v setUpFirstScreen ];
////                }
//                
////                UIColor *color = [UIColor colorWithRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha: 1];
////                UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 33, 180, 40)];
////                timeLabel.textColor = color;
////                timeLabel.textAlignment = NSTextAlignmentCenter;
////                timeLabel.font = [UIFont fontWithName:@"Bariol-Regular" size:15.0];
////                timeLabel.text = T(@"%bottlefeeding.noEntry");
////                timeLabel.tag = 100;
////                [v addSubview:timeLabel];
////                UIButton * but =[[UIButton alloc]initWithFrame:CGRectMake(60, 73, 180, 40)];
////                but.titleLabel.textColor = color;
////                but.titleLabel.textAlignment = NSTextAlignmentCenter;
////                but.titleLabel.font = [UIFont fontWithName:@"Bariol-Regular" size:15.0];
////                but.titleLabel.text = T(@"%bottlefeeding.noEntry");
////                [but addTarget:self action:@selector(viewPrevious) forControlEvents:UIControlEventTouchUpInside];
////                [v addSubview:but];
//                
//                return v;
//            }
//            else
//            {
//                [v setUpSecondScreen];
//            }
            
            NSLog(@"%d",self.todayFeedings.count );
//            NSLog(@"%@",[self.todayFeedings objectAtIndex:0] );
            
            if ([self.todayFeedings count])
            {
                [v setUpSecondScreen];
                v=[self loadFeedings:self.todayFeedings withView:v];
            }
            
            else if ([self.lastFeedings count])
            {
                [v setUpSecondScreen];
                v=[self loadFeedings:self.lastFeedings withView:v];
            }
            else [v setUpFirstScreen];
            
            //[v setFrame:self.swipeView.frame];
            //set first screen if no babies
            if (self.baby == nil) {
                [v setUpFirstScreen ];
            }
            
            
            return v;
        }
             
        case 1:
        {

            
            periodLabel.text=T(@"%graph.bottleWeekly");
            periodDescription.text=T(@"%graph.bottleWeeklyDescription");

            
            BottlefeedingDailyGraph *v = [[BottlefeedingDailyGraph alloc] initWithFrame:self.dummy.frame];
            
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
            v.bottles = self.dailyFeedings;
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
            
        case 2:
         {

             periodLabel.text=T(@"%graph.bottleMonthly");
             periodDescription.text=T(@"%graph.bottleMonthlyDescription");


            BottleFeedingWeeklyGraph *v = [[BottleFeedingWeeklyGraph alloc] initWithFrame:self.dummy.frame];
            v.bottles = self.weeklyFeedings;
            v.startDate = self.date;
            v.parentViewControler = self;
             UIView *v2 = [[UIView alloc] initWithFrame:self.swipeView.frame];
             [v2 addSubview:v];
             [v2 addSubview:periodLabel];
             [v2 addSubview:periodDescription];
             [v2 addSubview:descriptionLabel];
             [v createGraph];
            descriptionLabel.text = self.descriptionLabelText;
            
            return v2;
        }
        case 3:{
            
            periodLabel.text=T(@"%graph.bottleYearly");
            periodDescription.text=T(@"%graph.bottleYearlyDescription");

            BottlefeedingMonthlyGraph *v = [[BottlefeedingMonthlyGraph alloc] initWithFrame:self.dummy.frame];
            v.bottles = self.monthlyFeedings;
            v.startDate = self.date;
            v.parentViewControler = self;
            UIView *v2 = [[UIView alloc] initWithFrame:self.swipeView.frame];
            [v2 addSubview:v];
            [v2 addSubview:periodLabel];
            [v2 addSubview:periodDescription];
            [v2 addSubview:descriptionLabel];
            [v createGraph];
            descriptionLabel.text = self.descriptionLabelText;
            return v2;
        }
    }
    return nil;
}

-(void)viewPrevious
{
    
}

-(BottleFeedingSummaryView *)loadFeedings:(NSArray *)feedings withView:(BottleFeedingSummaryView *)v
{
    int offset = 10;
    
    Bottle *bottle=[feedings objectAtIndex:0];
    
    NSDateFormatter  *dateFormatter2 = [[NSDateFormatter alloc]init];
    
    [dateFormatter2 setDateFormat:T(@"%general.dateFormat2")];
    
    NSString *date1 = [[NSString alloc] initWithFormat:@"%@", [dateFormatter2 stringFromDate:bottle.date]];
   
//    UIColor *color = [UIColor colorWithRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha: 1];

    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 15)];
//    textLabel.textColor = color;
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.font = [UIFont systemFontOfSize:12.0];
    textLabel.text = [[NSString alloc] initWithFormat:T(@"%bottlefeeding.feedings"), date1];
    [v.secondScreen addSubview:textLabel];
    
    for (Bottle *bottle in feedings) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offset + 12 , 20 , 25 , 60)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;

        NSString *imageName = [bottle bottleImageName];
        imageView.image = [UIImage imageNamed:imageName];
        
        [v.secondScreen addSubview:imageView];
        
        UIColor *color = [UIColor colorWithRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha: 1];
        NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormatter setDateFormat:@"HH'h'mm"];
        NSString *time = [dateFormatter stringFromDate:bottle.date];
        
        UILabel *volumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 85, 50, 20)];
        volumeLabel.textColor = color;
        volumeLabel.textAlignment = NSTextAlignmentCenter;
        volumeLabel.font = [UIFont fontWithName:@"Bariol-Regular" size:10.0];
        volumeLabel.text = [[NSString alloc] initWithFormat:@"%@ %@",bottle.quantity, T(@"%bottlefeeding.ml")];
        [v.secondScreen addSubview:volumeLabel];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 95, 50, 20)];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:9];
        timeLabel.text = [[NSString alloc] initWithFormat:@"%@", time];
        [v.secondScreen addSubview:timeLabel];
        
        
        
        
        NSDateFormatter  *dateFormatter2 = [[NSDateFormatter alloc]init];

        [dateFormatter2 setDateFormat:T(@"%general.dateFormat2")];
        
        NSString *date = [[NSString alloc] initWithFormat:@"%@", [dateFormatter2 stringFromDate:bottle.date]];
        
         UILabel *timeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(offset, 105, 50, 20)];
         timeLabel2.textAlignment = NSTextAlignmentCenter;
         timeLabel2.font = [UIFont systemFontOfSize:9];
         timeLabel2.text = [[NSString alloc] initWithFormat:@"%@", date];
         [v.secondScreen addSubview:timeLabel2];
        
        
        [volumeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel2 setBackgroundColor:[UIColor clearColor]];
        
        offset += 60;
    }
    return v;
}


#pragma mark - Actions
- (void)changePage {
    [self.swipeView setCurrentItemIndex:self.pageControl.currentPage];
}

- (IBAction)openAddBottle:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Bottlefeeding" bundle:nil];
    BottlefeedingEditViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"BottleFeedingAdd"];
    vc.baby = self.baby;
    vc.date = _date;
    [self.originNavigationController pushViewController:vc animated:YES];
}

- (IBAction)openBottleOverview:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Bottlefeeding" bundle:nil];
    BottlefeedingViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"BottleFeedingOverview"];
    vc.baby = self.baby;
    vc.date = _date;
    vc.parentView = self.parentView;
    [self.originNavigationController pushViewController:vc animated:YES];
}

#pragma mark - Helpers

- (void) updateDataFromServer {
    [self showLoadingOverlay];
    __block int serverCalls = 5;
    
    [self.swipeView scrollToPage:0 duration:0];
    
    [BottlefeedingDataService loadBottlefeedingsDailyForBaby:self.baby withDate:self.date completion:^(NSArray *bottles) {
        serverCalls--;
        if (serverCalls == 0) {
            [self hideLoadingOverlay];
            [self.swipeView reloadData];
        }
        
        if (bottles) {
            self.dailyFeedings = bottles;
            [self.swipeView reloadData];
            [self.swipeView reloadInputViews];
        }
    }];
    
    [BottlefeedingDataService loadBottlefeedingsWeeklyForBaby:self.baby withDate:self.date completion:^(NSArray *bottles) {
        serverCalls--;
        if (serverCalls == 0)
        {
            [self hideLoadingOverlay];
            [self.swipeView reloadData];
        }
        
        if (bottles) {
            self.weeklyFeedings = bottles;
            [self.swipeView reloadData];
            [self.swipeView reloadInputViews];
        }
    }];
    
    
    [BottlefeedingDataService loadBottlefeedingsMonthlyForBaby:self.baby withDate:self.date completion:^(NSArray *bottles) {
        serverCalls--;
        if (serverCalls == 0)
        {
            [self hideLoadingOverlay];
            [self.swipeView reloadData];
        }
        
        if (bottles)
        {
            self.monthlyFeedings = bottles;
            [self.swipeView reloadData];
            [self.swipeView reloadInputViews];
        }
    }];
    
    [BottlefeedingDataService loadBottlefeedingsForBaby:self.baby withDate:self.date completion:^(NSArray *bottles) {
        
        serverCalls--;
        if (serverCalls == 0)
        {
            [self hideLoadingOverlay];
            [self.swipeView reloadData];
        }
        
        if (bottles)
        {
            NSLog(@"BOTTLES ::%d",bottles.count);
            self.todayFeedings = bottles;
            [self.swipeView reloadData];
            [self.swipeView reloadInputViews];
        }
    }];
    
    
    [BottlefeedingDataService getLastBottlefeedingsWithBaby:self.baby date:self.date completion:^(NSArray *bottles) {
       
        serverCalls--;
        
        if (serverCalls == 0)
        {
            [self hideLoadingOverlay];
            [self.swipeView reloadData];
        }
        
        if (bottles)
        {
            self.lastFeedings = bottles;
            [self.swipeView reloadData];
            [self.swipeView reloadInputViews];
        }
    }];
    
}

- (void)updateWidget {
    [self updateDataFromServer];
}

- (void)finishedSetup {
    [_swipeView reloadData];
}

@end
