//
//  BreastfeedingGraphLandscapeVC.m
//  Flatland
//
//  Created by Ionel Pascu on 10/16/13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BreastfeedingGraphLandscapeVC.h"
#import "User.h"

@interface BreastfeedingGraphLandscapeVC ()

@end

@implementation BreastfeedingGraphLandscapeVC
NSArray *periods;
UIView *screenshot;
@synthesize breastGraphDaily, breastGraphMonthly, breastGraphYearly;
@synthesize but1, but2, but3, but4;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.labelPeriodDescription.alpha=0.0;
    self.labelPeriodDescription.text=T(@"%graph.breastWeeklyDescription");

    
    self.header.layer.shadowOpacity = 0.75f;
    self.header.layer.shadowRadius = 10.0f;;
    self.header.layer.shadowColor = [UIColor blackColor].CGColor;

    // Do any additional setup after loading the view from its nib.
    // Rotates the view.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    
    periods = [NSArray arrayWithObjects:but1, but2, but3, nil];
    for (int i=0; i< [periods count]; i++)
    {
        UIButton *aux = (UIButton*)[periods objectAtIndex:i];
        aux.tag = i+1;

        
        aux.autoresizingMask = UIViewAutoresizingNone;
        [aux.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [aux setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    
    for (UIButton *but in periods)
        if (but.selected) {
            [self selectPeriod:but];
            //_selectedPeriod = 0;
        }
    if ((!but1.selected) && (!but2.selected) && (!but3.selected) )
        [but1 setSelected:TRUE];
    
//    if (_selectedPeriod)
//        for (UIButton *but in periods)
//            if (but.tag == _selectedPeriod)
//                [self selectPeriod:but];

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
    [but1 setTitle:T(@"%graph.bottleWeekly") forState:UIControlStateNormal];
    [but2 setTitle:T(@"%graph.bottleMonthly") forState:UIControlStateNormal];
    [but3 setTitle:T(@"%graph.bottleYearly") forState:UIControlStateNormal];

    if (!IS_IOS7)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    //[self presentGraph];
//    for (UIButton *but in periods)
//        if (but.selected)
//            [self selectPeriod:but];
    
    if (_selectedPeriod)
        for (UIButton *but in periods)
            if (but.tag == _selectedPeriod)
                [self selectPeriod:but];
}



- (void)presentGraph
{
    [breastGraphDaily setAlpha:0.0];
    [self.descriptionLabel setAlpha:0.0];
    CGRect frame = breastGraphDaily.frame;
    [breastGraphDaily setFrame:CGRectMake(0, 320, 0, 0)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:v cache:NO];
    [breastGraphDaily setAlpha:1.0];
    //self.labelPeriodDescription.alpha=1.0;
    [self.descriptionLabel setAlpha:1.0];
    [breastGraphDaily setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    //[self.view addSubview:breastGraph];
    [UIView commitAnimations];
}

- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectPeriod:(UIButton*)sender
{
    NSLog(@"selected period: %d", sender.tag);
    [self loadGraphByPeriod:sender.tag];
    for (int i=0; i< [periods count]; i++)
    {
        UIButton *aux = (UIButton*)[periods objectAtIndex:i];
        if (aux.tag != sender.tag)
        {
            aux.selected = FALSE;
            //aux.highlighted = FALSE;
        }
    }
    sender.selected = TRUE;
    _selectedPeriod = sender.tag;
    //sender.highlighted = TRUE;
}

- (void)loadGraphByPeriod:(int)period {

    //clear screenshot view
    for (UIView *v in self.view.subviews) {
        if (v.tag == 200)
            [v removeFromSuperview];
        if (([v isKindOfClass:[BreastfeedingsCountGraphView class]]) || ([v isKindOfClass:[BreastFeedMonthlyGraph class]]) || ([v isKindOfClass:[BreastFeedYearlyGraph class]]))
            [v removeFromSuperview];
    }
    
    screenshot = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.height, self.view.frame.size.width)];
    screenshot.tag = 200;
    [screenshot setBackgroundColor:[UIColor clearColor]];
    [screenshot setUserInteractionEnabled:NO];
    
    switch (period){
        case 1: //self.breastGraph.breastfeedings = breastfeeds weekly
        {
            self.labelPeriodDescription.text=T(@"%graph.breastWeeklyDescription");
            ////
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
            
            //////
            //BreastfeedingGraphLandscapeVC *vc = [[BreastfeedingGraphLandscapeVC alloc] initWithNibName:NSStringFromClass([BreastfeedingGraphLandscapeVC class]) bundle:nil];
            //
            breastGraphDaily = [[BreastfeedingsCountGraphView alloc] initWithFrame:CGRectMake(0, 44+25+10, self.swipe.frame.size.width, 225-25)];
            breastGraphDaily.pinScale = 10;
            //v.breastfeedings = self.babyWeights;
            breastGraphDaily.startDate = self.date;
            //v.parentViewControler = self;
            breastGraphDaily.breastfeedings = _breastsDaily;
            self.descriptionLabelText = descriptionLabelText;
            self.descriptionLabel.text = self.descriptionLabelText;
            //[self.descriptionLabel setAlpha:0.0];
            
            [breastGraphDaily createGraph];
//            [screenshot addSubview:breastGraphDaily];
//            [screenshot addSubview:self.descriptionLabel];
//            [screenshot addSubview:self.labelPeriodDescription];
//            [self.view addSubview:screenshot];

            [self.view addSubview:breastGraphDaily];
            }
            break;
        case 2: //self.breastGraph.breastfeedings = breastfeeds monthly
        {
            self.labelPeriodDescription.text=T(@"%graph.bottleMonthlyDescription");
            
            breastGraphMonthly = [[BreastFeedMonthlyGraph alloc] initWithFrame:CGRectMake(0, 44+25+10, self.swipe.frame.size.width, 225-25)];
            breastGraphMonthly.pinScale = 10;
            //v.breastfeedings = self.babyWeights;
            breastGraphMonthly.startDate = self.date;
            //v.parentViewControler = self;
            breastGraphMonthly.breastfeedings = _breastsWeekly;
            breastGraphMonthly.parentVC = self;
            //self.descriptionLabelText = descriptionLabelText;
            
            //[self.descriptionLabel setAlpha:0.0];
            
            [breastGraphMonthly createGraph];
            self.descriptionLabel.text = self.descriptionText;
//            [screenshot addSubview:breastGraphMonthly];
//            [screenshot addSubview:self.descriptionLabel];
//            [screenshot addSubview:self.labelPeriodDescription];
//            [self.view addSubview:screenshot];
            [self.view addSubview:breastGraphMonthly];
        }

            break;
        case 3: //self.breastGraph.breastfeedings = breastfeeds yearly
        {
            self.labelPeriodDescription.text=T(@"%graph.bottleYearlyDescription");
            ////
            breastGraphYearly = [[BreastFeedYearlyGraph alloc] initWithFrame:CGRectMake(0, 44+25+10, self.swipe.frame.size.width, 225-25)];
            breastGraphYearly.pinScale = 10;
            //v.breastfeedings = self.babyWeights;
            breastGraphYearly.startDate = self.date;
            //v.parentViewControler = self;
            breastGraphYearly.breastfeedings = _breastsMonthly;
            breastGraphYearly.parentVC = self;
            //self.descriptionLabelText = descriptionLabelText;
            
            //[self.descriptionLabel setAlpha:0.0];
            
            [breastGraphYearly createGraph];
            self.descriptionLabel.text = self.descriptionText;
//            [screenshot addSubview:breastGraphYearly];
//            [screenshot addSubview:self.descriptionLabel];
//            [screenshot addSubview:self.labelPeriodDescription];
//            [self.view addSubview:screenshot];
            [self.view addSubview:breastGraphYearly];
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
    
    [self presentViewController:share animated:YES completion:^{
        switch (sel) {
            case 1:
                [screenshotViews addObject:breastGraphDaily];
                break;
            case 2:
                [screenshotViews addObject:breastGraphMonthly];
                break;
            case 3:
                [screenshotViews addObject:breastGraphYearly];
                break;
            default:
                break;
        }
        [screenshotViews addObject:self.descriptionLabel];
        [screenshotViews addObject:self.labelPeriodDescription];
        [screenshotViews addObject:self.header];
        //[screenshotViews addObject:self.titleText];
        [screenshotViews addObject:self.leftDrop];
        [screenshotViews addObject:self.rightDrop];
        UILabel *shareTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, self.titleText.frame.origin.y, self.swipe.frame.size.width-10, self.titleText.frame.size.height)];
        shareTitle.textAlignment = NSTextAlignmentCenter;
        [shareTitle setFont:self.titleText.font];
        shareTitle.text = T(@"%share.breastfeed.imagetitle");
        shareTitle.textColor = self.titleText.textColor;
        //[shareTitle setNumberOfLines:0];
        //[shareTitle sizeToFit];
        [screenshotViews addObject:shareTitle];

        
        //add all views to screenshot view for capture
        for (UIView *v in screenshotViews)
            [screenshot addSubview:v];
        NSString *babyName = [User activeUser].favouriteBaby.name;
        share.text = [NSString stringWithFormat:T(@"%breastfeed.share.body.text"), babyName, self.shareStartDate, self.shareEndDate];
        share.subject = [NSString stringWithFormat:T(@"%breastfeed.share.email.subject"), babyName];
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
