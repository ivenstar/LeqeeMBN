//
//  WeightWidgetViewController.m
//  Flatland
//
//  Created by Jochen Block on 02.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WeightWidgetViewController.h"
#import "ScaleViewController.h"
#import "WeightGraph.h"
#import "WeightDataService.h"
#import "BabyWeightGraph.h"
#import "WidgetView.h"
#import "User.h"
#import "WeightGraphLandscapeVC.h"
#import "GraphSwipeLandscapeVC.h"
#import "BabyWeightMonthlyGraph.h"
#import "BabyWeightYearlyGraph.h"
#import "WeightSummaryView.h"
#import "LastDateService.h"

@interface WeightWidgetViewController () <SwipeViewDataSource, SwipeViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *dummy;
@property (strong, nonatomic) IBOutlet SwipeView *swipeView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, copy) NSArray *weights;
@property (nonatomic, copy) NSArray *lastweights;
@property (nonatomic, copy) NSArray *growth3;
@property (nonatomic, copy) NSArray *growth6;
@property (nonatomic, copy) NSArray *growth12;



@property (weak, nonatomic) IBOutlet UIButton *editbutton;
@property (weak, nonatomic) IBOutlet UIButton *addbutton;
@property (strong, nonatomic) IBOutlet UIButton *zoomButton;
@property (nonatomic,strong) Weight *lastBabyWeight;
@property (nonatomic) int index;
@end

@implementation WeightWidgetViewController

@synthesize baby = _baby;
@synthesize date = _date;
@synthesize dateIndex = _dateIndex;
@synthesize loadDone;

+ (WeightWidgetViewController *)widgetWithBaby:(Baby *)baby
{
    WeightWidgetViewController *vc = [[WeightWidgetViewController alloc] initWithNibName:NSStringFromClass([WeightWidgetViewController class]) bundle:nil];
    vc.baby = baby;
    return vc;
}

+(NSString *)widgetIdentifier {
    return @"WeightWidget";
}

- (void)setBaby:(Baby *)baby {
    _baby = baby;
    [self updateWeightDataFromServer];
}

- (void)setDate:(NSDate *)date {
    if (_date!=date)
    {
        _date = date;
        [self updateWeightDataFromServer];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishedSetup)
                                                 name:@"WeightFinishedNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateWidget)
                                                 name:@"UpdateWeightFinishedNotification"
                                               object:nil];
    //orientation handler
    //[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    //[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    
    //[_periodDescription setHidden:YES];
    [self showLoadingOverlay];
    self.loadDone = FALSE;
    //self.descriptionLabel.text = @"";
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    if([[User activeUser].babies count] == 0){
        self.pageControl.numberOfPages = 0;
        self.addbutton.hidden = YES;
    }else{
        self.pageControl.numberOfPages = 4;
        self.addbutton.hidden = NO;
    }
    [self.pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
    [self updateWeightDataFromServer];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}


