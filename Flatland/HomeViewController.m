 //
//  HomeViewController.m
//  Flatland
//
//  Created by Stefan Aust on 15.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTitleView.h"
#import "HomeNotificationView.h"

#import "User.h"
#import "AlertView.h"

#import "MFSideMenu.h"
#import "EditBabyProfileViewController.h"
//#import "MenuViewController.h"
#import "CoachsMainViewController.h"
#import "CalendarView.h"
#import "BreastfeedingWidgetViewController.h"
#import "BottlefeedingWidgetViewController.h"
#import "WeightWidgetViewController.h"
#import "TimelineWidgetViewController.h"
#import "DynamicSizeContainer.h"
#import "TipsViewController.h"
#import "TipsDetailsViewController.h"
#import "ConfigureWidgetsViewController.h"
#import "WebViewViewController.h"
#import "OverlayTutorialView.h"
#import "WaitIndicator.h"
#import "Baby.h"
#import "BalanceViewController.h"
#import "CartViewController.h"
#import "AppDelegate.h"
#import "FAQViewController.h"
#import "WebViewController.h"
#import "ShopsViewController.h"
#import "LastDateService.h"
#import "Capsule.h"
#import "WifiStatus.h"
#import "TimelineHomeViewController.h"



@interface HomeViewController () <MenuViewControllerDelegate, UIScrollViewDelegate, CalendarViewDelegate>

@property (nonatomic, strong) HomeTitleView *titleView;
@property (weak, nonatomic) IBOutlet UIImageView *babyPictureView;
@property (weak, nonatomic) IBOutlet UIView *topContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet DynamicSizeContainer *widgetContainer;
@property (weak, nonatomic) IBOutlet CalendarView *calendarView;
@property (nonatomic) int finishedWidgets;
@property (nonatomic, weak) Baby *baby;
@property (nonatomic, weak) Baby *babyTest;
@property (strong, nonatomic) IBOutlet UIButton *tipsButton;
@property (strong, nonatomic) IBOutlet UIButton *babyTimeLineButton;
@property (strong, nonatomic) IBOutlet UIButton *fakeButton;
@property (weak, nonatomic) IBOutlet UIButton *tipsLabelButton;
@property (weak, nonatomic) IBOutlet UIButton *babyTimeLineLabelButton;
@property (weak, nonatomic) IBOutlet UILabel *babyNameFormulaLabel;
@property (weak, nonatomic) IBOutlet UILabel *capsuleDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStockTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStockLabel;
@property (weak, nonatomic) IBOutlet UILabel *capsulesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *capsuleImage;

@property (weak, nonatomic) IBOutlet UIView *babyDetailsContainerView;

@property (nonatomic) BOOL wasMenuItemClicked;
@property (nonatomic) BOOL wasWifiRefillShown;
@property (nonatomic) BOOL wasWifiSetupShown;
@property (nonatomic) BOOL getNotifications;

@property (nonatomic, weak) IBOutlet HomeNotificationView *notificationView;
- (IBAction)goCoachs:(id)sender;

@end


@implementation HomeViewController {
    CGFloat _origY;
    NSString *_favouriteBabyID;
}
//@synthesize menuViewController;
- (void) setDate: (NSDate *) date
{
    if (_date!=date)
    {
        [_calendarView setBaseDate:date];
        _date = date;
    }
    //for (WidgetViewController *wc in self.widgetControllers) {
    //    wc.date = date;
    //    wc.dateIndex = [[NSNumber alloc] initWithInt:_calendarView.didSelectDate];
    //}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // for iOS7
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        
    }
    
    self.screenName = @"Home Screen";
    // wire up the side menu
    MenuViewController *menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    [MFSideMenu menuWithNavigationController:self.navigationController
                      leftSideMenuController:menuViewController
                     rightSideMenuController:nil];
    menuViewController.delegate = self;
    _menuViewController = menuViewController;
    _origY = -1;
    self.widgetControllers = [NSMutableArray new];
    _finishedWidgets = 0;
    
    self.widgetContainer.cols = 1;
    self.widgetContainer.border = 10;
    self.widgetContainer.gap = 5;
    
    self.navigationItem.leftBarButtonItem = MakeImageBarButton(@"barbutton-settings", self, @selector(toggleMenu));
    
    //if we have no logged in user - show login screen
    if (![[User activeUser] isLoggedIn]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginRegistration" bundle:nil];
        [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"WelcomeNC"] animated:NO completion:nil];
    }
    else
    {
        //check if access token is ok
        [WaitIndicator waitOnView:self.view];
        [[User activeUser] loadWifiStatusCompletion:^(BOOL success)
         {
             [self.view stopWaiting];
             if (!success)
             {
                 //send the user to login screen
                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginRegistration" bundle:nil];
                 [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"WelcomeNC"] animated:NO completion:nil];
             }
         }];//TODO replace this with a propper login check API
    }
    
    self.scrollView.delegate = self;
    
    self.calendarView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 500);
    self.scrollView.scrollEnabled = YES;
    
    [self.tipsLabelButton.titleLabel setFont:[UIFont boldFontOfSize:14]];
    [self.babyTimeLineLabelButton.titleLabel setFont:[UIFont boldFontOfSize:14]];
    
    UIColor *purpleColor = [UIColor colorWithRed:52.0f/255.0f green:48.0f/255.0f blue:78.0f/255.0f alpha:1.0f];
    
    [self.tipsLabelButton setTitleColor:purpleColor forState:UIControlStateHighlighted];
    [self.babyTimeLineLabelButton setTitleColor:purpleColor forState:UIControlStateHighlighted];
    
    [self setupTitleView];
    
