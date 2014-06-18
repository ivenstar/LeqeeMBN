//
//  PushNotificationSettings.m
//  Flatland
//
//  Created by Bogdan Chitu on 27/02/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "PushNotificationSettingsDataService.h"
#import "RESTService.h"
#import "WsApiList.h"

@implementation PushNotificationSettingsDataService


NSString* const kpushBottleAletrsKey = @"BOTTLEFEED";
NSString* const kpushShopingReminderKey = @"SHOPPINGREMINDER";
NSString* const kpushChatMessageKey = @"CHATMESSAGE";

+(void) loadSettingsWithCompletion:(void (^)(NSDictionary *settings))completion
{
    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_getNotificationsStatus object:nil] completion:^(RESTResponse *response)
         {
             if(response.statusCode == 200)
             {
                 BOOL responseBottleFeed = [StringFromJSONObject(response.object[kpushBottleAletrsKey]) boolValue];
                 BOOL responseShoppingReminder = [StringFromJSONObject(response.object[kpushShopingReminderKey]) boolValue];
                 BOOL responseChatMessage = [StringFromJSONObject(response.object[kpushChatMessageKey]) boolValue];
                 
                 NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:responseBottleFeed],kpushBottleAletrsKey,
                                       [NSNumber numberWithBool:responseShoppingReminder],kpushShopingReminderKey,
                                       [NSNumber numberWithBool:responseChatMessage],kpushChatMessageKey,
                                       nil];
                 
                 NSLog(@"NotificationAndAlertsDataService Response NotificationsStatus :%@",settings);
                 completion(settings);
             }
             else
             {
                 completion(nil);
             }
         }];
}

+ (void)updateSettings:(NSDictionary*) settings withCompletion:(void (^)(BOOL success))completion;
{
    //the folowing is in order to avoid nil obj and to send the whole dict to server
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:[[settings objectForKey:kpushBottleAletrsKey] boolValue]], kpushBottleAletrsKey,
                                                                     [NSNumber numberWithBool:[[settings objectForKey:kpushShopingReminderKey] boolValue]], kpushShopingReminderKey,
                                                                     [NSNumber numberWithBool:[[settings objectForKey:kpushChatMessageKey] boolValue]], kpushChatMessageKey,
                                                                      nil];
    
    [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_updateNotificationsStatus object:data] completion:^(RESTResponse *response)
     {
         NSLog(@"NotificationAndAlertsDataService updateSettings Response success: %i",response.success);
         completion(response.success);
     }];
}

@end
