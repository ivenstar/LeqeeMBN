//
//  NotificationCenter.m
//  Flatland
//
//  Created by Magdalena Kamrowska on 29.04.13.
//  Copyright (c) 2013 Proximity Technology GmbH. All rights reserved.
//

#import "NotificationCenter.h"
#import "User.h"
#import "Baby.h"
#import "Tips.h"
#import <AudioToolbox/AudioToolbox.h>
#import "OrientationNavigationController.h"
#import "HomeViewController.h"
#import "WidgetViewController.h"
#define kSecondsInWeek 604800

@implementation Notification

- (id)initWithLocalNotifitcation:(UILocalNotification *)notification {
    self = [super init];
    if(self) {
        _notificationType = (NotificationType)[[[notification userInfo] objectForKey:@"Type"] integerValue];
        _babyID = [[notification userInfo] objectForKey:@"Baby-ID"];
        _ID = [[notification userInfo] objectForKey:@"tipForWeek"];
        _message = [notification alertBody];
    }
    return self;
}

- (id)initWithRemoteNotifitcation:(NSDictionary *)notification {
    self = [super init];
    if(self) {
        id aps = [notification objectForKey:@"aps"];
        NSString *key = [aps objectForKey:@"loc-key"];
        _pushText = [aps objectForKey:@"alert"];
        if([key isEqualToString:@"BOTTLEFEED"]) {
            _notificationType = NotificationTypeBottleFeed;
            NSDictionary *additions = [notification objectForKey:@"additions"];
            _babyID = [additions objectForKey:@"baby"];
            _capsuleType = [additions objectForKey:@"capsuleType"];
            _message = T(@"%push.notif.bottleprepared");
        } else if([key isEqualToString:@"CHATMESSAGE"]) {
            _notificationType = NotificationTypeChat;
            NSDictionary *additions = [notification objectForKey:@"additions"];
            _babyID = [additions objectForKey:@"baby"];
            _user = [additions objectForKey:@"user"];
        } else if([key isEqualToString:@"SHOPPINGREMINDER"]) {
            _notificationType = NotificationTypeOrderRecommendation;
            NSDictionary *additions = [notification objectForKey:@"additions"];
            _babyID = [additions objectForKey:@"baby"];
            _user = [additions objectForKey:@"user"];
            _capsuleType = [additions objectForKey:@"type"];
            _quantity = [additions objectForKey:@"stock"];
            _message = T(@"%push.notif.orderrecommendation");
        } else if ([key isEqualToString:@"LOWSTOCK"]) {
            _notificationType = NotificationTypeLowStock;
            _message = T(@"%push.notif.lowstock");
            
        }
        else {
            _notificationType = NotificationTypeUnknown;
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_notificationType forKey:@"notificationType"];
    [aCoder encodeObject:_babyID forKey:@"babyID"];
    [aCoder encodeObject:_ID forKey:@"ID"];
    [aCoder encodeObject:_message forKey:@"message"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        _notificationType = [aDecoder decodeIntForKey:@"notificationType"];
        _babyID = [aDecoder decodeObjectForKey:@"babyID"];
        _ID = [aDecoder decodeObjectForKey:@"ID"];
        _message = [aDecoder decodeObjectForKey:@"message"];
    }
    return self;
}

@end

@implementation NotificationCenter

@synthesize notificationBuffer;

static NotificationCenter *sharedCenter = nil;

+ (NotificationCenter *)sharedCenter {
    if(!sharedCenter) {
        sharedCenter = [NotificationCenter new];
        sharedCenter.badgeCount = 0;
    }
    return sharedCenter;
}

- (void)checkNotificationState {

    if ([[[User activeUser] inAppNotificationSettings] stock])
    {
        // Check recommandations
        [Recommendation get:^(Recommendation *recommendation) {
            self.recommendation = recommendation;
            if(self.recommendation.needsReplenishment)
            {
                [Stock get:^(Stock *stock) {
                    _stock = stock;
                    NSDate *date = [NSDate date];
                    NSMutableArray *notifications = [NSMutableArray new];
                    NSDictionary *messageInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",NotificationTypeOrderRecommendation], @"Type", [User activeUser].email, @"User", nil, @"Recommandations", nil];
                    NSString *message = [NSString stringWithFormat:T(@"%notification.capsule.stock"), _stock.capsulesLeft];
                    [notifications addObject:[self createNotificationOn:date text:message action:nil sound:@"warning" launchImage:nil andInfo:messageInfo]];
                    
                    if(notifications.count > 0 ) {
                        [[UIApplication sharedApplication] setScheduledLocalNotifications:notifications];
                    }
                }];
            }
        }];
    }
    
    if ([[[User activeUser] inAppNotificationSettings] tips])
    {
        int lastWeek = [[((Tip*)[[[Tips sharedTips] tipsArray] lastObject]) week] integerValue];
        NSMutableArray *notifications = [NSMutableArray new];
        NSMutableArray *babies = [NSMutableArray new];
        NSDate *now = [NSDate date];
        
        for (Baby *baby in [[User activeUser] babies]) {
            NSTimeInterval ageInSeconds = now.timeIntervalSince1970 - [[baby birthday] timeIntervalSince1970];
            NSNumber *ageInWeeks = [[NSNumber alloc] initWithInt:(int)floor(ageInSeconds / kSecondsInWeek)];
            if(ageInWeeks.integerValue < lastWeek ) {
                [babies addObject:baby];
            }
        }
        
        for (Baby *baby in babies)
        {
            NSTimeInterval ageInSeconds = now.timeIntervalSince1970 - [[baby birthday] timeIntervalSince1970];
            NSNumber *ageInWeeks = [[NSNumber alloc] initWithInt:(int)floor(ageInSeconds / kSecondsInWeek)];
            if (![[User activeUser] notificationsRead] || [[[User activeUser] notificationsRead] indexOfObject:ageInWeeks] == NSNotFound)
            {
                ageInWeeks = [NSNumber numberWithInt:(ageInWeeks.integerValue + 0)];
                NSDictionary *messageInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",NotificationTypeTips], @"Type", baby.ID, @"Baby-ID", [User activeUser].email, @"User", ageInWeeks, @"tipForWeek", nil];
                
                if([[Tips sharedTips] tipForWeek:ageInWeeks])
                {
                    NSDate *date = [NSDate date];
                    [notifications addObject:[self createNotificationOn:date text:[[Tips sharedTips] tipForWeek:ageInWeeks].title action:nil sound:@"notification" launchImage:nil andInfo:messageInfo]];
                    if(notifications.count > 0 )
                    {
                        [[UIApplication sharedApplication] setScheduledLocalNotifications:notifications];
                    }
                }
            }
        }
    }
    
    //add unread Push notification Order recommendation
    //check if this notification is enabled in settings - temp TRUE
    if (TRUE){
        if ([[User activeUser] notificationsPushUnread]){
            //NSMutableArray *notifications = [NSMutableArray new];
            for (int i=0; i< [[[User activeUser] notificationsPushUnread] count]; i++){
                Notification *n = [[[User activeUser] notificationsPushUnread] objectAtIndex:i];
                [[User activeUser] addUnreadNotification:n];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationsChangedNotification" object:nil];

            }
            
        }
    

}

 - (UILocalNotification *)createNotificationOn:(NSDate *)fireDate text:(NSString *)alertText action:(NSString *)alertAction sound:(NSString *)soundFileName launchImage:(NSString *)launchImage andInfo:(NSDictionary *)userInfo {
     UILocalNotification *localNotification = [UILocalNotification new];
     localNotification.fireDate = fireDate;
     localNotification.timeZone = [NSTimeZone defaultTimeZone];
     localNotification.alertBody = alertText;
     localNotification.alertAction = alertAction;
     
     if(soundFileName == nil) {
         localNotification.soundName = UILocalNotificationDefaultSoundName;
     } else {
         localNotification.soundName = soundFileName;
     }
     
     localNotification.alertLaunchImage = launchImage;
     localNotification.applicationIconBadgeNumber = 0;
     localNotification.userInfo = userInfo;
     
     return localNotification;
 }

- (void)handleReceivedLocalNotification:(UILocalNotification *)thisNotification {
    Notification *notification = [[Notification alloc] initWithLocalNotifitcation:thisNotification];
    if([[[User activeUser] email] isEqualToString:@""]) {
        [notificationBuffer addObject:notification];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserLoggedIn:) name:@"AccountChangedNotification" object:nil];
    } else {
        [[User activeUser] addUnreadNotification:notification];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationsChangedNotification" object:nil];
    }
    [self decreaseBadgeCountBy:1];
}