#ifndef WIP_TIMELINE
#ifdef BABY_NES_US
    self.tipsButton.hidden = self.tipsLabelButton.hidden = YES;
    self.babyTimeLineButton.hidden = self.babyTimeLineLabelButton.hidden = YES;
    
    //Move baby details container and picture down
    int pointsToMoveDown = 20;
    
    CGPoint center = self.babyDetailsContainerView.center;
    center.y += pointsToMoveDown;
    self.babyDetailsContainerView.center = center;
    
    center = self.babyPictureView.center;
    center.y += pointsToMoveDown;
    self.babyPictureView.center = center;
#else
    self.babyTimeLineButton.hidden = self.babyTimeLineLabelButton.hidden = YES;
    
    float dx = self.tipsButton.center.x - self.tipsLabelButton.center.x;
    CGPoint center = self.tipsButton.center;
    center.x = 160;
    self.tipsButton.center = center;
    
    center = self.tipsLabelButton.center;
    center.x = self.tipsButton.center.x - dx;
    self.tipsLabelButton.center = center;
#endif //BABY_NES_US
#endif //WIP_TIMELINE
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];

    if(_wasMenuItemClicked)
    {
        _wasMenuItemClicked = false;
        [self toggleMenu];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(favouriteBabyChanged:)
                                                 name:FavouriteBabyChangedNotification
                                               object:[User activeUser]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTitleView)
                                                 name:@"NotificationsChangedNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(widgetSetupFinished)
                                                 name:@"WidgetSetupFinishedNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupWidgets)
                                                 name:@"WidgetsHadChangedNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuReady)
                                                 name:@"menuReadyNotification"
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBabies) name:@"MustUpdateBabiesNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openWifiOptions) name:@"openWifiOptions" object:nil];

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    
    [Stock get:^(Stock *stock) {
        _stock = stock;
        [self updateBabyDescriptionView];
    }];
    
    
    [self setupFavouriteBaby:[User activeUser].favouriteBaby];
    
    
    if([[User activeUser] wifiStatus] == WIFI_STATUS_UNKNOWN)
    {
        [self getWifiState];
    }
    
    // if the user has not seen the tutorial view, show it to him
    if (![User activeUser].hasSeenTutorialView)
    {
        [OverlayTutorialView openTutorialView];
    }
    
    [self setupWidgets];
    for (WidgetViewController *wc in self.widgetControllers) {
        wc.date = self.calendarView.selectedDate;
    }
    
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled = YES;
    
    
    [self.scrollView resignFirstResponder];
    //[self presentViewControllerWithIdentifier:@"WifiOptions" inStoryboard:@"Wifi"];
    [self addCartButton];
    //[self setupTitleView];
    if(IS_IOS7)
    {
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    }
    //[[NSNotificationCenter defaultCenter] postNotificationName:FavouriteBabyChangedNotification object:self];
    [self updateTitleView];
}

- (void)openWifiOptions
{
    if(!_wasWifiRefillShown)
    {
        _wasWifiRefillShown = YES;
    }
    else
    {
        _wasMenuItemClicked = false;
        [self closeMenu];
    }
    [self presentViewControllerWithIdentifier:@"WifiWelcomeNC" inStoryboard:@"Wifi"];
}

-(void)updateBabies
{
        [User activeUser].babies = nil;
        [[User activeUser] loadBabies:^(BOOL success)
         {
            if (success)
            {
                [self refreshView];
            }
            [[User activeUser] setMustUpdate:NO];
            [self setupFavouriteBaby:[User activeUser].favouriteBaby];
        }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeCartButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getWifiState];
}


