//
//  WeightGraphLandscapeVC.m
//  Flatland
//
//  Created by Ionel Pascu on 10/11/13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WeightGraphLandscapeVC.h"
#import "User.h"

@interface WeightGraphLandscapeVC ()

@end

@implementation WeightGraphLandscapeVC
NSArray *periods;
UIView *screenshot;
@synthesize babyGraph;
@synthesize periodButtons;
@synthesize but1, but2, but3, but4;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    //CGAffineTransform transform = CGAffineTransformMakeRotation((M_PI/2));
    //self.view.transform = transform;
    // Repositions and resizes the view.
    //0, 0,
    //x is height of iPhone screen
    //contentRect for pushedController
    //CGRect contentRect = CGRectMake(-5, -15, 280, 410);
    
    //contentRect for Modal
    //CGRect contentRect = CGRectMake(5, 35, 460, 260);
    //CGRect contentRect = CGRectMake(0, 0, 480, 300);
    
    
    //self.view.frame = contentRect;
   //graph = [[BabyWeightGraph alloc] initWithFrame:CGRectMake(0, 34, 480, 260)];
   // NSLog(@"graf: %f %f %f %f", graph.frame.origin.x, graph.frame.origin.y, graph.frame.size.width, graph.frame.size.height);
    //[graph addSubview:v];
    //swipeView = [[SwipeView alloc] init];
    
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
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
    
    if (!IS_IOS7)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.labelPeriodDescription.alpha=0.0;
    self.labelPeriodDescription.text=T(@"%graph.bottleWeeklyDescription");
    [self.labelPeriodDescription setHidden:YES];
    self.header.layer.shadowOpacity = 0.75f;
    self.header.layer.shadowRadius = 10.0f;;
    self.header.layer.shadowColor = [UIColor blackColor].CGColor;

    
    // Do any additional setup after loading the view from its nib.
    // Rotates the view.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    //[self.descriptionLabel setFrame:CGRectMake(self.view.frame.size.width-(self.descriptionLabel.frame.size.width/2), self.descriptionLabel.frame.origin.y, self.descriptionLabel.frame.size.width, self.descriptionLabel.frame.size.height)];
    self.descriptionLabel.text = self.descriptionLabelText;
    //format period buttons Ionel

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
    if (_selectedPeriod)
       for (UIButton *but in periods)
           if (but.tag == _selectedPeriod)
               [self selectPeriod:but];
    
}
- (void) viewDidAppear:(BOOL)animated{
    //UIView *aux = [[UIView alloc] initWithFrame:CGRectMake(0, 44+25, self.swipe.frame.size.width, 225-25)];
    babyGraph = [[BabyWeightGraph alloc] initWithFrame:CGRectMake(0, 44+25+10, self.swipe.frame.size.width, 225-25)];
    NSLog(@"dim:: %f", self.swipe.frame.size.width);
    babyGraph.pinScale = 2;
    babyGraph.period = 90;
    babyGraph.weights = [self.babyWeights copy];
    babyGraph.growthPath = _growth3;
    babyGraph.startDate = self.date;
    babyGraph.parentViewControler = self;
    //vc.descriptionLabel.text = self.descriptionLabelText;
    //[self.graphVC.descriptionLabel setFrame:CGRectMake(self.view.frame.size.width-(self.descriptionLabel.frame.size.width/2), self.descriptionLabel.frame.origin.y, self.descriptionLabel.frame.size.width, self.descriptionLabel.frame.size.height)];
    //[self.graphVC.descriptionLabel setCenter:self.swipeView.center];
    [babyGraph createGraph];
    
    [self presentGraph];
    for (UIButton *but in periods)
        if (but.selected)
            [self selectPeriod:but];
    
    if (_selectedPeriod)
        for (UIButton *but in periods)
            if (but.tag == _selectedPeriod)
                [self selectPeriod:but];
    
    //clear screenshot view
    for (UIView *v in self.view.subviews) {
        if (v.tag == 200)
            [v removeFromSuperview];
        
    }
    
    screenshot = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.height, self.view.frame.size.width)];
    screenshot.tag = 200;
    [screenshot setBackgroundColor:[UIColor clearColor]];
    [screenshot setUserInteractionEnabled:NO];
//    [screenshot addSubview:babyGraph];
//    [screenshot addSubview:self.descriptionLabel];
//    [screenshot addSubview:self.labelPeriodDescription];
//    [self.view addSubview:screenshot];
    NSLog(@"dim:: %f", self.swipe.frame.size.width);
    
}