#pragma mark - SwipeViewDataSource

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
        self.pageControl.currentPage = _index;
        if(_index == 0)
        {
            self.editbutton.hidden = NO;
            self.addbutton.hidden = NO;
            self.zoomButton.hidden = YES;
            //self.descriptionLabel.text = @"";//T(@"%weight.lastEntry");
        }
        else
        {
            self.editbutton.hidden = NO;
            self.addbutton.hidden = YES;
            self.zoomButton.hidden = NO;
            //self.descriptionLabel.text = self.descriptionLabelText;
        }
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    if ([[User activeUser].babies count] == 0) {
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
    [periodDescription setBackgroundColor:[UIColor clearColor]];//fixes BNM-635. //TODO : Ionel,please remove the label,or increase swipe view h and move the label down if you intend to use it)


    _index = index;
    
    if([[User activeUser].babies count] == 0)
    {
        self.pageControl.numberOfPages = 0;
        self.editbutton.hidden = YES;
    }
    else
    {
        self.pageControl.numberOfPages = 4;
        self.editbutton.hidden = NO;
        //NSDate *d = [NSDate dateWithTimeIntervalSince1970:1388534400];
        NSDate *birthday = [User activeUser].favouriteBaby.birthday;
        int babyAgeInWeeks = WeeksBetween(birthday, self.date);
        //temp
        //babyAgeInWeeks = 24;
        //
        NSLog(@"Weeks of age between %@ and %@ ::: %d", self.date, birthday, babyAgeInWeeks);
        NSLog(@"Favorite baby:: %@", [User activeUser].favouriteBaby);
        
        int i3,i6,i12;
        //TODO Calculate weeeks for months according to formula
        
        i3 = babyAgeInWeeks - 12;
        i3 = i3 > 0 ? i3 : 0;
        
        i6 = babyAgeInWeeks - 24 - 1;
        i6 = i6 > 0 ? i6 : 0;
        
        i12 = babyAgeInWeeks - 48 - 3;
        i12 = i12 > 0 ? i12 : 0;
        
        _growth3 = PartialGrowthPathFromJSON([User activeUser].favouriteBaby.gender, i3, babyAgeInWeeks);
        _growth6 = PartialGrowthPathFromJSON([User activeUser].favouriteBaby.gender, i6, babyAgeInWeeks);
        _growth12 = PartialGrowthPathFromJSON([User activeUser].favouriteBaby.gender, i12, babyAgeInWeeks);
        
//        NSLog(@"fffffff:: %d", [[_growth3 objectAtIndex:0] count]);
//        NSMutableArray *grow3 = [_growth3 mutableCopy];
//        if (index > 0)
//        for (int k=0; k<[_growth3 count]; k++){
//            int gCount = index == 1 ? 90 : (index == 2 ? 180 : (index == 3 ? 360 : 0));
//            if ([[_growth3 objectAtIndex:k] count] < 90)
//            {
//                NSMutableArray *g3 = [[_growth3 objectAtIndex:k]mutableCopy];
//                for (int i=0; i<gCount - [[_growth3 objectAtIndex:k] count];i++) {
//                    [g3 addObject:[NSNumber numberWithDouble:0]];
//                }
//                for (int i=(gCount - [[_growth3 objectAtIndex:k] count]); i<gCount;i++) {
//                    [g3 addObject:[[_growth3 objectAtIndex:k] objectAtIndex:i]];
//                }
//                [g3 sortUsingSelector:@selector(compare:)];
//                [grow3 replaceObjectAtIndex:k withObject:g3];
//            }
//        }
//        _growth3 = [grow3 copy];
//        
//        NSLog(@"ggggggg:: %d", [[_growth3 objectAtIndex:0] count]);
        //////placehold growth old place
    }
    
    switch (index)
    {
        case 0:
        {
            self.zoomButton.hidden = YES;
            //self.periodLabel.text=@"";
            //self.periodDescription.text=@"";
            
            WeightSummaryView  *v = [WeightSummaryView summaryView];
            //test
            //[User activeUser].babies=[NSArray array];
            
            if([[User activeUser].babies count] == 0)
            {
                
                if ([[LastDateService sharedInstance] feedings].lastWeightDate) {
                    [v setUpSecondScreen];
                    [v.buttonSecondScreen addTarget:self action:@selector(viewPreviousFeeds) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    [v setUpFirstScreen];
                }
            }
            else
            {
                if([self.lastweights count])
                {
                    //send to the graph
                    NSLog(@"greutati: %@", self.lastweights);
                    
                    [v setUpThirdScreen:self.lastweights];
                    
                }
//                else
//                    if ([[LastDateService sharedInstance] feedings].lastWeightDate) {
//                        //[v setUpThirdScreen:self.lastweights];
//                    [v.buttonSecondScreen addTarget:self action:@selector(viewPreviousFeeds) forControlEvents:UIControlEventTouchUpInside];
//                }
                else
                {
                    [v setUpFirstScreen];
                }
            }
            
            if (self.baby == nil) {
                [v setUpFirstScreen ];
            }
            
            //[v setFrame:self.swipeView.frame];
            return v;
            break;
        }
        case 1:
        { 
            periodLabel.text=T(@"%graph.weight3Months");
            //periodDescription.text=T(@"%graph.bottleWeeklyDescription");
            
            BabyWeightGraph *v = [[BabyWeightGraph alloc] initWithFrame:self.dummy.frame];
            //WeightGraph *v = [[WeightGraph alloc] initWithFrame:self.swipeView.frame];
            v.pinScale = 0;
            v.weights = [self.weights copy];
            v.period = 90;
            v.growthPath = _growth3;
            v.startDate = self.date;
            v.parentViewControler = self;
            UIView *v2 = [[UIView alloc] initWithFrame:self.swipeView.frame];
            [v2 addSubview:v];
            [v2 addSubview:periodLabel];
            [v2 addSubview:periodDescription];
            [v2 addSubview:descriptionLabel];
            //[v createGraph];
            //descriptionLabel.text = self.descriptionLabelText;
            //if (v.weights)
            [v createGraph];
            return v2;
        }
            
        case 2:
        {
            periodLabel.text=T(@"%graph.weight6Months");
            //periodDescription.text=T(@"%graph.bottleMonthlyDescription");
            
            BabyWeightGraph *v = [[BabyWeightGraph alloc] initWithFrame:self.dummy.frame];
            //WeightGraph *v = [[WeightGraph alloc] initWithFrame:self.swipeView.frame];
            v.pinScale = 0;
            v.weights = [self.weights copy];
            v.period = 180;
            v.growthPath = _growth6;
            v.startDate = self.date;
            v.parentViewControler = self;
            UIView *v2 = [[UIView alloc] initWithFrame:self.swipeView.frame];
            [v2 addSubview:v];
            [v2 addSubview:periodLabel];
            [v2 addSubview:periodDescription];
            [v2 addSubview:descriptionLabel];
            //[v createGraph];
            //descriptionLabel.text = self.descriptionLabelText;
            //if (v.weights)
            [v createGraph];
            return v2;
        }
            
        case 3:
        {
            periodLabel.text=T(@"%graph.weight12Months");
            //periodDescription.text= T(@"%graph.bottleYearlyDescription");
            
            BabyWeightGraph *v = [[BabyWeightGraph alloc] initWithFrame:self.dummy.frame];
            //WeightGraph *v = [[WeightGraph alloc] initWithFrame:self.swipeView.frame];
            v.pinScale = 0;
            v.weights = [self.weights copy];
            v.period = 360;
            v.growthPath = _growth12;
            v.startDate = self.date;
            v.parentViewControler = self;
            UIView *v2 = [[UIView alloc] initWithFrame:self.swipeView.frame];
            [v2 addSubview:v];
            [v2 addSubview:periodLabel];
            [v2 addSubview:periodDescription];
            [v2 addSubview:descriptionLabel];
            //[v createGraph];
            //descriptionLabel.text = self.descriptionLabelText;
            //if (v.weights)
            [v createGraph];
            return v2;
        }
        default:
            break;
    }
    return nil;
}

#pragma mark - Actions
- (void)changePage {
    [self.swipeView setCurrentItemIndex:self.pageControl.currentPage];
}

- (IBAction)openAddWeight:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Weight" bundle:nil];
    ScaleViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Scale"];
    vc.baby = _baby;
    vc.date = _date;
    vc.didSelectedDate = _dateIndex;
    vc.parentView = self.parentView;
    [self.originNavigationController pushViewController:vc animated:YES];
}

