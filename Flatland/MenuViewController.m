
//
//  MenuViewController.m
//  Flatland
//
//  Created by Stefan Aust on 18.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "MenuViewController.h"
#import "User.h"
#import "BabyMenuViewController.h"
#import "DynamicSizeContainer.h"
#import "FlatSwitch.h"
#import "NewsletterSubscriptionDataService.h"
#import "NewsletterSubscription.h"
#import "AlertView.h"
#import "MenuButton.h"
#import <MessageUI/MessageUI.h>
#import "FAQViewController.h"
#import "HomeViewController.h"

#import "BabyMenuView.h"


@interface MenuViewController ()<BabyMenuViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *babyProfileViews;
@property (weak, nonatomic) IBOutlet BabyMenuView *babySlider;
@property (weak, nonatomic) IBOutlet UIView *layoutContainer;
@property (weak, nonatomic) IBOutlet UIButton *addBabyButton;
@property (nonatomic, copy) NSArray *babies;
@property (nonatomic, strong) NewsletterSubscription *subscriptions;
@property (strong, nonatomic) IBOutlet MenuButton *ecoButton;
@property (strong, nonatomic) IBOutlet MenuButton *hygieneButton;
@property (strong, nonatomic) IBOutlet MenuButton *newsletterAllButton;
@property (strong, nonatomic) IBOutlet MenuButton *wifiInformationButton;
@property (strong, nonatomic) IBOutlet MenuButton *privacyButton;
@property (strong, nonatomic) IBOutlet MenuButton *termsButton;
@property (strong, nonatomic) IBOutlet MenuButton *accountInfoBtn;

@property (strong, nonatomic) IBOutlet MenuButton *tipsButton;
@property (strong, nonatomic) IBOutlet MenuButton *stockReminderButton;
@property (strong, nonatomic) IBOutlet MenuButton *bottlefeedPushNotificationButton;
@property (weak, nonatomic) IBOutlet MenuButton *notificationsButton; //TODO remove these

@property (weak, nonatomic) IBOutlet MenuButton *wifiRefillButton;
@property (weak, nonatomic) IBOutlet MenuButton *nutritionistChatButton;
@property (weak, nonatomic) IBOutlet MenuButton *rateBabynessButton;
@property (weak, nonatomic) IBOutlet MenuButton *faqButton;

@property (nonatomic) BOOL isStockReminderSet;
@property (nonatomic) BOOL isCoachNotificationSet;
@property (nonatomic) BOOL isNewsletter;
@property (nonatomic) BOOL isNewsletterPartner;
@property (nonatomic) BOOL isTips;

@property (weak, nonatomic) IBOutlet FlatSwitch *babynesNewsletterSwitch;
@property (weak, nonatomic) IBOutlet FlatSwitch *partnerNewsletterSwitch;
@property (strong, nonatomic) IBOutlet FlatSwitch *bottlefeedPushNotificationSwitch;
@property (strong, nonatomic) IBOutlet FlatSwitch *stockReminderSwitch;
@property (strong, nonatomic) IBOutlet FlatSwitch *tipsSwitch;
@property (weak, nonatomic) IBOutlet MenuButton *wifiButton;
- (IBAction)goWithings:(id)sender;
- (IBAction)goShopFinder:(id)sender;
@property (weak, nonatomic) IBOutlet MenuButton *withingsButton;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet MenuButton *shopButton;
@property (weak, nonatomic) IBOutlet UILabel *shopButtonLabel;
@property (weak, nonatomic) IBOutlet MenuButton *orderInformationButton;
@property (weak, nonatomic) IBOutlet MenuButton *configureWithings;



@property (weak, nonatomic) IBOutlet UIView *buttonContainer;
@property (weak, nonatomic) IBOutlet MenuButton *orderInformation;
@property (weak, nonatomic) IBOutlet MenuButton *dashboardConfiguration;
@property (weak, nonatomic) IBOutlet MenuButton *tellAFriendButton;

@end


@implementation MenuViewController

