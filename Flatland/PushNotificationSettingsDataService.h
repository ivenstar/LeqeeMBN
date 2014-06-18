//
//  PushNotificationSettings.h
//  Flatland
//
//  Created by Bogdan Chitu on 27/02/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString* const kpushBottleAletrsKey;
extern NSString* const kpushShopingReminderKey;
extern NSString* const kpushChatMessageKey;


@interface PushNotificationSettingsDataService : NSObject
{
}

+ (void)loadSettingsWithCompletion:(void (^)(NSDictionary *settings))completion;
+ (void)updateSettings:(NSDictionary*) settings withCompletion:(void (^)(BOOL success))completion;


@end