- (IBAction)openEditWeight:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Weight" bundle:nil];
    ScaleViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Scale"];
    vc.baby = self.baby;
    vc.weight = _lastBabyWeight;
    vc.isEditing = YES;
    vc.date = _date;
    [self.originNavigationController pushViewController:vc animated:YES];
}

- (IBAction)zoomGraph:(id)sender {
    if ([self loadDone])
        if (TRUE){
            NSLog(@"Landscape ON");
            //self.loadDone = FALSE;
            //GraphSwipeLandscapeVC *vc = [[GraphSwipeLandscapeVC alloc] init];
            WeightGraphLandscapeVC *vc = [[WeightGraphLandscapeVC alloc] initWithNibName:NSStringFromClass([WeightGraphLandscapeVC class]) bundle:nil];
            vc.originNavigationController = self.originNavigationController;
            vc.babyWeights = self.weights;
            vc.date = self.date;
            vc.growth3 = _growth3;
            vc.growth6 = _growth6;
            vc.growth12 = _growth12;
            
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
            NSLog(@"swipe index: %d", self.pageControl.currentPage);
            //        UIViewController *yourViewController = [[UIViewController alloc]init];
            //
            //        [UIView  beginAnimations:@"ShowLandscape" context: nil];
            //        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            //        [UIView setAnimationDuration:0.75];
            //        [self.navigationController pushViewController: yourViewController animated:NO];
            //        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
            //        [UIView commitAnimations];
            
            
            //        CATransition* transition = [CATransition animation];
            //        transition.duration = 1;
            //        transition.type = kCATransitionFade;
            //        transition.subtype = kCATransitionFromTop;
            
            
            //[self.navigationController pushViewController:gridController animated:NO];
            
            //vc.baby = _baby;
            //vc.date = _date;
            //vc.didSelectedDate = _dateIndex;
            //[self.originNavigationController pushViewController:vc animated:YES];
//            BabyWeightGraph *v = [[BabyWeightGraph alloc] initWithFrame:CGRectMake(5, 44+20, vc.view.frame.size.width-20, 225-20)];
//            v.pinScale = 10;
//            v.weights = self.weights;
//            v.startDate = self.date;
//            v.parentViewControler = vc;
//            //vc.descriptionLabel.text = self.descriptionLabelText;
//            [v createGraph];
            
            //[vc.viewArray addObject:v];
            ///
            
            
            //[vc.view addSubview:v];
            
            
            
            //vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            //vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            //[self.originNavigationController.view.layer addAnimation:transition forKey:kCATransition];
            [self.originNavigationController presentViewController:vc animated:YES completion:^(void){//NSLog(@"gataaaaaaaa");
                //animate graph - fade in
                //[vc presentGraph];
//                [v setAlpha:0.0];
//                CGRect frame = v.frame;
//                [v setFrame:CGRectMake(0, 320, 0, 0)];
//                [UIView beginAnimations:nil context:nil];
//                [UIView setAnimationDuration:1];
//                //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:v cache:NO];
//                [v setAlpha:1.0];
//                [v setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
//                [vc.view addSubview:v];
//                [UIView commitAnimations];
            }];
            
            //[self.originNavigationController pushViewController:vc animated:YES];
        }

}