- (void)handleReceivedRemoteNotification:(NSDictionary *)thisNotification {
    Notification *notification = [[Notification alloc] initWithRemoteNotifitcation:thisNotification];
    _alertNotification = notification;
    if([notification notificationType] != NotificationTypeUnknown) {
        if([[[User activeUser] email] isEqualToString:@""]) {
            [notificationBuffer addObject:notification];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserLoggedIn:) name:@"AccountChangedNotification" object:nil];
        } else {
            if (notification.notificationType == NotificationTypeOrderRecommendation){
                [[User activeUser] addUnreadNotificationOrderRec:notification];
            }
            else{
                [[User activeUser] addUnreadNotification:notification];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationsChangedNotification" object:nil];
            [self handlePush:notification];
        }
    }
    [self increaseBadgeCountBy:1];
}

- (void)handlePush:(Notification *)push {
    //NotificationTypeCapsuleReminder = 0,
    //NotificationTypeChat,
    //NotificationTypeTips,
    //NotificationTypeBottleFeed,
    //TODO: handle situation when bottlefeed is not for current baby
    UIAlertView *alert = [UIAlertView alloc];
    alert.tag = [push notificationType];
    switch ([push notificationType]) {
        case NotificationTypeOrderRecommendation:
        {
            NSString *body = T(@"%push.alert.orderrecommendation");
            [[alert initWithTitle:nil message:body delegate:self cancelButtonTitle:T(@"%push.alert.dismiss") otherButtonTitles:T(@"%push.alert.view"), nil] show];
        }
            break;
        case NotificationTypeBottleFeed:
        {
            NSString *babyName;
            for (Baby *b in [User activeUser].babies) {
                if (([b.ID isEqualToString:_alertNotification.babyID]) || ([b.name isEqualToString:_alertNotification.babyID]))
                    babyName = b.name;
            }
            NSString *body = [NSString stringWithFormat:T(@"%push.alert.bottleprepared"), [push capsuleType], babyName];
            [[alert initWithTitle:nil message:body delegate:self cancelButtonTitle:T(@"%push.alert.dismiss") otherButtonTitles:T(@"%push.alert.view"), nil] show];
        }
            break;
        case NotificationTypeLowStock:
        {
            NSString *body = T(@"%push.alert.lowstock");
            [[alert initWithTitle:nil message:body delegate:self cancelButtonTitle:T(@"%push.alert.dismiss") otherButtonTitles:T(@"%push.alert.view"), nil] show];
        }
            break;
        default:
            break;
    }
    //play default iOS audio sound for push
    AudioServicesPlaySystemSound(1002);
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
        switch (alertView.tag) {
            case NotificationTypeOrderRecommendation:
            {
                //GOTO shop/order recommendation screen
                UIStoryboard *storyboardShop = [UIStoryboard storyboardWithName:@"Shop" bundle:nil];
                UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
                OrientationNavigationController *vc = (OrientationNavigationController*)window.rootViewController;
                //pop to root to have a clean hierarchy
                [vc popToRootViewControllerAnimated:NO];
                HomeViewController *home = [[vc viewControllers] objectAtIndex:0];
                //close menu if it was open when the PUSH was received
                [home performSelector:@selector(closeMenu) withObject:nil afterDelay:0.1];

                
                //TODO: check if an Alert dialog is present on screen, so we should close it
                
                //check if a modal in present so that we should dismiss it
                UIViewController *v= [vc presentedViewController];
                if (v != nil) {
                    [vc dismissViewControllerAnimated:YES completion:^{
                        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
                        //[vc pushViewController:[storyboardShop instantiateViewControllerWithIdentifier:@"CapsuleRecommendation"] animated:YES];}];
                        [self performSelector:@selector(pushOrderRecommendationScreen:) withObject:vc afterDelay:0.1];
                    }];
                }
                else [vc pushViewController:[storyboardShop instantiateViewControllerWithIdentifier:@"CapsuleRecommendation"] animated:YES];
            }
                break;
            case NotificationTypeBottleFeed:
                //GOTO Home
            {
                Baby *selBaby = nil;
                for (Baby *baby in [User activeUser].babies) {
                    if (([baby.ID isEqualToString:_alertNotification.babyID]) || ([baby.name isEqualToString:_alertNotification.babyID])) {
                        selBaby = baby;
                    }
                }
                if (selBaby != nil){
                    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
                    OrientationNavigationController *vc = (OrientationNavigationController*)window.rootViewController;
                    [vc popToRootViewControllerAnimated:YES];
                    HomeViewController *home = [[vc viewControllers] objectAtIndex:0];
                    //close menu if it was open when the PUSH was received
                    [home performSelector:@selector(closeMenu) withObject:nil afterDelay:0.1];
                    
                    //check if a modal in present so that we should dismiss it
                    UIViewController *v= [vc presentedViewController];
                    if (v != nil) {
                        [vc dismissViewControllerAnimated:YES completion:^{
                            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
                            [[home menuViewController] babyClicked:selBaby];
                        }];
                    }
                    else [[home menuViewController] babyClicked:selBaby];


                    //force update widgets if baby is the favorite baby
                    if (selBaby == [User activeUser].favouriteBaby){
                        
                        for (WidgetViewController *wc in [home widgetControllers])
                        {
                            wc.baby = selBaby;
                        }
                    }
                }
            }
                break;
            case NotificationTypeLowStock:
            {
                //GOTO shop/order recommendation screen
                UIStoryboard *storyboardShop = [UIStoryboard storyboardWithName:@"Shop" bundle:nil];
                UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
                OrientationNavigationController *vc = (OrientationNavigationController*)window.rootViewController;
                //pop to root to have a clean hierarchy
                [vc popToRootViewControllerAnimated:NO];
                HomeViewController *home = [[vc viewControllers] objectAtIndex:0];
                //close menu if it was open when the PUSH was received
                [home performSelector:@selector(closeMenu) withObject:nil afterDelay:0.1];
                
                
                //TODO: check if an Alert dialog is present on screen, so we should close it
                
                //check if a modal in present so that we should dismiss it
                UIViewController *v= [vc presentedViewController];
                if (v != nil) {
                    [vc dismissViewControllerAnimated:YES completion:^{
                        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
                        //[vc pushViewController:[storyboardShop instantiateViewControllerWithIdentifier:@"CapsuleRecommendation"] animated:YES];}];
                        [vc pushViewController:[storyboardShop instantiateViewControllerWithIdentifier:@"CapsulesStock"] animated:YES];
                    }];
                }
                else [vc pushViewController:[storyboardShop instantiateViewControllerWithIdentifier:@"CapsulesStock"] animated:YES];

            }
                break;
            default:
                break;
        }
}

- (void)pushOrderRecommendationScreen:(id)sender {
    UIStoryboard *storyboardShop = [UIStoryboard storyboardWithName:@"Shop" bundle:nil];
    [sender pushViewController:[storyboardShop instantiateViewControllerWithIdentifier:@"CapsuleRecommendation"] animated:YES];
    //[sender closeMenu];
}

- (void)decreaseBadgeCountBy:(int)count {
    self.badgeCount -= count;
	if(self.badgeCount < 0) {
        self.badgeCount = 0;
    }
	[UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
}
#
- (void)clearBadgeCount {
    self.badgeCount = 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
}

- (void)increaseBadgeCountBy:(int)count {
    self.badgeCount += count;
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
}

- (void)UserLoggedIn:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for(Notification *n in notificationBuffer) {
        [[User activeUser] addUnreadNotification:n];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationsChangedNotification" object:nil];
}

@end
