//
//  GraphSwipeLandscapeVC.m
//  Flatland
//
//  Created by Ionel Pascu on 10/15/13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "GraphSwipeLandscapeVC.h"

@interface GraphSwipeLandscapeVC ()
@property (nonatomic) int index;
@end

@implementation GraphSwipeLandscapeVC
@synthesize graphVC;
@synthesize viewArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //viewArray = viewsArray;
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated{
    //animate first graph
    [self.babyGraph setAlpha:0.0];
    CGRect frame = self.babyGraph.frame;
    [self.babyGraph setFrame:CGRectMake(0, 300, 0, 0)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:v cache:NO];
    [self.babyGraph setAlpha:1.0];
    [self.babyGraph setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    //           [vc.view addSubview:v];
    //self.babyGraph.hidden = NO;
    [UIView commitAnimations];
    //[self.swipeView setScrollEnabled:NO];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //CGAffineTransform transform = CGAffineTransformMakeRotation((M_PI/2));
    //self.view.transform = transform;
    // Repositions and resizes the view.
    //0, 0,
    //x is height of iPhone screen
    //contentRect for pushedController
    //CGRect contentRect = CGRectMake(-5, -15, 280, 410);
    
    //contentRect for Modal
    //CGRect contentRect = CGRectMake(5, 35, 460, 260);
    
    //self.view.frame = contentRect;

    
    // Do any additional setup after loading the view from its nib.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    
    self.pageControl.numberOfPages = 3; //hardcoded for now, represents number of active graphs
    [self.pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
    
    [self.swipeView scrollToPage:1 duration:0];
    [self.swipeView scrollToPage:0 duration:0];
    [self.swipeView reloadData];
    
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SwipeViewDataSource

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    self.pageControl.currentPage = _index;
    if (_index == 0){
        //SwipeView *v = swipeView;
        //BabyWeightGraph *v = [viewArray objectAtIndex:0];
        [self.babyGraph setAlpha:0.0];
                    CGRect frame = self.babyGraph.frame;
                    [self.babyGraph setFrame:CGRectMake(0, 300, 0, 0)];
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:v cache:NO];
                    [self.babyGraph setAlpha:1.0];
                    [self.babyGraph setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        //           [vc.view addSubview:v];

                    [UIView commitAnimations];
        
    }
    else if (_index == 2){
    
        //SwipeView *v = swipeView;
        //BabyWeightGraph *v = [viewArray objectAtIndex:0];
        [self.bottleGraph setAlpha:0.0];
        CGRect frame = self.bottleGraph.frame;
        [self.bottleGraph setFrame:CGRectMake(0, 300, 0, 0)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:v cache:NO];
        [self.bottleGraph setAlpha:1.0];
        [self.bottleGraph setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        //           [vc.view addSubview:v];
        
        [UIView commitAnimations];
    }
    else if (_index == 1){
        //self.editbutton.hidden = YES;
        //self.addbutton.hidden = YES;
        //self.descriptionLabel.text = self.descriptionLabelText;
        [self.breastGraph setAlpha:0.0];
        CGRect frame = self.breastGraph.frame;
        [self.breastGraph setFrame:CGRectMake(0, 300, 0, 0)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1
         ];
        //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:v cache:NO];
        [self.breastGraph setAlpha:1.0];
        [[self breastGraph] setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        //           [vc.view addSubview:v];
        
        [UIView commitAnimations];
    }
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    //must be consistent with the active widgets - TO DO
        return 3; // the 3 graphs
    }


- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    _index = index;
    
//    if([[User activeUser].babies count] == 0){
//        self.pageControl.numberOfPages = 0;
//        self.editbutton.hidden = YES;
//    }else{
//        self.pageControl.numberOfPages = 2;
//        self.editbutton.hidden = NO;
//    }
//    
    switch (index) {
        case 0:
        {
            graphVC = [[WeightGraphLandscapeVC alloc] initWithNibName:NSStringFromClass([WeightGraphLandscapeVC class]) bundle:nil];
            //
            self.babyGraph = [[BabyWeightGraph alloc] initWithFrame:CGRectMake(5, 35, self.swipeView.frame.size.width-20, 225)];
            self.babyGraph.pinScale = 10;
            self.babyGraph.weights = [NSMutableArray arrayWithArray:self.babyWeights];
            self.babyGraph.startDate = self.date;
            self.babyGraph.parentViewControler = graphVC;
            //vc.descriptionLabel.text = self.descriptionLabelText;
            //[self.graphVC.descriptionLabel setFrame:CGRectMake(self.view.frame.size.width-(self.descriptionLabel.frame.size.width/2), self.descriptionLabel.frame.origin.y, self.descriptionLabel.frame.size.width, self.descriptionLabel.frame.size.height)];
            //[self.graphVC.descriptionLabel setCenter:self.swipeView.center];
            [self.babyGraph createGraph];
            [self.babyGraph setAlpha:0.0];
            [graphVC.view setFrame:self.swipeView.frame];
            [graphVC.view addSubview:self.babyGraph];
            return graphVC.view;
            break;
        }
        case 1:
        {
            ////
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
            
            
            NSString *descriptionLabelText = [[NSString alloc] initWithFormat:@"%@ %@ - %@ %@ %@",labelDates[0], fullMonthNames[0],labelDates[1], fullMonthNames[1],year ];
            
            //////
            BreastfeedingGraphLandscapeVC *vc = [[BreastfeedingGraphLandscapeVC alloc] initWithNibName:NSStringFromClass([BreastfeedingGraphLandscapeVC class]) bundle:nil];
            //
            self.breastGraph = [[BreastfeedingsCountGraphView alloc] initWithFrame:CGRectMake(5, 35, self.swipeView.frame.size.width-20, 225)];
            self.breastGraph.pinScale = 10;
            //v.breastfeedings = self.babyWeights;
            self.breastGraph.startDate = self.date;
            //v.parentViewControler = self;
            vc.descriptionLabelText = descriptionLabelText;
            
            [self.breastGraph createGraph];
            [vc.view setFrame:self.swipeView.frame];
            [vc.view addSubview:self.breastGraph];
            return vc.view;
            break;

        }
        case 2:
        {
            BottleGraphLandscapeVC *vc = [[BottleGraphLandscapeVC alloc] initWithNibName:NSStringFromClass([BottleGraphLandscapeVC class]) bundle:nil];
            
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
            
            
            NSString *descriptionLabelText = [[NSString alloc] initWithFormat:@"%@ %@ - %@ %@ %@",labelDates[0], fullMonthNames[0],labelDates[1], fullMonthNames[1],year ];
            //v.bottles = self.dailyFeedings;
            
            //
            self.bottleGraph = [[BottlefeedingDailyGraph alloc] initWithFrame:CGRectMake(5, 35, self.swipeView.frame.size.width -20, 225)];
            //self.babyGraph.pinScale = 10;
            //self.bottleGraph.weights = self.babyWeights;
            self.bottleGraph.startDate = self.date;
            //self.bottleGraph.parentViewControler = vc;
            vc.descriptionLabelText = descriptionLabelText;
            [self.bottleGraph createGraph];
            [vc.view setFrame:self.swipeView.frame];
            [vc.view addSubview:self.bottleGraph];
            return vc.view;
            break;

        }
        default:
            break;
    }
    
    return nil;
}

- (void)changePage {
    [self.swipeView setCurrentItemIndex:self.pageControl.currentPage];
}

#pragma mark Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == (UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationLandscapeLeft));
}
-(BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeRight;
//}

//orientation
- (void)deviceOrientationDidChange: (id) sender{
//    NSLog(@"---Orientation changed!!!!!");
//    if ([[UIDevice currentDevice] orientation] == (UIDeviceOrientationPortrait)){
//        NSLog(@"Landscape OFF");
//        //[self.originNavigationController popViewControllerAnimated:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
}

@end