#pragma mark - Helpers

- (void) updateWeightDataFromServer {
    [self showLoadingOverlay];
    __block int serverCalls = 3;
    
    [self.swipeView scrollToPage:0 duration:0];
    
    [WeightDataService getLastWeightsWithBaby:self.baby date:
     //[[LastDateService sharedInstance] feedings].lastWeightDate
     self.date
        completion:^(NSArray * babyWeights) {
            NSLog(@"Sinri debug 0529 in server calls babyWeight at %p, serverCalls now is %i",babyWeights,serverCalls);
        serverCalls--;
        if (serverCalls == 0) {
            [self hideLoadingOverlay];
        }
        if (babyWeights) {
            self.lastweights = babyWeights;
            [self.swipeView reloadData];
            self.loadDone = TRUE;
            NSLog(@"Sinri debug 0529 in self operatrion");
        }else{
            NSLog(@"Sinri debug 0529 not in self operatrion");
        }
    }];
    
    
    [WeightDataService loadWeightsForBaby:self.baby withDate:self.date completion:^(NSArray *babyWeights) {
        serverCalls--;
        if (serverCalls == 0) {
            [self hideLoadingOverlay];
        }
        if (babyWeights) {
            self.weights = babyWeights;
            [self.swipeView reloadData];
            self.loadDone = TRUE;
        }
     }];
    
    [WeightDataService loadLastWeightForBaby:self.baby before:self.date completion:^(Weight *babyWeight) {
        serverCalls--;
        if (serverCalls == 0) {
            [self hideLoadingOverlay];
        }
        if (babyWeight) {
            self.lastBabyWeight = babyWeight;
            [self.swipeView reloadData];
        }
    }];

}