-(void)inspectViewAndSubViews:(UIView*) v level:(int)level {
    
    NSMutableString* str = [NSMutableString string];
    
    for (int i = 0; i < level; i++)
    {
        [str appendString:@"   "];
    }
    
    [str appendFormat:@"%@", [v class]];
    
    if ([v isKindOfClass:[UITableView class]]) {
        [str appendString:@" : UITableView "];
    }
    
    if ([v isKindOfClass:[UIScrollView class]]) {
        [str appendString:@" : UIScrollView "];
        
        UIScrollView* scrollView = (UIScrollView*)v;
        if (scrollView.scrollsToTop) {
            [str appendString:@" >>>scrollsToTop<<<<"];
        }
    }
    
    for (UIView* sv in [v subviews]) {
        [self inspectViewAndSubViews:sv level:level+1];
    }
}

-(void)refreshView
{
    _calendarView.selectedDate = [NSDate date];
    for (WidgetViewController *wc in self.widgetControllers) {
        wc.date = [NSDate date];
        wc.dateIndex = [[NSNumber alloc] initWithInt:_calendarView.didSelectDate];
    }
    
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - UIScrollViewDelegate

/// stick the calendar View to the top when it gets out of the view
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // Close Notification View
    [self.notificationView close];
    
    if (_origY == -1 && self.calendarView.frame.origin.y < scrollView.contentOffset.y) {
        [self.view insertSubview:self.calendarView atIndex:1];
        CGRect frame = self.calendarView.frame;
        _origY = frame.origin.y;
        frame.origin.y = 0;
        self.calendarView.frame = frame;
    }
    if (_origY != -1 && _origY  > scrollView.contentOffset.y) {
        [self.scrollView insertSubview:self.calendarView atIndex:0];
        CGRect frame = self.calendarView.frame;
        frame.origin.y = _origY;
        self.calendarView.frame = frame;
        _origY = -1;
    }
    //NSLog(@"offset:: %f", scrollView.contentOffset.y);
}

#pragma mark - CalendarViewDelegate

- (void)calenderView:(CalendarView *)calenderView didSelectDate:(NSDate *)date {
    //inform the widgets that the baby has changes
    for (WidgetViewController *wc in self.widgetControllers) {
        wc.date = date;
        wc.dateIndex = [[NSNumber alloc] initWithInt:_calendarView.didSelectDate];
    }
}


#pragma mark - Previous Feeds Delegate
-(void)pressedPreviousFeeds:(int)index
{
    //calendar view last feedings
    NSDate *now = [NSDate date];
    NSDate *sevenDaysAgo = [now dateByAddingTimeInterval:-7*24*60*60];
    
    switch (index) {
            case 0:
            [_calendarView setBaseDate:[[LastDateService sharedInstance]feedings].lastWeightDate];
            break;
            case 1:
            [_calendarView setBaseDate:[[LastDateService sharedInstance]feedings].lastBottleFeedDate];
            break;
            case 2:
            [_calendarView setBaseDate:[[LastDateService sharedInstance]feedings].lastBreastFeedDate];
            break;
        default:
            break;
    }
}


#pragma mark - Baby Changed

- (void)favouriteBabyChanged:(NSNotification *)notification
{
    Baby *fb = ((User *)notification.object).favouriteBaby;
    [self setupFavouriteBaby:fb];
    [self updateTitleView];
    
    [[LastDateService sharedInstance]loadLastDate:[User activeUser].favouriteBaby];
    
    if([[User activeUser].babies count] == 0)
    {
        [User activeUser].widgetConfiguration = nil;
    }
}

- (void)setupFavouriteBaby:(Baby *)baby
{
    
    
    // ignore if we already have the correct baby
    if ([baby.ID isEqualToString:_favouriteBabyID] && NO == baby.isEdited )
    {
        _babyTest = baby;
        return;
    }
    
    
    
    // update the title
    self.title = baby.name;
    
    //  Set baby image
    [baby loadPictureWithCompletion:^(UIImage *picture)
    {
        self.babyPictureView.image = picture;
    }];
    
    
    
    // ignore if we already have the correct baby
//    if ([baby.ID isEqualToString:_favouriteBabyID])
//    {
//        _babyTest = baby;
//        return;
//    }
    _favouriteBabyID = baby.ID;
    
//    NSLog(@"%@",_favouriteBabyID);
    
    //inform the widgets that the baby has changes
    for (WidgetViewController *wc in self.widgetControllers)
    {
        wc.baby = baby;
    }
    
    [self updateBabyDescriptionView];
}

#pragma mark - Widget config changed

