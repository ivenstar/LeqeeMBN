//
//  NotificationCenter.h
//  Flatland
//
//  Created by Magdalena Kamrowska on 29.04.13.
//  Copyright (c) 2013 Proximity Technology GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recommendation.h"
#import "Stock.h"

typedef enum {
    NotificationTypeOrderRecommendation = 0,
    NotificationTypeChat,
    NotificationTypeTips,
    NotificationTypeBottleFeed,
    NotificationTypeLowStock,
    NotificationTypeUnknown
} NotificationType;

@interface Notification : NSObject <NSCoding, UIAlertViewDelegate>

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *babyID;
@property (nonatomic) NotificationType notificationType;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *capsuleType;
@property (nonatomic, copy) NSNumber *quantity;
@property (nonatomic, copy) NSString *pushText;


- (id)initWithRemoteNotifitcation:(NSDictionary *)notification;

- (id)initWithLocalNotifitcation:(UILocalNotification *)notification;

@end

@interface NotificationCenter : NSObject
@property (nonatomic, copy) NSMutableArray *notificationBuffer;
@property (nonatomic) int badgeCount;
@property (nonatomic, copy) NSData *deviceToken;
@property (nonatomic) Recommendation *recommendation;
@property (nonatomic) Stock *stock;
@property (nonatomic, copy) Notification *alertNotification;
+ (NotificationCenter *)sharedCenter;

- (void)checkNotificationState;

- (void)handleReceivedLocalNotification:(UILocalNotification *)thisNotification;

- (void)handleReceivedRemoteNotification:(NSDictionary *)thisNotification;

- (void)clearBadgeCount;

- (void)decreaseBadgeCountBy:(int)count;

- (void)increaseBadgeCountBy:(int)count;
- (void)handlePush:(Notification *)push;

@end
