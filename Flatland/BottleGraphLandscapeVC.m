//
//  BottleGraphLandscapeVC.m
//  Flatland
//
//  Created by Ionel Pascu on 10/16/13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BottleGraphLandscapeVC.h"
#import "User.h"
#import "WaitIndicator.h"
//#import <Social/Social.h>
//#import "ShareVC.h"

@interface BottleGraphLandscapeVC ()

@end

@implementation BottleGraphLandscapeVC
NSArray *periods;
UIView *screenshot;
@synthesize but1, but2, but3, but4;
@synthesize bottleGraphDaily, bottleGraphWeekly, bottleGraphMonthly;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.periodLabelDescription.text=T(@"%graph.bottleWeeklyDescription");

    self.header.layer.shadowOpacity = 0.75f;
    self.header.layer.shadowRadius = 10.0f;;
    self.header.layer.shadowColor = [UIColor blackColor].CGColor;

//    self.title2 = [[UILabel alloc] initWithFrame:self.titleText.frame];
//    self.title2.text = self.titleText.text;
//    self.title2.font = self.titleText.font;
//    self.tit
//    self.header2 = [self.header copy];
    // Do any additional setup after loading the view from its nib.
    //self.descriptionLabel.text = self.descriptionLabelText;
    // Rotates the view.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    