/// get the list of widgets configurations from the user and add them to the container
- (void)setupWidgets
{
    
    NSArray *widgetConfiguration = [User activeUser].widgetConfiguration;
    
    NSMutableArray *toBeRemoved = [NSMutableArray arrayWithCapacity:[self.widgetControllers count]];
    // remove all the widgets that are not the in configuration of the user
    for (WidgetViewController *wc in self.widgetControllers)
    {
       // if (![widgetConfiguration containsObject:[wc.class widgetIdentifier]]) // BNM - 266   remove all
        {
            [wc.view removeFromSuperview];
            [toBeRemoved addObject:wc];
        }
    }
    
    // now, remove them from controller list
    for (WidgetViewController *wc in toBeRemoved)
    {
        [wc hideLoadingOverlay];
        //[self.widgetControllers removeObject:wc];  // no need to remove from wc
    }
    
    BOOL widgetAlreadyThere = NO;
    // now add all the widgets that are not already in the view
    for (NSString *widget in widgetConfiguration)
    {
        for (WidgetViewController *wc in self.widgetControllers)
        {
            if ([[wc.class widgetIdentifier] isEqualToString:widget])
            {
                
                // this widget is already there,show it (insert it because was removed) , break and continue
                [self.widgetContainer insertSubview:wc.view atIndex:0];
                widgetAlreadyThere = YES;
                break;
            }
        }
        
        // the widget is already added, so just continue
        if (widgetAlreadyThere)
        {
            widgetAlreadyThere = NO;
            continue;
        }
        
        //only first time we add the widgets
        
        WidgetViewController *wc;
        
        if ([widget isEqualToString:[BreastfeedingWidgetViewController widgetIdentifier]]) {
            wc = [[BreastfeedingWidgetViewController alloc] init];
            wc.delegateHome=self;

        }
        
        if ([widget isEqualToString:[WeightWidgetViewController widgetIdentifier]]) {
            wc = [[WeightWidgetViewController alloc] init];
            wc.delegateHome=self;
        }
        
        if ([widget isEqualToString:[BottlefeedingWidgetViewController widgetIdentifier]]) {
            wc = [[BottlefeedingWidgetViewController alloc] init];
            wc.delegateHome=self;

        }
        
        if ([widget isEqualToString:[TimelineWidgetViewController widgetIdentifier]]) {
            wc = [[TimelineWidgetViewController alloc] init];
            wc.delegateHome=self;
        }

        
        wc.originNavigationController = self.navigationController;
        wc.date = self.calendarView.selectedDate;
        wc.baby = [User activeUser].favouriteBaby;
        wc.parentView = self;
        [self.widgetControllers addObject:wc];
        [self.widgetContainer insertSubview:wc.view atIndex:0];
        
    }
    [self.widgetContainer sizeToFit];
    CGRect frame = self.widgetContainer.frame;
    frame.size.height += 20;
    self.widgetContainer.frame = frame;
        // resize the scroll container
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.topContainer.frame.size.height + self.calendarView.frame.size.height + self.widgetContainer.frame.size.height);

}

#pragma mark - 

