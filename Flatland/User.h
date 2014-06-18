//
//  User.h
//  Flatland
//
//  Created by Stefan Aust on 22.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "LoginData.h"
#import "RegistrationData.h"
#import "Baby.h"
#import "Order.h"
#import "Address.h"
#import "DeliveryMode.h"
#import "PaymentCard.h"
#import "PaymentData.h"
#import "NotificationCenter.h"
#import "InAppNotificationSettings.h"
#import "WifiStatus.h"

/// Notification sent when array of babies has been changed
extern NSString *const BabiesChangedNotification;

/// Notification sent when the favourite baby has been changed (or loaded)
extern NSString *const FavouriteBabyChangedNotification;

/// Notification when any persistent property (widget config) changed
extern NSString *const UserChangedNotification;

// Notification when wifi machine connection status is changed
extern NSString *const WiFiStatusChangedNotiffication;


@interface User : NSObject

@property (nonatomic, assign) BOOL mustUpdate;

/// the user's email address which doubles as identity
@property (nonatomic, copy) NSString *email;

/// the global access token which shall be passed with every request
@property (nonatomic, copy) NSString *accessToken;

/// the user's list of babies
@property (nonatomic, copy) NSArray *babies;

/// the favourite/prefered baby that is used for all the home screen actions..
@property (nonatomic, strong) Baby *favouriteBaby;

/// Get/Set a list of widget configuration
@property (nonatomic, copy) NSArray *widgetConfiguration;

// the user's saved tips
@property (nonatomic, copy) NSArray *favoriteTips;

// the user's unread notifications
@property (nonatomic, copy) NSArray *notifications;

// the user's unread notifications
@property (nonatomic, copy) NSArray *notificationsRead;

//the user's unread push notifications
@property (nonatomic, copy) NSArray *notificationsPushUnread;

// whether the User is subscribed to the babynes newsletter or not
@property (nonatomic, assign) BOOL babyNesNewsletterSubscribed;

// whether the User is subscribed to the parner newsletter or not
@property (nonatomic, assign) BOOL partnerNewsletterSubscribed;

// whether the User has already seen the tutorial view or not.
@property (nonatomic, assign) BOOL hasSeenTutorialView;

//the number of wifirefill prompts
@property (nonatomic, readonly) int nbWifiRefillPrompts;

//the number of setup prompts
@property (nonatomic, readonly) int nbWifiSetupPrompts;

// whether the User has already started the wifi replenishment or not.
@property (nonatomic, assign) BOOL hasStartedWifiRefill;

// whether the User has already started the wifi setup or not.
@property (nonatomic, readwrite ,setter = setWifiSetupStarted:) BOOL hasStartedWifiSetup;

@property (nonatomic, retain) InAppNotificationSettings* inAppNotificationSettings;

@property (nonatomic, assign) BOOL pregnant;

@property (nonatomic, copy) NSString *withingsUrl;

#ifdef TIMELINE_SAVE_SEEN_FRIENDS_HEADER
// whether the friends header should be shown in timeline
@property (nonatomic, readwrite) BOOL shouldHideFriendsHeader;
#endif//TIMELINE_SAVE_SEEN_FRIENDS_HEADER

// the user's wifi configuration state
@property (nonatomic, readonly) WifiStatus wifiStatus;
@property (nonatomic, copy) NSString *wifiOrderOption;

/// returns the active account or nil if not logged in
+ (User *)activeUser;

/// set a new active user
+ (void)setActiveUser:(NSString *)email accessToken:(NSString *)accessToken;

- (void)addReadNotification:(NSNumber *)ageWeek;

- (BOOL)addTip:(NSNumber *)tipWeek;
- (void)removeTip:(NSNumber *)tipWeek;
- (void)addUnreadNotification:(Notification *)notification;
- (void)addUnreadNotificationOrderRec:(Notification *)notification;
- (void)removeUnreadNotification:(Notification *)notification;

- (void)loadWifiStatusCompletion:(void(^)(BOOL success))completion;
- (void)setWifiStatus:(WifiStatus)wifiStatus completion:(void(^)(BOOL success))completion;
// get wifi payment url
- (void)getWifiPaymentURLCompletion:(void(^)(BOOL success, NSString *paymentURL))completion;
- (void)loadWifiOptions;

