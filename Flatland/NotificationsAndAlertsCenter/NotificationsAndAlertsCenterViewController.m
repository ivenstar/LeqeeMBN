//
//  NotificationsAndAlertsCenterViewController.m
//  Flatland
//
//  Created by Bogdan Chitu on 26/02/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "NotificationsAndAlertsCenterViewController.h"
#import "Globals.h"
#import "WaitIndicator.h"
#import "OverlaySaveView.h"
#import "User.h"
#import "PushNotificationSettingsDataService.h"
#include "AlertView.h"

#define NAC_CONTAINER_CORNER_RADIUS 8

@interface NotificationsAndAlertsCenterViewController ()
{
    BOOL _saving;
}

@property (weak, nonatomic) IBOutlet UIView *mainView;

//containers
@property (weak, nonatomic) IBOutlet UIView *bottleAlertsContainer;
@property (weak, nonatomic) IBOutlet UIView *shoppingReminderContainer;
@property (weak, nonatomic) IBOutlet UIView *lowCapsuleStockContainer;
@property (weak, nonatomic) IBOutlet UIView *tipsContainer;

//switches
@property (weak, nonatomic) IBOutlet UISwitch *bottlePushSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *shopingReminderPushSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *lowCapsuleInAppPushSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *tipsSwitch;

//labels
@property (weak, nonatomic) IBOutlet UILabel *pushBottleDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *pushShoppingReminderLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowCapsuleStockNotConfiguredLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowCapsuleStockLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsDescriprionLavel;


@end

@implementation NotificationsAndAlertsCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //TODO sepup switches,model
    [self icnhLocalizeView];
    
    //add gesture recognizer to doMachineNotConfigured
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doMachineNotConfigured)];
    [self.lowCapsuleStockNotConfiguredLabel addGestureRecognizer:gr];
    [self.lowCapsuleStockNotConfiguredLabel setUserInteractionEnabled:YES];
    
   //format the text in doMachineNotConfigured
    NSRange rangeofColoredString = NSRangeFromString(T(@"%notifficationsAndAlerts.LowCapsuleStockDescriptionNotConfiguredRange"));
    NSMutableAttributedString *machineNotConfiguredString = [[NSMutableAttributedString alloc] initWithString:T(@"%notifficationsAndAlerts.LowCapsuleStockDescriptionNotConfigured")];
    [machineNotConfiguredString addAttribute:NSForegroundColorAttributeName value:[UIColor BabyNesLightPurpleColor] range:rangeofColoredString];
    [self.lowCapsuleStockNotConfiguredLabel setAttributedText:machineNotConfiguredString];
    [self.lowCapsuleStockNotConfiguredLabel setFont:[UIFont fontWithName:self.lowCapsuleStockNotConfiguredLabel.font.fontName size:10
                                                     ]]; //(does not work from xib..)
    
#ifdef BABY_NES_US
    rangeofColoredString = NSRangeFromString(T(@"%notifficationsAndAlerts.BottleAlertsDescriptionRange"));
    NSMutableAttributedString *bottleAlertsString = [[NSMutableAttributedString alloc] initWithString:T(@"%notifficationsAndAlerts.BottleAlertsDescription")];
    [bottleAlertsString addAttribute:NSForegroundColorAttributeName value:[UIColor BabyNesLightPurpleColor] range:rangeofColoredString];
    [self.pushBottleDescriptionLabel setAttributedText:bottleAlertsString];
    [self.pushBottleDescriptionLabel setFont:[UIFont fontWithName:self.pushBottleDescriptionLabel.font.fontName size:10
                                                     ]]; //(does not work from xib..)
    
    rangeofColoredString = NSRangeFromString(T(@"%notifficationsAndAlerts.ShoppingReminderDescriptionRange"));
    NSMutableAttributedString *shoppingReminderString = [[NSMutableAttributedString alloc] initWithString:T(@"%notifficationsAndAlerts.ShoppingReminderDescription")];
    [shoppingReminderString addAttribute:NSForegroundColorAttributeName value:[UIColor BabyNesLightPurpleColor] range:rangeofColoredString];
    [self.pushShoppingReminderLabel setAttributedText:shoppingReminderString];
    [self.pushShoppingReminderLabel setFont:[UIFont fontWithName:self.pushShoppingReminderLabel.font.fontName size:10
                                              ]]; //(does not work from xib..)