- (void) updateBabyDescriptionView
{
    
    if(nil == self.stock || 0 == [[User activeUser].babies count])
    {
        [self.babyDetailsContainerView setHidden:YES];
        return;
    }

    //get fav baby
    Baby* favouriteBaby = nil;
    
    for (int i=0;i<[[User activeUser].babies count];i++)
    {
        if ([[(Baby*)[[User activeUser].babies objectAtIndex:i] ID] isEqualToString:_favouriteBabyID])
        {
            favouriteBaby = [[User activeUser].babies objectAtIndex:i];
        }
    }
    
    if (nil == favouriteBaby)//return if fav baby not found
    {
        [self.babyDetailsContainerView setHidden:YES];
        return;
    }
    
    //setup and show container view
    [self.babyDetailsContainerView setHidden:NO];
    self.babyNameFormulaLabel.text = [NSString stringWithFormat:T(@"%home.details.babyformula"),favouriteBaby.name];
    
    //get current capsule
    Capsule *capsule = nil;
    NSString *capsuleType = [favouriteBaby.capsuleType lowercaseString];
    
    if ([capsuleType rangeOfString:@"firstmonth"].location != NSNotFound )
    {
        capsule = [Capsule capsuleForType:@"FirstMonth"];
    }
    else if ([capsuleType rangeOfString:@"secondmonth"].location != NSNotFound )
    {
        capsule = [Capsule capsuleForType:@"SecondMonth"];
    }
    else if ([capsuleType rangeOfString:@"thirdtosixthmonth"].location != NSNotFound )
    {
        capsule = [Capsule capsuleForType:@"ThirdToSixthMonth"];
    }
    else if ([capsuleType rangeOfString:@"seventhtotwelfthmonth"].location != NSNotFound )
    {
        capsule = [Capsule capsuleForType:@"SeventhToTwelfthMonth"];
    }
    else if ([capsuleType rangeOfString:@"thirteenthtotwentyfourthmonth"].location != NSNotFound )
    {
        capsule = [Capsule capsuleForType:@"ThirteenthToTwentyFourthMonth"];
    }
    else if ([capsuleType rangeOfString:@"twentyfifthmonthtothirtysixthmonth"].location != NSNotFound )
    {
        capsule = [Capsule capsuleForType:@"TwentyFifthMonthToThirtySixthMonth"];
    }
    else if ([capsuleType rangeOfString:@"Sensitive"].location != NSNotFound )
    {
        capsule = [Capsule capsuleForType:@"sensitive"];
    }
    
    //set capsule description text
    int size = [[favouriteBaby.capsuleSize lowercaseString] rangeOfString:@"large"].location  == NSNotFound ? 0 : 1;
    //Ionel fix null dereference security issue
    NSString *quantity;
    if ([capsule.sizes count] >= 1)
    //
        quantity = [capsule.sizes objectAtIndex:0];
    
    if ([capsule.sizes count] > 1) //bchitu:quick fix for capsules with 1 size.TODO solve the actual preblem(reference being modified in edit baby)
    {
        quantity = [capsule.sizes objectAtIndex:size];
    }

    self.capsuleDescriptionLabel.text = [NSString stringWithFormat:@"%@, %@ %@",capsule.title,quantity,T(@"%bottlefeeding.ml")];
    
    //set stock info
    self.currentStockTextLabel.text = T(@"%home.details.currentStock");
    self.currentStockLabel.text = [NSString stringWithFormat:@"%i",[self.stock countOfCapsuleType:capsule.type size:size == 0 ? @"Small" : @"Large"]]; //bchitu: some refactoring is needed on capsule and stock + server side code. Sizes dont;match(Large,Standard,Maxi..you get confused),stock should be singleton,etc.
    self.capsulesLabel.text = T(@"%home.details.capsules");
    
    //add spaces
    self.currentStockTextLabel.text = [NSString stringWithFormat:@"%@ ",self.currentStockTextLabel.text];
    self.currentStockLabel.text = [NSString stringWithFormat:@"%@ ",self.currentStockLabel.text];
    
    //make labels width the same as their text width and put them side by side on the same line
    [self.currentStockTextLabel sizeToFit];
    [self.currentStockLabel sizeToFit];
    [self.capsulesLabel sizeToFit];
    
    CGRect stockTextFrame = [self.currentStockTextLabel frame];
    CGRect stockFrame = [self.currentStockLabel frame];
    CGRect capsuleFrame = [self.capsulesLabel frame];
    int frameHeight = stockTextFrame.size.height > capsuleFrame.size.height ? stockTextFrame.size.height : capsuleFrame.size.height; //capsuleFrame.size.height should be bigger because of the bold font
    
    self.currentStockTextLabel.frame = CGRectMake(stockTextFrame.origin.x,
                                                  stockTextFrame.origin.y,
                                                  stockTextFrame.size.width,
                                                  frameHeight); //make sure all the labels have the same height
    
    self.currentStockLabel.frame = CGRectMake(stockTextFrame.origin.x + stockTextFrame.size.width,
                                              stockTextFrame.origin.y,
                                              stockFrame.size.width,
                                              frameHeight);
    
    stockFrame = [self.currentStockLabel frame];
    
    self.capsulesLabel.frame = CGRectMake(stockFrame.origin.x + stockFrame.size.width,
                                          stockFrame.origin.y,
                                          capsuleFrame.size.width,
                                          frameHeight);
    
    UIColor *purpleColor = [UIColor colorWithRed:52.0f/255.0f green:48.0f/255.0f blue:78.0f/255.0f alpha:1.0f];
    
    [self.babyNameFormulaLabel setTextColor:purpleColor];
    [self.capsuleDescriptionLabel setTextColor:purpleColor];
    [self.currentStockTextLabel setTextColor:purpleColor];
    [self.currentStockLabel setTextColor:purpleColor];
    [self.capsulesLabel setTextColor:purpleColor];
    [self.capsulesLabel setTextColor:purpleColor];
    
    //set capsule image
    [self.capsuleImage setImage:[UIImage imageNamed:[capsule imageName]]];
}

#pragma mark - Menu Delegate

- (void)pushViewControllerWithIdentifier:(NSString *)identifier inStoryboard:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:identifier] animated:YES];
    _wasMenuItemClicked = true;
    [self closeMenu];
}

- (void)presentViewControllerWithIdentifier:(NSString *)identifier inStoryboard:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:identifier] animated:YES completion:nil];
    _wasMenuItemClicked = false; //set to false.there is a bug that prevents view from being drawn after dismiss.(see BNM-621)
    [self closeMenu];
}