//    [but1 setTitle:T(@"%graph.bottleWeekly") forState:UIControlStateNormal];
//    [but2 setTitle:T(@"%graph.bottleMonthly") forState:UIControlStateNormal];
//    [but3 setTitle:T(@"%graph.bottleYearly") forState:UIControlStateNormal];
    periods = [NSArray arrayWithObjects:but1, but2, but3, nil];
    for (int i=0; i< [periods count]; i++){
        UIButton *aux = (UIButton*)[periods objectAtIndex:i];
        aux.tag = i+1;
        
        aux.autoresizingMask = UIViewAutoresizingNone;
        [aux.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [aux setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    for (UIButton *but in periods)
        if (but.selected)
            [self selectPeriod:but];
    if ((!but1.selected) && (!but2.selected) && (!but3.selected) )
        [but1 setSelected:TRUE];
    
//    if (_selectedPeriod)
//        for (UIButton *but in periods)
//            if (but.tag == _selectedPeriod)
//                [self selectPeriod:but];
}

- (void)viewDidAppear:(BOOL)animated{
    //BottleGraphLandscapeVC *vc = [[BottleGraphLandscapeVC alloc] initWithNibName:NSStringFromClass([BottleGraphLandscapeVC class]) bundle:nil];
    //[self presentGraph];
//    for (UIButton *but in periods)
//        if (but.selected)
//    [self selectPeriod:but];

    if (_selectedPeriod)
        for (UIButton *but in periods)
            if (but.tag == _selectedPeriod)
                [self selectPeriod:but];
    //[self.descriptionLabel setAlpha:0.0];
}

- (void)presentGraph{

    [bottleGraphDaily setAlpha:0.0];
    [self.descriptionLabel setAlpha:0.0];
    CGRect frame = bottleGraphDaily.frame;
    [bottleGraphDaily setFrame:CGRectMake(0, 320, 0, 0)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:v cache:NO];
    [bottleGraphDaily setAlpha:1.0];
    [self.descriptionLabel setAlpha:1.0];
    [bottleGraphDaily setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    [UIView commitAnimations];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (!IS_IOS7)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.view setNeedsUpdateConstraints];
    [but1 setTitle:T(@"%graph.bottleWeekly") forState:UIControlStateNormal];
    [but2 setTitle:T(@"%graph.bottleMonthly") forState:UIControlStateNormal];
    [but3 setTitle:T(@"%graph.bottleYearly") forState:UIControlStateNormal];

    if (!IS_IOS7)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}


- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectPeriod:(UIButton*)sender {
    NSLog(@"selected period: %d", sender.tag);
    [self loadGraphByPeriod:sender.tag];
    for (int i=0; i< [periods count]; i++){
        UIButton *aux = (UIButton*)[periods objectAtIndex:i];
        if (aux.tag != sender.tag) {
            aux.selected = FALSE;
            //aux.highlighted = FALSE;
        }
    }
    sender.selected = TRUE;
    _selectedPeriod = sender.tag;
    //sender.highlighted = TRUE;
}

- (void)loadGraphByPeriod:(int)period {
    /*
     switch (period){
     case 1: bottleGraphDaily = [[BottlefeedingDailyGraph alloc] initWithFrame:CGRectMake(0, 44+25, self.swipe.frame.size.width, 225-25)];
     break;
     case 2: bottleGraphWeekly = [[BottlefeedingWeeklyGraph alloc] initWithFrame:CGRectMake(0, 44+25, self.swipe.frame.size.width, 225-25)];
     break;
     case 3: bottleGraphMonthly = [[BottlefeedingMonthlyGraph alloc] initWithFrame:CGRectMake(0, 44+25, self.swipe.frame.size.width, 225-25)];     break;
     default: break;
     }
     */
    ////
    //clear screenshot view
    for (UIView *v in self.view.subviews) {
        if (v.tag == 200)
            [v removeFromSuperview];
        if (([v isKindOfClass:[BottlefeedingDailyGraph class]]) || ([v isKindOfClass:[BottleFeedingWeeklyGraph class]]) || ([v isKindOfClass:[BottlefeedingMonthlyGraph class]]))
            [v removeFromSuperview];
    }
    
    screenshot = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.height, self.view.frame.size.width)];
    screenshot.tag = 200;
    [screenshot setBackgroundColor:[UIColor clearColor]];
    [screenshot setUserInteractionEnabled:NO];
//    for (UIView *v in screenshot.subviews)
//            [v removeFromSuperview];
    
    switch (period){
        case 1: //self.breastGraph.breastfeedings = breastfeeds weekly
        {
            self.periodLabelDescription.text=T(@"%graph.bottleWeeklyDescription");
            NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"dd.MM.yyyy"];
            NSDate *today = self.date;
            
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
            [yearFormatter setDateFormat:@"yyyy"];
            year = [yearFormatter stringFromDate:[NSDate new]];
            
            self.shareStartDate = [[NSString alloc] initWithFormat:@"%@ %@",labelDates[0], fullMonthNames[0]];
            self.shareEndDate = [[NSString alloc] initWithFormat:@"%@ %@ %@",labelDates[1], fullMonthNames[1],year];
            NSString *descriptionLabelText = [[NSString alloc] initWithFormat:@"%@ %@ - %@ %@ %@",labelDates[0], fullMonthNames[0],labelDates[1], fullMonthNames[1],year ];
            //v.bottles = self.dailyFeedings;
            
            //
            bottleGraphDaily = [[BottlefeedingDailyGraph alloc] initWithFrame:self.swipe.frame];
            //self.babyGraph.pinScale = 10;
            //self.bottleGraph.weights = self.babyWeights;
            bottleGraphDaily.startDate = self.date;
            bottleGraphDaily.bottles = self.bottlesDaily;
            //self.bottleGraph.parentViewControler = vc;
            self.descriptionLabelText = descriptionLabelText;
            self.descriptionLabel.text = self.descriptionLabelText;
            [bottleGraphDaily createGraph];
            //[self.view setFrame:self.swipe.frame];
            [self.view addSubview:bottleGraphDaily];
            //[screenshot addSubview:bottleGraphDaily];
            //[screenshot addSubview:self.descriptionLabel];
            //[screenshot addSubview:self.periodLabelDescription];
            //[self.view addSubview:screenshot];
            
        }
            break;
        case 2: //self.breastGraph.breastfeedings = breastfeeds monthly
        {
            self.periodLabelDescription.text=T(@"%graph.bottleMonthlyDescription");
            bottleGraphWeekly = [[BottleFeedingWeeklyGraph alloc] initWithFrame:self.swipe.frame];
            bottleGraphWeekly.bottles = self.bottlesWeekly;
            bottleGraphWeekly.startDate = self.date;
            bottleGraphWeekly.parentViewControler = self;
            [bottleGraphWeekly createGraph];
            self.descriptionLabel.text = self.descriptionLabelText;
            [self.view addSubview:bottleGraphWeekly];
            //[screenshot addSubview:bottleGraphWeekly];
            //[screenshot addSubview:self.descriptionLabel];
            //[screenshot addSubview:self.periodLabelDescription];
            //[self.view addSubview:screenshot];
        }
            break;
        case 3: //self.breastGraph.breastfeedings = breastfeeds yearly
        {
            self.periodLabelDescription.text=T(@"%graph.bottleYearlyDescription");
            bottleGraphMonthly = [[BottlefeedingMonthlyGraph alloc] initWithFrame:self.swipe.frame];
            bottleGraphMonthly.bottles = self.bottlesMonthly;
            bottleGraphMonthly.startDate = self.date;
            bottleGraphMonthly.parentViewControler = self;
            [bottleGraphMonthly createGraph];
            self.descriptionLabel.text = self.descriptionLabelText;
            [self.view addSubview:bottleGraphMonthly];
            //[screenshot addSubview:bottleGraphMonthly];
            //[screenshot addSubview:self.descriptionLabel];
            //[screenshot addSubview:self.periodLabelDescription];
            //[self.view addSubview:screenshot];
        }
            break;
        default: break;
    }
    
}