- (void)viewDidLoad
{
    self.babyProfileViews = [NSMutableArray new];
    
    
    self.subscriptions = [NewsletterSubscription new];
    
    [super viewDidLoad];
    
    [_wifiButton setEnabled:NO];
    [_withingsButton setEnabled:YES];
    
    //[_wifiRefillButton setEnabled:NO];
    [_nutritionistChatButton setEnabled:NO];
    [_rateBabynessButton setEnabled:NO];
    
    [self icnhLocalizeView];
    [self.view changeSystemFontToApplicationFont];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBabyViewsWithBabies) name:@"UpdateBabyViews" object:nil];
    
    
    //trigger baby load - after that the notification listener does the rest
    if ([[User activeUser].babies count] == 0)
    {
        [self.babySlider showLoadingOverlay];
        [[User activeUser] loadBabies:^(BOOL success)
        {
            [self.babySlider hideLoadingOverlay];
            [self updateBabyViewsWithBabies:[User activeUser].babies];
            [[NotificationCenter sharedCenter] checkNotificationState];
            
        }];
    }
    
    
    
    if ([[kValidCountryCodes lowercaseString] rangeOfString:@"ch"].location != NSNotFound) {
        _newsletterAllButton.hidden = NO;
        _partnerNewsletterSwitch.hidden = NO;
    }
    
    //remove environment string for submission
    //_versionLabel.text = [[NSString alloc] initWithFormat:@"Version %@ (%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], kCountryCode];