- (void)doAccountInformation {
    //[self pushViewControllerWithIdentifier:@"UserOverview" inStoryboard:@"EditUserAccount"];
    [self pushViewControllerWithIdentifier:@"OrderInformation" inStoryboard:@"Settings"];
}

- (void)doAdjustCapsuleStock {
    [self pushViewControllerWithIdentifier:@"CapsulesStock" inStoryboard:@"Shop"];
}

- (void) doOpenNotificationCenter
{
    [self pushViewControllerWithIdentifier:@"NotifiactionsAndAlerts" inStoryboard:@"Settings"];
}

- (void)doAdjustCapsuleStockNotification {
    [self pushViewControllerWithIdentifier:@"CapsulesStock" inStoryboard:@"Shop"];
    _wasMenuItemClicked = false;
    [self closeMenu];
}

- (void)doOrderRecommendation {
    [self pushViewControllerWithIdentifier:@"CapsuleRecommendation" inStoryboard:@"Shop"];
    _wasMenuItemClicked = false;
    [self closeMenu];
}


- (void)doOrderingInformation {
   [self pushViewControllerWithIdentifier:@"OrderInformation" inStoryboard:@"Settings"];
//    [self closeMenu];
//    WebViewController * webviewController=[[WebViewController alloc]initWithLink:@"https://preprod.babynes.com/us-en/sales/order/history/"];
//    [self.navigationController pushViewController:webviewController animated:YES];

}

- (void)doWifiSetup {
    if(!_wasWifiSetupShown){
        _wasWifiSetupShown = YES;
    }else{
        _wasMenuItemClicked = false;
        [self closeMenu];
    }

    [self presentViewControllerWithIdentifier:@"WifiHomeNav" inStoryboard:@"WifiSetup"];
}

- (void)doWifiRefill
{
    if(!_wasWifiRefillShown){
        _wasWifiRefillShown = YES;
    }else{
        _wasMenuItemClicked = false;
        [self closeMenu];
    }
    
    WifiStatus currentStatus = [[User activeUser] wifiStatus];
    if (currentStatus == WIFI_STATUS_CONNECTED || currentStatus == WIFI_STATUS_CONFIGURING|| currentStatus == WIFI_STATUS_DEACTIVATED)
    {
        [self presentViewControllerWithIdentifier:@"WifiWelcomeNC" inStoryboard:@"Wifi"];
    }
    else if(currentStatus == WIFI_STATUS_CONFIGURED)
    {
       [self presentViewControllerWithIdentifier:@"WifiWelcomeNC" inStoryboard:@"Wifi"];
//        [self presentViewControllerWithIdentifier:@"WifiChangeOptionsNC" inStoryboard:@"Wifi"];
    }
}

- (void)doShop {
    [self closeMenu];
    _wasMenuItemClicked = false;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Shop" bundle:nil];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"Shop"] animated:YES];
}

- (void)doHome {
    //[self closeMenu];
    //_wasMenuItemClicked = false;
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    //[self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"Home"] animated:YES];
}

- (void)doLogout {
    _wasMenuItemClicked = false;
    [self toggleMenu];
    
    _wasWifiRefillShown = _wasWifiSetupShown = NO;
    
    [[User activeUser] logout];
    [self presentViewControllerWithIdentifier:@"WelcomeNC" inStoryboard:@"LoginRegistration"];;
}

- (void)doCreateBabyProfile {
    [self closeMenu];
    if ([[User activeUser].babies count] == 5) {
        [[AlertView alertViewFromString:@"Create Profile|You cannot have more than 5 profiles.|OK" buttonClicked:nil] show];
        return;
    }
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"EditBabyProfile"] animated:YES];
}

- (void)doEditBabyProfile:(Baby *)babyProfile {
    [self closeMenu];
    EditBabyProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditBabyProfile"];
    vc.baby = babyProfile;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)doConfigureWidgets {
    [self closeMenu];
    _wasMenuItemClicked = true;
    [self doConfigWidgets];
}

- (void)doPrivacyPolicy {
    [self openWebViewWithTitle:T(@"%menu.information.privacy") andView:T(@"%menu.information.privacy.html")];
}

- (void)doWifiInformation {
    [self openWebViewWithTitle:T(@"%menu.information.wifi") andView:T(@"%menu.information.wifi.html")];
}

- (void)doLegalTerms {
    [self openWebViewWithTitle:T(@"%menu.information.legal") andView:T(@"%menu.information.legal.html")];
}

- (void)doGeneralTermsOfSale {
    [self openWebViewWithTitle:T(@"%menu.information.terms") andView:T(@"%menu.information.terms.html")];
}

- (void)doSanitaryMentions {
    [self openWebViewWithTitle:T(@"%menu.information.hygiene") andView:T(@"%menu.information.hygiene.html")];
}