-(UIImage *) getScreenImage
{
    UIView *view = screenshot;
//    for (UIView *v in self.view.subviews)
//        if ([v isKindOfClass:[CPTGraphHostingView class]])
//            view = v;
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;

}

-(NSString*) getScreenImagePath {
    UIImage *img = [self getScreenImage];
    NSData *imageData = UIImagePNGRepresentation(img);
    NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/graph_screenshot001.png"];
    [imageData writeToFile:imagePath atomically:YES];
    return imagePath;
    
}

- (IBAction)share:(id)sender {
    int sel = 0;
    for (int i=0; i< [periods count]; i++){
        UIButton *aux = (UIButton*)[periods objectAtIndex:i];
        if (aux.selected)
            sel = aux.tag;
    }
    NSMutableArray *screenshotViews = [[NSMutableArray alloc] init];
    
    
    ShareVC *share = [[ShareVC alloc] initWithNibName:NSStringFromClass([ShareVC class]) bundle:nil];
    
    /////
//    NSString *babyName = [User activeUser].favouriteBaby.name;
//    __block NSString *userTitle;
//    __block NSString *userFirstName;
//    __block NSString *userLastName;
//    //[WaitIndicator waitOnView:self.view];
//    [[User activeUser] loadPersonalInformation:^(Address *personalAddress) {
//        //[self.view stopWaiting];
//        if (personalAddress){
//            userTitle = personalAddress.localizedTitle;
//            userFirstName = personalAddress.firstName;
//            userLastName = personalAddress.lastName;
//        }
//    }];

    /////
    
    [self presentViewController:share animated:YES completion:^{
        switch (sel) {
            case 1:
                [screenshotViews addObject:bottleGraphDaily];
                break;
            case 2:
                [screenshotViews addObject:bottleGraphWeekly];
                break;
            case 3:
                [screenshotViews addObject:bottleGraphMonthly];
                break;
            default:
                break;
        }
        [screenshotViews addObject:self.descriptionLabel];
        [screenshotViews addObject:self.periodLabelDescription];
        [screenshotViews addObject:self.header];
        //[screenshotViews addObject:self.titleText];
        UILabel *shareTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, self.titleText.frame.origin.y, self.swipe.frame.size.width-10, self.titleText.frame.size.height)];
        shareTitle.textAlignment = NSTextAlignmentCenter;
        [shareTitle setFont:self.titleText.font];
        
        shareTitle.text = T(@"%share.bottle.imagetitle");
        shareTitle.textColor = self.titleText.textColor;
        //[shareTitle setNumberOfLines:0];
        //[shareTitle sizeToFit];

        [screenshotViews addObject:shareTitle];
        //add all views to screenshot view for capture
        for (UIView *v in screenshotViews)
            [screenshot addSubview:v];
        
        NSString *babyName = [User activeUser].favouriteBaby.name;
        share.text = [NSString stringWithFormat:T(@"%bottle.share.body.text"), babyName, self.shareStartDate, self.shareEndDate];
        share.subject = [NSString stringWithFormat:T(@"%bottle.share.email.subject"), babyName];
        //share.image = [UIImage imageNamed:@"wifi_bg_s2.png"];
        NSString *imgPath = [self getScreenImagePath];
        
        //add views back to self.view
//        for (UIView *v in screenshotViews)
//            [self.view addSubview:v];
        self.view = nil;
        //[self.view layoutSubviews];
        //[self.view setNeedsLayout];
        UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
        share.image = img;
        share.imagePath = imgPath;
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Orientation
- (void)deviceOrientationDidChange: (id) sender{
    NSLog(@"Orientation changed!!!!!");
    if ([[UIDevice currentDevice] orientation] == (UIDeviceOrientationPortrait)){
        NSLog(@"Landscape OFF");
        //[self.originNavigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == (UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationLandscapeLeft));}
-(BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}


@end