#endif //BABY_NES_US
    
    
    
    //start request and add loading overlay
    [self.mainView setHidden:YES];
    [WaitIndicator waitOnView:self.view];
    
    //load local
    [self.lowCapsuleInAppPushSwitch setOn:[[[User activeUser] inAppNotificationSettings] stock]];
    [self.tipsSwitch setOn:[[[User activeUser] inAppNotificationSettings] tips]];
    
    //get server data
    [PushNotificationSettingsDataService loadSettingsWithCompletion:^(NSDictionary *settings)
     {
         if (nil != settings)
         {
             [self.mainView setHidden:NO];
             [self.bottlePushSwitch setOn:[[settings objectForKey:kpushBottleAletrsKey] boolValue]];
             [self.shopingReminderPushSwitch setOn:[[settings objectForKey:kpushShopingReminderKey] boolValue]];
         }
         else
         {
             [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:^(NSInteger buttonIndex) {
                 [self.navigationController popViewControllerAnimated:YES];
             }] show];
             //TOOD Alert View With Actual error(also needs server side impl and localization)
         }
         
         //Stop waiting
         [self.view stopWaiting];
    }];
    
    _saving = false;
    
    //test PUSH
    //[self performSelector:@selector(pushTest) withObject:nil afterDelay:9.0];

}

- (void)pushTest {
    NSLog(@"Push test");
    
    NSURL *pushFile = [[NSBundle mainBundle] URLForResource:@"shoppush"
                                              withExtension:@"test"
                                               subdirectory:nil
                                               localization:nil];
    if (pushFile == nil) return;
    NSData *b = [NSData dataWithContentsOfURL:pushFile];
    if (b == nil) return;
    NSDictionary *testNotification = [NSJSONSerialization
                                      JSONObjectWithData:b
                                      options:0
                                      error:nil];
    [[[UIApplication sharedApplication] delegate]
     application:[UIApplication sharedApplication]
     didReceiveRemoteNotification:testNotification];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.bottleAlertsContainer setCornerRadius:NAC_CONTAINER_CORNER_RADIUS];
    [self.shoppingReminderContainer setCornerRadius:NAC_CONTAINER_CORNER_RADIUS];
    [self.lowCapsuleStockContainer setCornerRadius:NAC_CONTAINER_CORNER_RADIUS];
    [self.tipsContainer setCornerRadius:NAC_CONTAINER_CORNER_RADIUS];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actions

- (void) doMachineNotConfigured
{
    //TODO - Action for the label
}

- (IBAction)doSave:(id)sender
{
    if (_saving)
    {
        return; //anti-button spam
    }
    _saving = true;
    
    //TODO,see if there were any modifications and then save
    
    NSDictionary *newSaveData = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:self.bottlePushSwitch.isOn],kpushBottleAletrsKey,
                                                                            [NSNumber numberWithBool:self.shopingReminderPushSwitch.isOn],kpushShopingReminderKey,
                                                                            nil];
    
    [PushNotificationSettingsDataService updateSettings:newSaveData withCompletion:^(BOOL success)
    {
       if (success)
        {
            //save the local settings
            User *activeUser = [User activeUser];
            [[activeUser inAppNotificationSettings] setStock:self.lowCapsuleInAppPushSwitch.isOn];
            [[activeUser inAppNotificationSettings] setTips:self.tipsSwitch.isOn];
            
            [activeUser save];
            
            //check for notiffications
            [[NotificationCenter sharedCenter] checkNotificationState];
            
            //and close after showing success
            [OverlaySaveView showOverlayWithMessage:T(@"%general.modified") afterDelay:2 performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        else
        {
            [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:^(NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
            }] show];
        }
    }];
}

#pragma mark

@end