#ifdef TARGET_PROD
    //remove environment string for submission
    _versionLabel.text = [[NSString alloc] initWithFormat:@"Version %@ (%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], kCountryCode];
#else
    _versionLabel.text = [[NSString alloc] initWithFormat:@"Version %@ (%@) - %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], kCountryCode, GetServiceEnv()];
#endif
    [_shopButton setSeparatorHidden:NO];
    
    //bchitu Hack(could not change button tile label font size so i added a label)
    [_shopButton addTarget:self action:@selector(changeShopButtonLabelColorToBlack) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragInside];
    [_shopButton addTarget:self action:@selector(changeShopButtonLabelColorToWhite) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchDragOutside|UIControlEventTouchCancel];
    //end hack
    
    //[_orderInformationButton setArrowImage:[UIImage imageNamed:@"icon-order-information"] withSize:CGSizeMake(16, 16)];
//    [_configureWithings setArrowImage:[UIImage imageNamed:@"icon-check"] withSize:CGSizeMake(16, 16)];

    //hide views (BNM-369)
    NSArray* itemsToHide = [NSArray arrayWithObjects:self.dashboardConfiguration,
                                                     self.nutritionistChatButton,
                                                     self.rateBabynessButton,
                                                     self.tellAFriendButton,
                                                     self.orderInformationButton,
#if defined(BABY_NES_FR) || defined(BABY_NES_CH)
                                                     self.faqButton,
#endif//BABY_NES_FR || BABY_NES_CH
#if defined(BABY_NES_US)
                                                     self.wifiInformationButton,
                                                     self.ecoButton,
                                                     self.hygieneButton,
#endif
#if defined(BABY_NES_CH)
                                                     self.ecoButton,
                                                     self.hygieneButton,
#endif
                                                     nil];
    int buttonContainerHDif = 0;
    for (UIView *item in itemsToHide)
    {
        [item setHidden:YES];
        buttonContainerHDif += item.frame.size.height;
        for (UIView *buttonContainerItem in self.buttonContainer.subviews)
        {
            if (buttonContainerItem.center.y > item.center.y)
            {
                CGPoint buttonItemCenter = buttonContainerItem.center;
                buttonItemCenter.y -= item.frame.size.height;
                buttonContainerItem.center = buttonItemCenter;
            }
        }
    }
    
    CGRect buttonContainerFrame = self.buttonContainer.frame;
    buttonContainerFrame.size.height -= buttonContainerHDif;
    self.buttonContainer.frame = buttonContainerFrame;
    //end BNM-369
    
    
}

-(void) changeShopButtonLabelColorToBlack
{
    [_shopButtonLabel setTextColor:[UIColor blackColor]];
}

-(void) changeShopButtonLabelColorToWhite
{
    [_shopButtonLabel setTextColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateBabyViewsWithBabies:[User activeUser].babies];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(babiesChanged:)
                                                 name:BabiesChangedNotification
                                               object:[User activeUser]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(favouriteBabyChanged)
                                                 name:FavouriteBabyChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupWithingsButton)
                                                 name:WithingsChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupMachineConnectionButton)
                                                 name:WiFiStatusChangedNotiffication
                                               object:nil];
    
    
    // if applied earlier, the contentView's width is wrong
    UIView *contentView = [self.scrollView.subviews objectAtIndex:0];
    self.scrollView.contentSize = contentView.bounds.size;

    // if applied as side menu, the view's height is wrong
    CGRect frame = self.view.frame;
    frame.size.height = self.view.superview.frame.size.height;
    self.view.frame = frame;
    
    
    // sync the switch buttons with the current user state
    [self updateNewsletterSubscriptionsFromServer];
    
    [self.babynesNewsletterSwitch addTarget:self action:@selector(babynesNewsletterSubscriptionChanged) forControlEvents:UIControlEventValueChanged];
    [self.partnerNewsletterSwitch addTarget:self action:@selector(partnerNewsletterSubscriptionChanged) forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuReadyNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions
- (IBAction)doAccountInformation {
    [self.delegate performSelector:@selector(doAccountInformation)];
}

- (IBAction)doOrderingInformation {
    [self.delegate performSelector:@selector(doOrderingInformation)];
}

- (IBAction)doAdjustCapsuleStock:(id)sender {
    [self.delegate performSelector:@selector(doAdjustCapsuleStock)];
}

- (IBAction)doWifiSetup {
    [self.delegate performSelector:@selector(doWifiSetup)];
}

- (IBAction)doWifiRefill:(id)sender {
    [self.delegate performSelector:@selector(doWifiRefill)];
}


- (IBAction)doShop:(id)sender {
    [self.delegate performSelector:@selector(doShop)];
}

- (IBAction)doHome:(id)sender {
    [self.delegate performSelector:@selector(doHome)];
}

- (IBAction)doLogout {
    [self.delegate performSelector:@selector(doLogout)];
}

- (IBAction)doCreateBabyProfile {
    [self.delegate performSelector:@selector(doCreateBabyProfile)];
}

- (IBAction)doConfigureWidgets {
    [self.delegate performSelector:@selector(doConfigureWidgets)];
}

- (IBAction)doLegalTerms {
    [self.delegate performSelector:@selector(doLegalTerms)];
}

- (IBAction)doPrivacyPolicy {
    [self.delegate performSelector:@selector(doPrivacyPolicy)];
}

- (IBAction)doWifiInformation:(id)sender {
    [self.delegate performSelector:@selector(doWifiInformation)];
}

- (IBAction)doGeneralTermsOfSale {
    [self.delegate performSelector:@selector(doGeneralTermsOfSale)];
}

- (IBAction)doSanitaryMentions {
     [self.delegate performSelector:@selector(doSanitaryMentions)];
}

- (IBAction)doEcoParticipation {
    [self.delegate performSelector:@selector(doEcoParticipation)];
}

- (IBAction)goWithings:(id)sender {
    [self.delegate performSelector:@selector(goWithings)];
}

- (IBAction)goShopFinder:(id)sender {
    [self.delegate performSelector:@selector(goShopFinder)];
}

- (IBAction)doToggleBabynesNewsletterWithMenu {
    [self toggleBabynesNewsletter];
}

- (IBAction)doTogglePartnerNewsletterWithMenu:(id)sender {
    [self togglePartnerNewletter];
}

- (IBAction)doToggleCapsuleStockWithMenu:(id)sender {
    [self toggleCapsuleStock];
}

- (IBAction)doToggleBottlefeedWithMenu:(id)sender {
    [self toggleBottlefeed];
}

- (IBAction)doOpenReview:(id)sender
{
    NSURL *url = [NSURL URLWithString:iTunesLink];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)doCallUs:(id)sender
{
    [self.delegate performSelector:@selector(goContactUs)];
}



- (IBAction)goToFaQScreen:(id)sender
{
    [self.delegate performSelector:@selector(goToFAQ)];
}

- (IBAction)goToStoreLocator:(id)sender {
    [self.delegate performSelector:@selector(gotToStoreLocator)];
}

- (IBAction)doOpenNotificationCenter:(id)sender
{
    [self.delegate doOpenNotificationCenter];
}



#pragma mark - Baby changed observer

- (void)babiesChanged:(NSNotification *)notification {
    NSArray *newBabies = ((User *)notification.object).babies;
    
    [self updateBabyViewsWithBabies:newBabies];
    
    if([[User activeUser] pregnant] || [[User activeUser].babies count] == 0){
        [_withingsButton setEnabled:NO];
        [_tipsSwitch setEnabled:NO];
        [_tipsButton setEnabled:NO];
        [_stockReminderButton setEnabled:NO];
        [_stockReminderSwitch setEnabled:NO];
    }
    
    if([[User activeUser].babies count] == 0){
        [_withingsButton setEnabled:NO];
        
    }else{
        [_withingsButton setEnabled:YES];
    }
    //Ionel temp enable always
    [_withingsButton setEnabled:YES];
    NSLog(@"Withings enabled: %d", _withingsButton.enabled);
}

- (void) favouriteBabyChanged
{
    [self setupWithingsButton];
}

- (void) setupWithingsButton
{
    if ([[[User activeUser] favouriteBaby] isWithingsEnabled])
    {
        [self.configureWithings setArrowImage:[UIImage imageNamed:@"icon-check"] withSize:CGSizeMake(16, 16)];
    }
    else
    {
        [self.configureWithings setArrowImage:[UIImage imageNamed:@"arrow-white"] withSize:CGSizeZero];
    }
}

- (void) setupMachineConnectionButton
{
    if ([[User activeUser] wifiStatus] == WIFI_STATUS_NO_WIFI)
    {
        [self.wifiRefillButton setEnabled:NO];
        [self.wifiRefillButton setShowArrow:NO];
    }
    else
    {
        [self.wifiRefillButton setEnabled:YES];
        [self.wifiRefillButton setShowArrow:YES];
    }
}

- (void)updateBabyViewsWithBabies {
    [self updateBabyViewsWithBabies:_babies];
}

- (void)updateBabyViewsWithBabies:(NSArray *)babies
{
    self.babies = babies;
    //clear the baby views
    [self.babyProfileViews removeAllObjects];
    
    
    [self.babySlider reloadInputViews];
    
    for (Baby *b in self.babies)
    {
        b.cachedImage = nil;
        BabyMenuViewController *v =  [BabyMenuViewController babyMenuViewControllerWithBaby:b];
        v.highlighted = [[User activeUser].favouriteBaby isEqual:b];
        [self.babyProfileViews addObject:v];
        v.delegate = self;
    }

    self.babySlider.babyProfileViews = self.babyProfileViews;
    [self.babySlider resetPageControl];
    [self.babySlider.swipeView reloadData];
    
    if(!self.babySlider.isLoading)
    {
        CGRect babySliderFrame = self.babySlider.frame;
        
        if ([self.babyProfileViews count] != 0)
        {
            [self.babySlider.swipeView setUserInteractionEnabled:YES];
            babySliderFrame = CGRectMake(0, 0, 320, 200);
        }
        else
        {
            babySliderFrame.size.height = (2*self.addBabyButton.frame.origin.y) + self.addBabyButton.frame.size.height; //2*..for padding
            [self.babySlider.swipeView setUserInteractionEnabled:NO];
        }
        
        self.babySlider.frame = babySliderFrame;
        
    }
    
    
    [self performSelector:@selector(resizeScrollView) withObject:nil afterDelay:1];

}

- (void)updateFavouriteBaby {
    for (BabyMenuViewController *v  in self.babyProfileViews) {
        v.highlighted = [[User activeUser].favouriteBaby isEqual:v.baby];
    }
    
    [self.delegate doUpdateFavouriteBaby];
}

- (void)resizeScrollView {
    [self.layoutContainer sizeToFit];
    self.scrollView.contentSize = self.layoutContainer.bounds.size;
}

#pragma mark - BabyMenuViewDelegate

- (void)editBaby:(Baby *)baby {
    [self.delegate performSelector:@selector(doEditBabyProfile:) withObject:baby];
}

-(void)babyClicked:(Baby *)baby {
    [User activeUser].favouriteBaby = baby;
    [self updateFavouriteBaby];
}

#pragma mark - SwitchControl listeners

- (void)babynesNewsletterSubscriptionChanged {
    if(_isNewsletter){
        self.babynesNewsletterSwitch.on = NO;
        _isNewsletter = NO;
    }else{
        self.babynesNewsletterSwitch.on = YES;
        _isNewsletter = YES;
    }
    [User activeUser].babyNesNewsletterSubscribed = _isNewsletter;
}

- (void)partnerNewsletterSubscriptionChanged {
    if(_isNewsletterPartner){
        self.partnerNewsletterSwitch.on = NO;
        _isNewsletterPartner = NO;
    }else{
        self.partnerNewsletterSwitch.on = YES;
        _isNewsletterPartner = YES;
    }
    [User activeUser].partnerNewsletterSubscribed = _isNewsletterPartner;
}

#pragma mark - Helpers
- (void)toggleBabynesNewsletter {
    if(_isNewsletter){
        self.babynesNewsletterSwitch.on = NO;
        _isNewsletter = NO;
    }else{
        self.babynesNewsletterSwitch.on = YES;
        _isNewsletter = YES;
    }
    [User activeUser].babyNesNewsletterSubscribed = _isNewsletter;
}

- (void)togglePartnerNewletter {
    if(_isNewsletterPartner){
        self.partnerNewsletterSwitch.on = NO;
        _isNewsletterPartner = NO;
    }else{
        self.partnerNewsletterSwitch.on = YES;
        _isNewsletterPartner = YES;
    }
    [User activeUser].partnerNewsletterSubscribed = _isNewsletterPartner;
}

- (void)toggleCapsuleStock {
    if(_isStockReminderSet){
        self.stockReminderSwitch.on = NO;
        _isStockReminderSet = NO;
    }else{
        self.stockReminderSwitch.on = YES;
        _isStockReminderSet = YES;
    }
}
- (IBAction)capsuleStock:(id)sender {
    if(_isStockReminderSet){
        self.stockReminderSwitch.on = NO;
        _isStockReminderSet = NO;
    }else{
        self.stockReminderSwitch.on = YES;
        _isStockReminderSet = YES;
    }
}


- (void)toggleBottlefeed {
    if(_isCoachNotificationSet){
        self.bottlefeedPushNotificationSwitch.on = NO;
        _isCoachNotificationSet = NO;
    }else{
        self.bottlefeedPushNotificationSwitch.on = YES;
        _isCoachNotificationSet = YES;
    }
}
- (IBAction)coachTips:(id)sender {
    if(_isCoachNotificationSet){
        self.bottlefeedPushNotificationSwitch.on = NO;
        _isCoachNotificationSet = NO;
    }else{
        self.bottlefeedPushNotificationSwitch.on = YES;
        _isCoachNotificationSet = YES;
    }

}

- (void) updateNewsletterSubscriptionsFromServer
{
    NewsletterSubscriptionDataService *service = [NewsletterSubscriptionDataService new];
    [service loadNewsletterSubscriptions:YES completion:^(NewsletterSubscription *newsletter) {
        if (newsletter) {
            if(newsletter.nestle == 1){
                self.babynesNewsletterSwitch.on = YES;
                _isNewsletter = YES;
            }else{
                self.babynesNewsletterSwitch.on = NO;
                _isNewsletter = NO;
            }
            
            if(newsletter.partner == 1){
                self.partnerNewsletterSwitch.on = YES;
                _isNewsletterPartner = YES;
            }else{
                self.partnerNewsletterSwitch.on = NO;
                _isNewsletterPartner = NO;
            }
        }else{
            self.babynesNewsletterSwitch.on = NO;
            self.partnerNewsletterSwitch.on = NO;
            _isNewsletter = NO;
            _isNewsletterPartner = NO;
        }
    }];
}

//- (void) updatePushNotificationSubscriptionsFromServer
//{
//    PushNotificationSubscriptionDataService *service = [PushNotificationSubscriptionDataService new];
//    service.baby = [User activeUser].favouriteBaby;
//    [service loadPushNotificationSubscriptions:YES completion:^(PushNotificationSubscription *pushnotifications) {
//        _isTips = [[User activeUser] getTipNotification];
//        self.tipsSwitch.on = _isTips;
//        if (pushnotifications) {
//            if(pushnotifications.chatMessage == 1){
//                self.bottlefeedPushNotificationSwitch.on = YES;
//                _isCoachNotificationSet = YES;
//            }else{
//                self.bottlefeedPushNotificationSwitch.on = NO;
//                _isCoachNotificationSet = NO;
//            }
//            
//            if(pushnotifications.shoppingReminder == 1){
//                self.stockReminderSwitch.on = YES;
//                _isStockReminderSet = YES;
//            }else{
//                self.stockReminderSwitch.on = NO;
//                _isStockReminderSet = NO;
//            }
//        }else{
//            self.bottlefeedPushNotificationSwitch.on = NO;
//            self.stockReminderSwitch.on = NO;
//            _isStockReminderSet = NO;
//            _isCoachNotificationSet = NO;
//        }
//    }];
//    
//    _isTips = [[User activeUser] getTipNotification];
//    self.tipsSwitch.on = _isTips;
//}
//
//- (void)updatePushNotificationSubscriptionStatus
//{
//    for (Baby *b in self.babies)
//    {
//        PushNotificationSubscription *pns = [PushNotificationSubscription new];
//        pns.chatMessage = _isCoachNotificationSet;
//        pns.shoppingReminder = _isStockReminderSet;
//        pns.baby = b;
//        [pns create:^(BOOL success) {
//        if(success){
//
//        }else{
//            
//        }
//        }];
//    }
//}

@end