- (void)presentGraph
{
    [babyGraph setAlpha:0.0];
    [self.descriptionLabel setAlpha:0.0];
    CGRect frame = self.babyGraph.frame;
    [babyGraph setFrame:CGRectMake(0, 320, 0, 0)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:v cache:NO];
    [babyGraph setAlpha:1.0];
    self.labelPeriodDescription.alpha=1.0;
    [self.descriptionLabel setAlpha:1.0];
    [babyGraph setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    [self.view addSubview:babyGraph];

    
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
        return (toInterfaceOrientation == (UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationLandscapeLeft));
}

-(BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
   return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}

//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeRight;
//}
//
//orientation

- (void)deviceOrientationDidChange: (id) sender{
    NSLog(@"Orientation changed!!!!!");
    if ([[UIDevice currentDevice] orientation] == (UIDeviceOrientationPortrait)){
        NSLog(@"Landscape OFF");
        //[self.originNavigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)click:(id)sender {
        [self.originNavigationController presentViewController:[[WeightGraphLandscapeVC alloc] init] animated:YES completion:nil];
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
    switch (period){
        case 1: babyGraph.weights = [self.babyWeights copy];
                babyGraph.period = 90;
                babyGraph.growthPath = _growth3;
            break;
        case 2: babyGraph.weights = [self.babyWeights copy];
                babyGraph.period = 180;
                babyGraph.growthPath = _growth6;
            break;
        case 3: babyGraph.weights = [self.babyWeights copy];
                babyGraph.period = 360;
                babyGraph.growthPath = _growth12;
            break;
        default: break;
    }
    
    switch (period){
        case 1: //self.breastGraph.breastfeedings = breastfeeds weekly
            self.labelPeriodDescription.text=T(@"%graph.bottleWeeklyDescription");
            break;
        case 2: //self.breastGraph.breastfeedings = breastfeeds monthly
            self.labelPeriodDescription.text=T(@"%graph.bottleMonthlyDescription");
            
            break;
        case 3: //self.breastGraph.breastfeedings = breastfeeds yearly
            self.labelPeriodDescription.text=T(@"%graph.bottleYearlyDescription");
            break;
        default: break;
    }

    
    babyGraph.startDate = self.date;
    babyGraph.parentViewControler = self;
    //vc.descriptionLabel.text = self.descriptionLabelText;
    //[self.graphVC.descriptionLabel setFrame:CGRectMake(self.view.frame.size.width-(self.descriptionLabel.frame.size.width/2), self.descriptionLabel.frame.origin.y, self.descriptionLabel.frame.size.width, self.descriptionLabel.frame.size.height)];
    //[self.graphVC.descriptionLabel setCenter:self.swipeView.center];
    [babyGraph createGraph];
    self.descriptionLabel.text = self.descriptionLabelText;
    
    //to do: handle labels, graph title specific for each period
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
                [screenshotViews addObject:babyGraph];
                break;
            case 2:
                [screenshotViews addObject:babyGraph];
                break;
            case 3:
                [screenshotViews addObject:babyGraph];
                break;
            default:
                break;
        }
        [screenshotViews addObject:self.descriptionLabel];
        [screenshotViews addObject:self.labelPeriodDescription];
        [screenshotViews addObject:self.header];
        //[screenshotViews addObject:self.titleText];
        UILabel *shareTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, self.titleText.frame.origin.y, self.swipe.frame.size.width-10, self.titleText.frame.size.height)];
        shareTitle.textAlignment = NSTextAlignmentCenter;
        [shareTitle setFont:self.titleText.font];
        shareTitle.text = T(@"%share.weight.imagetitle");
        shareTitle.textColor = self.titleText.textColor;
        //[shareTitle setNumberOfLines:0];
        //[shareTitle sizeToFit];
        [screenshotViews addObject:shareTitle];

        //add all views to screenshot view for capture
        for (UIView *v in screenshotViews)
            [screenshot addSubview:v];
        NSString *babyName = [User activeUser].favouriteBaby.name;
        share.text = [NSString stringWithFormat:T(@"%weight.share.body.text"), babyName, self.shareStartDate, self.shareEndDate];
        share.subject = [NSString stringWithFormat:T(@"%weight.share.email.subject"), babyName];
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


@end