- (void)addBaby:(Baby *)baby;
- (void)removeBaby:(Baby *)baby;
- (void)updateBaby:(Baby *)baby;

- (void)save;

+ (void)login:(LoginData *)loginData completion:(void (^)(BOOL success))completion;

+ (void)register:(RegistrationData *)registrationData completion:(void (^)(BOOL success, NSArray *error))completion;

+ (void)recoverPasswordForEmail:(NSString *)email completion:(void (^)(BOOL success))completion;

/// logout the user
- (void)logout;
- (void)doLogoutAPI:(void (^)(BOOL success))completion;

/// YES if the account is logged in otherwise no
- (BOOL)isLoggedIn;

/// loads baby descriptions with capsule recommendations and feeding preferences,
/// calling the completion block once the data is available
- (void)loadBabies:(void (^)(BOOL success))completion;

#pragma mark - addresses

/// load delivery addresses and call the completion block either with an array of Address instances or nil
- (void)loadDeliveryAddresses:(void(^)(NSArray *addresses))completion;

/// load billing addresses and call the completion block either with an array of Address instances or nil
- (void)loadBillingAddresses:(void(^)(NSArray *addresses))completion;

/// create a new delivery address
- (void)addDeliveryAddress:(Address *)address completion:(void(^)(BOOL success))completion;

/// create a new billing address
- (void)addBillingAddress:(Address *)address completion:(void(^)(BOOL success))completion;

/// update an existing delivery address
- (void)updateDeliveryAddress:(Address *)address completion:(void(^)(BOOL success))completion;

/// update an existing billing address
- (void)updateBillingAddress:(Address *)address completion:(void(^)(BOOL success))completion;

/// delete an existing delivery address
- (void)deleteDeliveryAddress:(Address *)address completion:(void(^)(BOOL success))completion;

/// delete an existing billing address
- (void)deleteBillingAddress:(Address *)address completion:(void(^)(BOOL success))completion;

// get withings mobile website
- (void)getWithingsUrl:(Baby *)baby completion:(void(^)(NSString *))completion;

//increase nb wifi refill prompts by 1 and saves(without norifying obesrvers)
- (void) increaseNbWifiRefillPrompts;

//increase nb wifi setup prompts by 1 and saves(without norifying obesrvers)
- (void) increaseNbWifiSetupPrompts;

#pragma mark - subscription

/// subscribe for an email newsletter regarding the balance
- (void)subscribeForBalanceInformation:(NSString *)email completion:(void(^)(BOOL success))completion;

#pragma mark - orders

/// get/set the ID of the preferred delivery adddress which is stored in the NSUserDefaults
@property (nonatomic, copy) NSString *preferredDeliveryAddressID;

/// get/set the ID of the preferred billing adddress which is stored in the NSUserDefaults
@property (nonatomic, copy) NSString *preferredBillingAddressID;

/// get/set the ID of the preferred delivery mode which is stored in the NSUserDefaults
@property (nonatomic, copy) NSString *preferredDeliveryModeID;

/// get/set the ID of the preferred credit card which is stored in the NSUserDefaults
@property (nonatomic, copy) NSString *preferredPaymentCardID;

/// get/set whether the user wants express checkout which is stored in the NSUserDefaults
@property (nonatomic, assign) BOOL expressCheckout;

/// posts the shared order, expecting an orderNo and a paymentURL as result
- (void)postOrder:(void(^)(NSError *error, PaymentData *result))completion;

#pragma mark - personal information

- (void)loadPersonalInformation:(void(^)(Address *personalAddress))completion;

// update the personal information, email and password might be nil, which means they have not been changed
- (void)updatePersonalInformation:(Address *)address oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword email:(NSString *)email completion:(void(^)(BOOL success, NSString *errorMessage))completion;


- (void)loadPaymentCards:(void(^)(NSArray *paymentCards))completion;
- (void)deletePaymentCard:(PaymentCard *)paymentCard completion:(void(^)(BOOL success))completion;

@end