- (void)doEcoParticipation {
    [self openWebViewWithTitle:T(@"%menu.information.eco") andView:T(@"%menu.information.eco.html")];
}

- (void)doUpdateFavouriteBaby {
    [self closeMenu];
}

#pragma mark - Actions

- (IBAction)doConfigWidgets {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ConfigureWidgets" bundle:nil];
    
    ConfigureWidgetsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ConfigureWidgets"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goShop {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Shop" bundle:nil];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"Shop"] animated:YES];
}

- (IBAction)goTips:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tips" bundle:nil];
    TipsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Tips"];
    vc.baby = _babyTest;
    [vc setFavorites:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goTimeline:(id)sender {
#ifdef WIP_TIMELINE
    [self pushViewControllerWithIdentifier:@"TimelineHome" inStoryboard:@"Timeline"];
    _wasMenuItemClicked = false;
    [self closeMenu];
#endif //WIP_TIMELINE
}


- (IBAction)goCoachs:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Coachs" bundle:nil];
    CoachsMainViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Coachs"];
    vc.baby = [User activeUser].favouriteBaby;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) goToTip:(NSNumber *)tip {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tips" bundle:nil];
    TipsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TipsDetails"];
    [vc setTip:[[Tips sharedTips] tipForWeek:tip]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goWithings {
    [self closeMenu];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    BalanceViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Balance"];
    vc.baby = [User activeUser].favouriteBaby;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goShopFinder {
    [self closeMenu];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginRegistration" bundle:nil];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"Shops"] animated:YES];
}

-(void)goContactUs
{
    [self closeMenu];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginRegistration" bundle:nil];
         [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"Contact"] animated:YES];
}

-(void)goToFAQ
{
    [self closeMenu];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FAQ" bundle:nil];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"FAQMain"] animated:YES];
}


-(void)gotToStoreLocator
{
    [self closeMenu];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginRegistration" bundle:nil];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"Shops"] animated:YES];
    
}

#pragma mark - Helpers

- (void)setupTitleView {
    _getNotifications = YES;
    self.titleView = [[HomeTitleView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    NSMutableArray *notificationArray = [NSMutableArray new];
    for(Notification* n in [[User activeUser] notifications]) {
        //if([[n babyID] isEqualToString:[[[User activeUser] favouriteBaby] ID]] || [n babyID].length < 1)
        {
            [notificationArray addObject:n];
        }
    }
    [self.titleView setNotificationCount:notificationArray.count];
    [self.notificationView setNotifications:notificationArray];
    [self.notificationView setDelegate:self];
    [self.titleView addTarget:self action:@selector(toggleNotificationView)];
    self.navigationItem.titleView = self.titleView;
}

- (void) updateTitleView {
    NSMutableArray *notificationArray = [NSMutableArray new];
    //Ionel: create notif array having the top notif the capsule reminder notif
    for(Notification* n in [[User activeUser] notifications]) {
        //if([[n babyID] isEqualToString:[[[User activeUser] favouriteBaby] ID]] || [n babyID].length < 1)
        if ([n notificationType] == NotificationTypeOrderRecommendation)
        {
            [notificationArray addObject:n];
        }
    }
    for(Notification* n in [[User activeUser] notifications]) {
        //if([[n babyID] isEqualToString:[[[User activeUser] favouriteBaby] ID]] || [n babyID].length < 1)
        if ([n notificationType] != NotificationTypeOrderRecommendation)
        {
            [notificationArray addObject:n];
        }
    }

    [((HomeTitleView *)self.navigationItem.titleView) setNotificationCount:notificationArray.count];
    [self.notificationView setNotifications:notificationArray];
}

- (void) widgetSetupFinished {
    _finishedWidgets++;
    if(_finishedWidgets == [self.widgetControllers count]){
        [self.view stopWaiting];
        _finishedWidgets = 0;
    }
}

// also update the custom home title view
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    [self.titleView setTitle:title];
}


// show or hide the notification area
- (void)toggleNotificationView {
    [self.notificationView toggle];
}

// show or hide the side menu
- (void)toggleMenu {
    [self.navigationController.sideMenu toggleLeftSideMenu];
}

- (void)closeMenu {
    [self.navigationController.sideMenu setMenuState:MFSideMenuStateClosed];
}


- (void)openWebViewWithTitle:(NSString *)title andView:(NSString *)view {
    [self closeMenu];
    _wasMenuItemClicked = true;
    WebViewViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    vc.title = title;
    vc.viewName = view;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getWifiState
{
    [[User activeUser] loadWifiStatusCompletion:^(BOOL success) {
        if(success){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wifiChanged" object:nil];
            
            WifiStatus currentWifiStatus = [[User activeUser] wifiStatus];
            
            if (currentWifiStatus == WIFI_STATUS_CONFIGURING || currentWifiStatus == WIFI_STATUS_CONNECTED)
            {
                if(!_wasWifiRefillShown && [[User activeUser] nbWifiRefillPrompts] < MAX_NB_WIFI_REFILL_PROMPTS)
                {
                    [[User activeUser] increaseNbWifiRefillPrompts];
                    [self doWifiRefill];
                }
            }
            else
            {
                if (currentWifiStatus == WIFI_STATUS_NO_WIFI && [[User activeUser] hasStartedWifiSetup])
                {
                    if(!_wasWifiSetupShown && [[User activeUser] nbWifiSetupPrompts] < MAX_NB_WIFI_SETUP_PROMPTS)
                    {
                        [self performSelector:@selector(doWifiSetup) withObject:nil afterDelay:1.0];
                        [[User activeUser] increaseNbWifiSetupPrompts];
                    }
                }
            }
            
        }
    }];
}

    
- (void)menuReady
{
    if ([[User activeUser] isLoggedIn])
    {
        [self getWifiState];
    }
}

- (Order *)order {
    return [Order sharedOrder];
}

#pragma mark - Cart button

- (void)addCartButton {
    [self.order addObserver:self selector:@selector(orderChanged:)];
    [self orderChanged:nil]; // this will add the button
}

- (void)removeCartButton {
    [self.order removeObserver:self];
    self.navigationItem.rightBarButtonItem = nil; // remove the button
}

/// Shows a "checkout" button if the shared order object contains order items and hides it otherwise
- (void)orderChanged:(NSNotification *)notification {
    NSUInteger count = [self.order orderItemCount];
    if (count) {
        NSString *title = [NSString stringWithFormat:@"%d", count];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = [self createCheckoutBarButtonItem: title];
    } else {
        self.navigationItem.rightBarButtonItem = MakeImageBarButton(@"barbutton-shop", self, @selector(goShop));
    }
}

- (UIBarButtonItem *)createCheckoutBarButtonItem:(NSString *)title {
    UIBarButtonItem *barButtonItem = MakeImageBarButton(@"barbutton-shop", self, @selector(checkout));
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, 10, 10)];
    label.font = [UIFont boldFontOfSize:7];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRGBString:@"8B88A8"];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    [barButtonItem.customView addSubview:label];
    return barButtonItem;
}

- (void)setCheckoutButtonBadge:(NSString *)badge {
    UILabel *label = [self.navigationItem.rightBarButtonItem.customView.subviews lastObject];
    label.text = badge;
}

#pragma mark - Actions

/// Shows the cart
- (IBAction)checkout {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Cart" bundle:nil];
    CartViewController *viewController = [storyboard instantiateInitialViewController];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark Orientation
- (void)deviceOrientationDidChange: (id) sender{
    NSLog(@"Orientation changed!!!!!");
    if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)){
        NSLog(@"Landscape ON");
        //-64 : 205.5 fitrst widget
        //206 : 396 : second widget

        float y = self.scrollView.contentOffset.y;
        //Ionel: get current visible widgets, in order of appearance
        NSLog(@"Widgets:::::::::\n");
        NSMutableArray *wid = self.widgetControllers;
        //NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"class.widgetIdentifier" ascending:YES];
        //[wid sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        //for (int i=0; i< [])
        //for (int i=0; i< [self.widgetControllers count]; i++)
        //    NSLog(@"%d: %@", i, [[wid objectAtIndex:i] class]);
        NSMutableArray *visibleWidgets = [[NSMutableArray alloc] init];
        for (UIView *v in [self.widgetContainer subviews])
            for (int i=0; i<[wid count]; i++)
                if ([v isEqual:[[wid objectAtIndex:i] view]])
                    [visibleWidgets addObject:[wid objectAtIndex:i]];
        //for (int j=0; j<[visibleWidgets count]; j++)
        //    NSLog(@"Visible %d: %@", j, [[visibleWidgets objectAtIndex:j] class]);
        
        
        if (y <= 205.5)
        {
            if ([visibleWidgets count] >=1)
                    [[visibleWidgets objectAtIndex:0] zoomGraph:nil];
        }
        else if (y <= 400)
            {
            if ([visibleWidgets count] >= 2)
                [[visibleWidgets objectAtIndex:1] zoomGraph:nil];
            }
        else if ([visibleWidgets count] >= 3)
        {
            [[visibleWidgets objectAtIndex:2] zoomGraph:nil];
        }
        //[self.originNavigationController popViewControllerAnimated:YES];
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == (UIInterfaceOrientationPortrait));
}

-(BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