- (void)updateWidget {
    [self updateWeightDataFromServer];
}

- (void)finishedSetup {
    //[self hideLoadingOverlay];
}


#pragma mark - Orientation
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


- (BOOL)shouldAutorotate
{
    //NSLog(@"Orientation:%d", [[UIDevice currentDevice] orientation]);
    
    return YES;
}


//orientation
- (void)deviceOrientationDidChange: (id) sender{
    NSLog(@"@@@@Orientation changed!!!!!");
    if (FALSE)
    if ( ![[self.originNavigationController visibleViewController] isKindOfClass:[GraphSwipeLandscapeVC class]])
    if ([self loadDone] && ([self.weights count] != 0))
        if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)){
        NSLog(@"Landscape ON");
        //self.loadDone = FALSE;
        GraphSwipeLandscapeVC *vc = [[GraphSwipeLandscapeVC alloc] init];
        //WeightGraphLandscapeVC *vc = [[WeightGraphLandscapeVC alloc] initWithNibName:NSStringFromClass([WeightGraphLandscapeVC class]) bundle:nil];
        vc.originNavigationController = self.originNavigationController;
        vc.babyWeights = self.weights;
        vc.date = self.date;
        //        UIViewController *yourViewController = [[UIViewController alloc]init];
        //
        //        [UIView  beginAnimations:@"ShowLandscape" context: nil];
        //        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        //        [UIView setAnimationDuration:0.75];
        //        [self.navigationController pushViewController: yourViewController animated:NO];
        //        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
        //        [UIView commitAnimations];
        
        
//        CATransition* transition = [CATransition animation];
//        transition.duration = 1;
//        transition.type = kCATransitionFade;
//        transition.subtype = kCATransitionFromTop;
        
        
        //[self.navigationController pushViewController:gridController animated:NO];

            
        //vc.baby = _baby;
        //vc.date = _date;
        //vc.didSelectedDate = _dateIndex;
        //[self.originNavigationController pushViewController:vc animated:YES];
//        BabyWeightGraph *v = [[BabyWeightGraph alloc] initWithFrame:vc.view.frame];
//        v.pinScale = 10;
//        v.weights = self.weights;
//        v.startDate = self.date;
//        v.parentViewControler = self;
//        //vc.descriptionLabel.text = self.descriptionLabelText;
//        [v createGraph];
        
        //[vc.viewArray addObject:v];
        ///
        
        //[vc.view addSubview:v];
        
        //vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        //[self.originNavigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.originNavigationController presentViewController:vc animated:YES completion:^(void){//NSLog(@"gataaaaaaaa");
            //animate graph - fade in
            
//            [v setAlpha:0.0];
//            CGRect frame = v.frame;
//            [v setFrame:CGRectMake(0, 320, 0, 0)];
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:1];
//            //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:v cache:NO];
//            [v setAlpha:1.0];
//            [v setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
//            //[vc.view addSubview:v];
//            [UIView commitAnimations];
        }];
        //[self.originNavigationController pushViewController:vc animated:YES];
    }
}

@end
