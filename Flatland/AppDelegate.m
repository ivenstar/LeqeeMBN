//
//  AppDelegate.m
//  Flatland
//
//  Created by Stefan Aust on 13.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import "FlatAppearance.h"
#import "NotificationCenter.h"
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import "User.h"


@implementation AppDelegate
@synthesize WifiSetupConfigureVisible;
@synthesize returnFromBG;
NSData *_deviceToken;
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    _deviceToken = deviceToken;
    [[NotificationCenter sharedCenter] setDeviceToken:deviceToken];
    NSLog(@"Registered push with token:: %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Register failed: %@", [error localizedDescription]);
    _deviceToken = [@"7bb8d508e32df651c6c239439737dbd40a88d2461ad2ac1e5dbe49ecea5ccc67" dataUsingEncoding:NSUTF8StringEncoding];
    [[NotificationCenter sharedCenter] setDeviceToken:_deviceToken];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    //[GAI sharedInstance].optOut = FALSE;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    // Initialize Google Analytics with a 120-second dispatch interval. There is a
    // tradeoff between battery usage and timely dispatch.
    [GAI sharedInstance].dispatchInterval = 30;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    //NSLog(kTrackingId);
    self.tracker = [[GAI sharedInstance] trackerWithName:@"Test" trackingId:GetGoogleTrackingId()];
    [FlatAppearance setup];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    returnFromBG = FALSE;
    WifiSetupConfigureVisible = FALSE;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    //handle PUSH notifications if PUSH was received when app was closed
    NSDictionary* userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    
        //[[[UIApplication sharedApplication] delegate] application:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
        //   [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationsChangedNotification" object:nil];
    [self performSelector:@selector(handleOfflinePush:) withObject:userInfo afterDelay:1.0];

    
    return YES;
}

- (void)handleOfflinePush:(id)userInfo{
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    if( [apsInfo objectForKey:@"alert"] != NULL)
    {
        
        [[[UIApplication sharedApplication] delegate] application:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationsChangedNotification" object:nil];
        
    }
 
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[NotificationCenter sharedCenter] handleReceivedLocalNotification:notification];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[NotificationCenter sharedCenter] handleReceivedRemoteNotification:userInfo];
    NSLog(@"Received push!");
    //NSLog(@"%@", userInfo);
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    if([[User activeUser] email]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MustUpdateBabiesNotification" object:nil];
    }
    if(!_isAlreadyStarted)
    {
        _isAlreadyStarted = true;
    }
    else
    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"WidgetsHadChangedNotification" object:nil];
    }
    
    //Wifi Setup resume after user returns from Settings
    //returnFromBG = TRUE;
    if (WifiSetupConfigureVisible)
    {
        NSLog(@"intors");
        returnFromBG = TRUE;
    }
    else NSLog(@"neintors");
}


@end
