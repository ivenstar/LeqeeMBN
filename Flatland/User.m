//
//  User.m
//  Flatland
//
//  Created by Stefan Aust on 22.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "User.h"
#import "RESTService.h"
#import "WeightWidgetViewController.h"
#import "BottlefeedingWidgetViewController.h"
#import "BreastfeedingWidgetViewController.h"
#import "TimelineWidgetViewController.h"

NSString *const BabiesChangedNotification = @"BabiesChangedNotification";
NSString *const FavouriteBabyChangedNotification = @"FavouriteBabyChangedNotification";
NSString *const UserChangedNotification = @"UserChangedNotification";
NSString *const WiFiStatusChangedNotiffication = @"WiFiStatusChangedNotiffication";

static NSString *const kUserDefaultsUser = @"user";
static NSString *const kUserDefaultsUserID = @"userEmail";

@implementation User {
    NSString *_favouriteBabyID;
    BOOL _babiesLoaded;
    NSArray *_widgetConfiguration;
}

static User *user = nil;

+ (NSString*) keyForUserEmail: (NSString*) userEmail
{
    return [[NSString alloc] initWithFormat:@"%@%@",kUserDefaultsUser,userEmail];
}

+ (User *)activeUser
{
    if (!user)
    {
        //get default user email
        NSString *userEmail = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserID];
        if (userEmail)
        {
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[User keyForUserEmail:userEmail]];
            if (data)
            {
                user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
        }
        else
        {
            //for backwards comp
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUser];
            if (data)
            {
                user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                //set the email
                [[NSUserDefaults standardUserDefaults] setObject:user.email forKey:kUserDefaultsUserID];
                //save to new user format
                [[NSUserDefaults standardUserDefaults] setObject:user forKey:[User keyForUserEmail:user.email]];
                //delete previous data
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsUser];
                //sync
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        
        if(nil == user)
        {
            user = [[User alloc] init];
        }
    }
    NSLog(@"[USER ACTIVEUSER] EMAIL=%@ ACCESSTOKEN=%@",user.email,user.accessToken);
    return user;
}

+ (void)setActiveUser:(NSString *)email accessToken:(NSString *)accessToken
{
    //try to read from user defaults
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[User keyForUserEmail:email]];
    if (data)
    {
        user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    if (nil == user)
    {
        user = [[User alloc] init];
    }
    
    user.email = email;
    user.accessToken = accessToken;
    
    if (!user.inAppNotificationSettings)
    {
        user.inAppNotificationSettings = [[InAppNotificationSettings alloc] init];
    }
    
    [user notifyObserversAndSaveState];
}

#pragma mark - 

- (id) init
{
    if (self = [super init])
    {
        self.email = @"";
        self.accessToken = @"";
        self.wifiStatus = WIFI_STATUS_UNKNOWN;//TODO see what other vars need init
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        _accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
        _email = [aDecoder decodeObjectForKey:@"email"];
        _favouriteBabyID = [aDecoder decodeObjectForKey:@"favouriteBabyID"];
        _favoriteTips = [aDecoder decodeObjectForKey:@"favoriteTips"];
        _widgetConfiguration = [aDecoder decodeObjectForKey:@"widgetConfiguration"];
        _notificationsRead = [aDecoder decodeObjectForKey:@"notificationsRead"];
        _notificationsPushUnread = [aDecoder decodeObjectForKey:@"notificationsPushUnread"];
        _hasSeenTutorialView = [aDecoder decodeBoolForKey:@"hasSeenTutorialview"];
        _inAppNotificationSettings = [aDecoder decodeObjectForKey:@"inAppNotificationSettings"];
        _nbWifiRefillPrompts = [aDecoder decodeIntForKey:@"nbWifiRefillPrompts"];
        _nbWifiSetupPrompts = [aDecoder decodeIntForKey:@"nbWifiSetupPrompts"];
        _hasStartedWifiRefill = [aDecoder decodeBoolForKey:@"hasStartedWifiRefill"];
		_hasStartedWifiSetup = [aDecoder decodeBoolForKey:@"wifiSetupStarted"];
#ifdef TIMELINE_SAVE_SEEN_FRIENDS_HEADER
        _shouldHideFriendsHeader = [aDecoder decodeBoolForKey:@"_shouldHideFriendsHeader"];
#endif //TIMELINE_SAVE_SEEN_FRIENDS_HEADER
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:_favouriteBabyID forKey:@"favouriteBabyID"];
    [aCoder encodeObject:_favoriteTips forKey:@"favoriteTips"];
    [aCoder encodeObject:_widgetConfiguration forKey:@"widgetConfiguration"];
    [aCoder encodeObject:_notificationsRead forKey:@"notificationsRead"];
    [aCoder encodeObject:_notificationsPushUnread forKey:@"notificationsPushUnread"];
    [aCoder encodeBool:_hasSeenTutorialView forKey:@"hasSeenTutorialview"];
    [aCoder encodeObject:_inAppNotificationSettings forKey:@"inAppNotificationSettings"];
    [aCoder encodeInt:_nbWifiRefillPrompts forKey: @"nbWifiRefillPrompts"];
    [aCoder encodeInt:_nbWifiSetupPrompts forKey:@"nbWifiSetupPrompts"];
    [aCoder encodeBool:_hasStartedWifiRefill forKey:@"hasStartedWifiRefill"];
	[aCoder encodeBool:_hasStartedWifiSetup forKey:@"wifiSetupStarted"];
#ifdef TIMELINE_SAVE_SEEN_FRIENDS_HEADER
    [aCoder encodeBool:_shouldHideFriendsHeader forKey:@"_shouldHideFriendsHeader"];
#endif //TIMELINE_SAVE_SEEN_FRIENDS_HEADER
}

/// notify observers and save the current state of the user
- (void)notifyObserversAndSaveState
{
    [self saveWithoutNotifying];
    //notify
    [[NSNotificationCenter defaultCenter] postNotificationName:UserChangedNotification object:self];
}
    
-(void) saveWithoutNotifying
{
    //save the email to nsuserdefaults
    [[NSUserDefaults standardUserDefaults] setObject:user.email forKey:kUserDefaultsUserID];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey: [User keyForUserEmail:user.email]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) setWifiStatus:(WifiStatus)wifiStatus
{
    _wifiStatus = wifiStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:WiFiStatusChangedNotiffication object:nil];
}

- (void) increaseNbWifiRefillPrompts
{
    _nbWifiRefillPrompts++;
    //sync without notification
    [self saveWithoutNotifying];
}

- (void) setWifiSetupStarted:(BOOL)wifiSetupStarted
{
    _hasStartedWifiSetup = wifiSetupStarted;
    [self saveWithoutNotifying];
}
    
- (void) increaseNbWifiSetupPrompts
{
    _nbWifiSetupPrompts++;
    //sync without notification
    [self saveWithoutNotifying];
}

- (BOOL)isLoggedIn {
    _notifications = nil;
    return self.accessToken != nil && ![self.accessToken isEqualToString:@""];
}

- (void)doLogoutAPI:(void (^)(BOOL))completion{
    [[RESTService sharedService]
     queueRequest:[RESTRequest getURL:WS_logout]
     completion:^(RESTResponse *response) {}];
}

- (void)logout
{
    //call logout API before resetting user, so that the request headers contain the user token
    [self doLogoutAPI:^(BOOL success){}];
    ///
    user = [[User alloc] init];
    [self notifyObserversAndSaveState];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuReadyNotification" object:nil];
}

- (void)save {
    [self notifyObserversAndSaveState];
}

#pragma mark - Timeline

#ifdef TIMELINE_SAVE_SEEN_FRIENDS_HEADER
- (void) setShouldHideFriendsHeader:(BOOL)shouldHideFriendsHeader
{
    _shouldHideFriendsHeader = shouldHideFriendsHeader;
    [self saveWithoutNotifying];
}
#endif //TIMELINE_SAVE_SEEN_FRIENDS_HEADER

#pragma mark - tutorial overlay view

- (void)setHasSeenTutorialView:(BOOL)hasSeenTutorialView {
    _hasSeenTutorialView = hasSeenTutorialView;
    [self notifyObserversAndSaveState];
}

- (void) setHasStartedWifiRefill:(BOOL)hasStartedWifiRefill
{
    _hasStartedWifiRefill = hasStartedWifiRefill;
    [self saveWithoutNotifying];
}

#pragma mark - favorite tips

- (BOOL)addTip:(NSNumber *)tipWeek {
    if(_favoriteTips == nil) {
        _favoriteTips = [NSArray new];
    }
    if([_favoriteTips indexOfObject:tipWeek] == NSNotFound) {
        NSMutableArray *tips = [_favoriteTips mutableCopy];
        [tips addObject:tipWeek];
        _favoriteTips = tips;
        [self notifyObserversAndSaveState];
        return YES;
    } else {
        return NO;
    }
}

- (void)removeTip:(NSNumber *)tipWeek {
    NSMutableArray *tips = [_favoriteTips mutableCopy];
    [tips removeObject:tipWeek];
    _favoriteTips = tips;
    [self notifyObserversAndSaveState];
}

- (void)deleteNotofications {
    _notifications = nil;
}

#pragma mark - unread notifications

- (void)addUnreadNotificationOrderRec:(Notification *)notification {
    if(_notifications == nil)
    {
        _notifications = [NSArray new];
    }
    
    NSMutableArray *n = [_notifications mutableCopy];
    [n addObject:notification];
    _notifications = n;
    if (notification.notificationType == NotificationTypeOrderRecommendation) {
        if (_notificationsPushUnread == nil)
            _notificationsPushUnread = [NSArray new];
        NSMutableArray *n = [_notificationsPushUnread mutableCopy];
        [n addObject:notification];
        _notificationsPushUnread = n;

    }
    [self notifyObserversAndSaveState];
}

- (void)addUnreadNotification:(Notification *)notification {
    if(_notifications == nil)
    {
        _notifications = [NSArray new];
    }
    
    NSMutableArray *n = [_notifications mutableCopy];
    [n addObject:notification];
    _notifications = n;
    [self notifyObserversAndSaveState];
}

- (void)removeUnreadNotification:(Notification *)notification {
    NSMutableArray *notifications = [_notifications mutableCopy];
    [notifications removeObject:notification];
    _notifications = notifications;
    if (notification.notificationType == NotificationTypeOrderRecommendation){
        NSMutableArray *n = [_notificationsPushUnread mutableCopy];
        [n removeObject:notification];
        _notificationsPushUnread = n;
    }
        
    [self notifyObserversAndSaveState];
}

- (void)addReadNotification:(NSNumber *)ageWeek {
    if(_notificationsRead == nil) {
        _notificationsRead = [NSArray new];
    }
    NSMutableArray *n = [_notificationsRead mutableCopy];
    NSNumber *age = ageWeek;
    [n addObject:age];
    _notificationsRead = n;
    [self notifyObserversAndSaveState];
}

#pragma mark - widget configuration

- (void)setWidgetConfiguration:(NSArray *)widgetConfiguration {

    NSMutableArray* sortedConfig = [[NSMutableArray alloc] init];
    
    for (int i=0;i<[User defaultWidgetConfiguration].count;i++)
    {
        for (int j=0;j<widgetConfiguration.count;j++)
        {
            if ([[[User defaultWidgetConfiguration] objectAtIndex:i] isEqualToString:[widgetConfiguration objectAtIndex:j]])
            {
                [sortedConfig addObject:[widgetConfiguration objectAtIndex:j]];
            }
        }
    }
    
    if ([_widgetConfiguration isEqualToArray:sortedConfig]) {
        return;
    }
    
    _widgetConfiguration = sortedConfig;
    
    if(_widgetConfiguration){
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_widgetConfiguration] forKey:_email];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self notifyObserversAndSaveState];
}

static NSArray* _defaultWidgetConfiguration;

+ (NSArray*) defaultWidgetConfiguration
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultWidgetConfiguration = [NSArray arrayWithObjects:
#ifdef WIP_TIMELINE
                                      [TimelineWidgetViewController widgetIdentifier],
#endif //WIP_TIMELINE
                                      [WeightWidgetViewController widgetIdentifier],
                                      [BreastfeedingWidgetViewController widgetIdentifier],
                                      [BottlefeedingWidgetViewController widgetIdentifier],
                                      nil];
    });
    
    return _defaultWidgetConfiguration;
}

- (NSArray *)widgetConfiguration {
    if(!_widgetConfiguration) {
       _widgetConfiguration = [User defaultWidgetConfiguration];
    }
    return _widgetConfiguration;
}


#pragma mark - babies

- (Baby *)favouriteBaby {
    if(!_babiesLoaded){
        [self loadBabies:^(BOOL success) {
            if(success){
                
            }
        }];
    }
    if ( _favouriteBabyID) {
        for (Baby *baby in self.babies) {
            if ([baby.ID isEqualToString:_favouriteBabyID]) {
                return baby;
            }
        }
        // only overwrite baby if we have loaded babies
        if (_babiesLoaded) {
            _favouriteBabyID = nil;
            [self notifyObserversAndSaveState];
        }
    }
    return [self.babies count] > 0 ? [self.babies objectAtIndex:0] : nil;
}

- (void)setFavouriteBaby:(Baby *)favouriteBaby {
    //Ionel remove isEqual condition, force baby refresh even if selected current active baby
    //if ([self.babies containsObject:favouriteBaby] && ![favouriteBaby.ID isEqualToString:_favouriteBabyID])
    if ([self.babies containsObject:favouriteBaby])
    {
        _favouriteBabyID = favouriteBaby.ID;
        [self notifyObserversAndSaveState];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:FavouriteBabyChangedNotification object:self];
    }
}

- (void)addBaby:(Baby *)baby
{
    Baby *favoriteaBaby = self.favouriteBaby;
    
    NSMutableArray *babies = [self.babies mutableCopy];
    [babies addObject:baby];
    self.babies = babies;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BabiesChangedNotification object:self];
    if (![favoriteaBaby isEqual:self.favouriteBaby])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:FavouriteBabyChangedNotification object:self];
    }
}

- (void)removeBaby:(Baby *)baby {
    Baby *favoriteaBaby = self.favouriteBaby;

    NSMutableArray *babies = [self.babies mutableCopy];
    [babies removeObject:baby];
    self.babies = babies;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BabiesChangedNotification object:self];
    if (![favoriteaBaby isEqual:self.favouriteBaby])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:FavouriteBabyChangedNotification object:self];
    }
}

- (void)updateBaby:(Baby *)baby {
    if ([baby isEqual:self.favouriteBaby]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:FavouriteBabyChangedNotification object:self];
    }
        //[[NSNotificationCenter defaultCenter] postNotificationName:BabiesChangedNotification object:self];
    [self performSelector:@selector(postBabyNotification) withObject:self afterDelay:3];
}

- (void)postBabyNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:BabiesChangedNotification object:self];
}

#pragma mark - login & registration

/// Login with email and password.
///
/// Calls the completion block with success or error state (and swallows any error message).
/// Saves the access token assigned by the server for future requests.

+ (void)login:(LoginData *)loginData completion:(void (^)(BOOL success))completion {
    [[RESTService sharedService]
     queueRequest:[RESTRequest postURL:WS_login object:[loginData data]]
     completion:^(RESTResponse *response) {
         if (response.success) {
             NSLog(@"login response success = = %@ data as %@ object as %@",response,[response data],[response object]);
             // there should be a token
             NSString *token = ObjectFromJSONValue(response.object[@"token"]);
             
             //save active account
             [User setActiveUser:loginData.email accessToken:token];
             
             NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[[User activeUser] email]];
             if(data)
             {
                 [User activeUser].widgetConfiguration = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"WidgetsHadChangedNotification" object:nil];
                 [User activeUser].hasSeenTutorialView = YES;
                 NSLog(@"login receive DATA=[%@] unarchive=[%@]",data, [NSKeyedUnarchiver unarchiveObjectWithData:data]);
                 //NSASCIIStringEncoding
                 //NSUTF8StringEncoding[[NSString alloc] initWithData:data  encoding:1],
                 //NSUnicodeStringEncoding
                 //NSStringEncoding
             }else{
                 NSLog(@"login receive DATA=EMPTY");
             }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"menuReadyNotification" object:nil];
             
             completion(YES);
         } else {
             completion(NO);
         }
     }];
}

+ (void)register:(RegistrationData *)registrationData completion:(void (^)(BOOL success, NSArray *error))completion {
    [[RESTService sharedService]
     queueRequest:[RESTRequest postURL:WS_register object:[registrationData data]]
     completion:^(RESTResponse *response) {
         NSLog(@"SINRI DEBUG User Register getData=%@",[registrationData data]);
         if (response.success) {
             LoginData *loginData = [LoginData new];
             loginData.email = registrationData.email;
             loginData.password = registrationData.password;
             [User login:loginData completion:^(BOOL success) {
                 NSLog(@"SINRI DEBUG User Register to complete loginData email=%@ password=%@",loginData.email,loginData.password);
                 completion(success, nil);
             }];
         } else {
             NSLog(@"SINRI DEBUG REGISTER NOT SUCCESS message=%@",[response.object valueForKey:@"message"]);
             NSArray *messages = [[response.object valueForKey:@"message"] componentsSeparatedByString:@","];
             if(messages.count == 0) {
                 NSLog(@"SINRI DEBUG User Register No message");
                 completion(NO, nil);
             } else {
                 NSLog(@"SINRI DEBUG User Register message=%@",messages.debugDescription);
                 completion(NO, messages);
             }
         }
     }];
}

+ (void)recoverPasswordForEmail:(NSString *)email completion:(void (^)(BOOL))completion {
    id object = [NSDictionary dictionaryWithObject:email forKey:@"email"];
    
    [[RESTService sharedService]
     queueRequest:[RESTRequest postURL:WS_loginRecover object:object]
     completion:^(RESTResponse *response) {
         if (response.success) {
             completion(YES);
         } else {
             completion(NO);
         }
     }];
}

- (void)loadBabies:(void (^)(BOOL success))completion {
    if (self.babies) {
        completion(YES);
    } else {
        [self queueRequest:[RESTRequest getURL:WS_babies]
                completion:^(RESTResponse *response) {
                    if (!response.error) { // cannot test for success because of the way the JSON is returned
                        NSArray *jsonBabies = ArrayFromJSONObject(response.object);
                        NSMutableArray *babies = [[NSMutableArray alloc] initWithCapacity:[jsonBabies count]];
                        for (id jsonBaby in response.object) {
                            [babies addObject:[[Baby alloc] initWithJSONObject:jsonBaby]];
                        }
                        self.babies = babies;
                        _babiesLoaded = YES;
                        [[NSNotificationCenter defaultCenter] postNotificationName:BabiesChangedNotification object:self];
                        [[NSNotificationCenter defaultCenter] postNotificationName:FavouriteBabyChangedNotification object:self];
                        completion(YES);
                    } else {
                        completion(NO);
                    }
                }];
    }
}

#pragma mark - addresses

/// load delivery addresses and call the completion block either with an array of Address instances or nil
- (void)loadDeliveryAddresses:(void(^)(NSArray *addresses))completion {
    [self queueRequest:[RESTRequest getURL:WS_addressesGet]
            completion:^(RESTResponse *response) {
                if (response.success) {
                    NSMutableArray *addresses = [NSMutableArray array];
                    for (id JSONValue in response.object) {
                        [addresses addObject:[[Address alloc] initWithJSONValue:JSONValue]];
                    }
                    completion(addresses);
                } else {
                    NSLog(@"Error while loading delivery addresses: %@", response.error);
                    completion(nil);
                }
            }];
}

/// load billing addresses and call the completion block either with an array of Address instances or nil
- (void)loadBillingAddresses:(void(^)(NSArray *addresses))completion {
    [self queueRequest:[RESTRequest getURL:WS_addressesBillingGet]
            completion:^(RESTResponse *response) {
                if (response.success) {
                    NSMutableArray *addresses = [NSMutableArray array];
                    for (id JSONValue in response.object) {
                        [addresses addObject:[[Address alloc] initWithJSONValue:JSONValue]];
                    }
                    completion(addresses);
                } else {
                    NSLog(@"Error while loading billing addresses: %@", response.error);
                    completion(nil);
                }
            }];
}

/// create a new delivery address
- (void)addDeliveryAddress:(Address *)address completion:(void(^)(BOOL success))completion {
    [self queueRequest:[RESTRequest postURL:WS_addressesUpdate object:[address JSONValue]]
            completion:^(RESTResponse *response) {
                if (response.success) {
                    address.ID = ObjectFromJSONValue(response.object[@"id"]);
                    completion(YES);
                } else {
                    NSLog(@"Error while creating a delivery address: %@", response.error);
                    completion(NO);
                }
            }];
}

/// create a new billing address
- (void)addBillingAddress:(Address *)address completion:(void(^)(BOOL success))completion {
    [self queueRequest:[RESTRequest postURL:WS_addressBillingCreate object:[address JSONValue]]
            completion:^(RESTResponse *response) {
                if (response.success) {
                    address.ID = ObjectFromJSONValue(response.object[@"id"]);
                    completion(YES);
                } else {
                    NSLog(@"Error while creating a billing address: %@", response.error);
                    completion(NO);
                }
            }];
}

/// update an existing delivery address
- (void)updateDeliveryAddress:(Address *)address completion:(void(^)(BOOL success))completion {
    NSString *URL = [NSString stringWithFormat:WS_addressShippingUpdate, address.ID];
    [self queueRequest:[RESTRequest postURL:URL object:[address JSONValue]]
            completion:^(RESTResponse *response) {
                completion(response.success);
            }];
}

/// update an existing billing address
- (void)updateBillingAddress:(Address *)address completion:(void(^)(BOOL success))completion {
    NSString *URL = [NSString stringWithFormat:WS_addressBillingUpdate, address.ID];
    [self queueRequest:[RESTRequest postURL:URL object:[address JSONValue]]
            completion:^(RESTResponse *response) {
                completion(response.success);
            }];
}

/// delete an existing delivery address
- (void)deleteDeliveryAddress:(Address *)address completion:(void(^)(BOOL success))completion {
    NSString *URL = [NSString stringWithFormat:WS_addressDelete, address.ID];
    [self queueRequest:[RESTRequest getURL:URL]
            completion:^(RESTResponse *response) {
                completion(response.success);
            }];
}

/// delete an existing billing address
- (void)deleteBillingAddress:(Address *)address completion:(void(^)(BOOL success))completion {
    NSString *URL = [NSString stringWithFormat:WS_addressDelete, address.ID];
    [self queueRequest:[RESTRequest getURL:URL]
            completion:^(RESTResponse *response) {
                completion(response.success);
            }];
}

#pragma mark - order

/// posts the shared order, expecting an orderNo and a paymentURL as result
- (void)postOrder:(void(^)(NSError *error, PaymentData *result))completion {
    [self queueRequest:[RESTRequest postURL:WS_ordersCreate object:[[Order sharedOrder] JSONValue]]
            completion:^(RESTResponse *response) {
                if (response.success)
                {
                    completion(nil, [[PaymentData alloc] initWithJSONValue:response.object]);
                }
                else
                {
                    if (nil != response.error)
                    {
                        NSLog(@"Error while posting the order: %@", response.error);
                        completion(response.error, nil);
                    }
                    else
                    {
                        NSString* message = ObjectFromJSONValue(response.object[@"message"]);
                        
                        NSMutableDictionary *errorDetails = [[NSMutableDictionary alloc] initWithObjectsAndKeys:message,NSLocalizedDescriptionKey, nil];
                        NSError* error = [NSError errorWithDomain:@"ServerError" code:0 userInfo:errorDetails];
                        completion(error, nil);
                    }
                }
            }];
}

#pragma mark - withings
- (void)getWithingsUrl:(Baby *)baby completion:(void(^)(NSString *))completion {
    NSString *url = [[NSString alloc] initWithFormat:WS_withingsAuthUrl, baby.ID];
    [self queueRequest:[RESTRequest getURL:url]
            completion:^(RESTResponse *response) {
                if(response.success){
                    NSString *responseString = [[NSString alloc] initWithFormat:@"%@", ObjectFromJSONValue(response.object[@"Url"])];
                    completion(responseString);
                }else{
                    completion(@"");
                }
            }];
}

#pragma mark - subscription

/// subscribe for an email newsletter regarding the balance
- (void)subscribeForBalanceInformation:(NSString *)email completion:(void(^)(BOOL success))completion {
    [self queueRequest:[RESTRequest postURL:@"/subscribe-for-balance" object:@{@"email": email}]
            completion:^(RESTResponse *response) {
                completion(response.success);
            }];
}

- (void)setBabyNesNewsletterSubscribed:(BOOL)babyNesNewsletterSubscribed {
    _babyNesNewsletterSubscribed = babyNesNewsletterSubscribed;
    if(babyNesNewsletterSubscribed){
        [self queueRequest:[RESTRequest getURL:WS_newsletterSubscribe]
                completion:^(RESTResponse *response) {
                    if (response.success)
                    {
                    
                    }
                    else
                    {
                        
                    }
                }];
    }else{
        [self queueRequest:[RESTRequest getURL:WS_newsletterUnsubscribe]
                completion:^(RESTResponse *response) {
                    if (response.success)
                    {
                        
                    }
                    else
                    {
                        
                    }
                }];
    }
}

- (void)setPartnerNewsletterSubscribed:(BOOL)partnerNewsletterSubscribed {
    _partnerNewsletterSubscribed = partnerNewsletterSubscribed;
    if(partnerNewsletterSubscribed){
        [self queueRequest:[RESTRequest getURL:WS_newsletterSubscribePartners]
                completion:^(RESTResponse *response) {
                    if (response.success) {
                    } else {
                    }
                }];
    }else{
        [self queueRequest:[RESTRequest getURL:WS_newsletterUnsubscribePartners]
                completion:^(RESTResponse *response) {
                    if (response.success) {
                    } else {
                    }
                }];
    }
}

#pragma mark - orders

#define PreferredDeliveryAddressIDKey @"preferredDeliveryAddressID"
#define PreferredBillingAddressIDKey @"preferredBillingAddressID"
#define PreferredDeliveryModeIDKey @"preferredDeliveryModeID"
#define PreferredPaymentCardKey @"preferredPaymentCardID"
#define ExpressCheckoutKey @"expressCheckout"
#define PregnantKey @"pregnant"

- (NSString *)preferredDeliveryAddressID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:PreferredDeliveryAddressIDKey];
}

- (void)setPreferredDeliveryAddressID:(NSString *)preferredDeliveryAddressID {
    [[NSUserDefaults standardUserDefaults] setObject:preferredDeliveryAddressID forKey:PreferredDeliveryAddressIDKey];
}

- (NSString *)preferredBillingAddressID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:PreferredBillingAddressIDKey];
}

- (void)setPreferredBillingAddressID:(NSString *)preferredBillingAddressID {
    [[NSUserDefaults standardUserDefaults] setObject:preferredBillingAddressID forKey:PreferredBillingAddressIDKey];
}

- (NSString *)preferredDeliveryModeID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:PreferredDeliveryModeIDKey];
}

- (void)setPreferredDeliveryModeID:(NSString *)preferredDeliveryModeID {
    [[NSUserDefaults standardUserDefaults] setObject:preferredDeliveryModeID forKey:PreferredDeliveryModeIDKey];
}

- (NSString *)preferredPaymentCardID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:PreferredPaymentCardKey];
}

- (void)setPreferredPaymentCardID:(NSString *)preferredPaymentCardID {
    [[NSUserDefaults standardUserDefaults] setObject:preferredPaymentCardID forKey:PreferredPaymentCardKey];
}
- (BOOL)pregnant {
    return [[NSUserDefaults standardUserDefaults] boolForKey:PregnantKey];
}
- (void)setPregnant:(BOOL)pregnant {
    [[NSUserDefaults standardUserDefaults] setBool:pregnant forKey:PregnantKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)expressCheckout {
    return [[NSUserDefaults standardUserDefaults] boolForKey:ExpressCheckoutKey];
}

- (void)setExpressCheckout:(BOOL)expressCheckout {
    [[NSUserDefaults standardUserDefaults] setBool:expressCheckout forKey:ExpressCheckoutKey];
}

- (void)loadPersonalInformation:(void (^)(Address *))completion {
    [self queueRequest:[RESTRequest getURL:WS_getUser]
            completion:^(RESTResponse *response) {
                if (response.statusCode == 200) {
                    [[User activeUser] setPregnant:[response.object[@"pregnant"] boolValue]];
                    completion([[Address alloc] initWithNonCamelCaseJSONValue:response.object]);
                } else {
                    NSLog(@"Error while loading personal information: %@", response.error);
                    completion(nil);
                }
            }];
}

- (void)updatePersonalInformation:(Address *)address oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword email:(NSString *)email completion:(void (^)(BOOL, NSString *))completion {
    NSMutableDictionary *data = [NSMutableDictionary new];
    [data addEntriesFromDictionary:[address JSONValueNonCamelCase]];
    
    if (newPassword) {
        [data setObject:newPassword forKey:@"newPassword"];
        [data setObject:oldPassword forKey:@"oldPassword"];
    }
    if (email) {
        [data setObject:email forKey:@"email"];
    }
    
    [self queueRequest:[RESTRequest postURL:WS_updateUser object:data]
            completion:^(RESTResponse *response) {
                completion(response.success, [response.object objectForKey:@"message"]);
            }];
}

#pragma mark - 

- (void)queueRequest:(RESTRequest *)request completion:(void(^)(RESTResponse *response))completion {
    [[RESTService sharedService] queueRequest:request completion:completion];
}

- (void)loadPaymentCards:(void(^)(NSArray *paymentCards))completion {
    [self queueRequest:[RESTRequest getURL:@"/paymentCards"]
            completion:^(RESTResponse *response) {
                if (response.success) {
                    NSMutableArray *addresses = [NSMutableArray array];
                    for (id JSONValue in response.object) {
                        [addresses addObject:[[PaymentCard alloc] initWithJSONValue:JSONValue]];
                    }
                    completion(addresses);
                } else {
                    NSLog(@"Error while loading payment cards: %@", response.error);
                    completion(nil);
                }
            }];
}

- (void)deletePaymentCard:(PaymentCard *)paymentCard completion:(void(^)(BOOL success))completion {
    [self queueRequest:[RESTRequest deleteURL:[NSString stringWithFormat:@"/paymentCards/%@", paymentCard.ID]]
            completion:^(RESTResponse *response) {
                completion(response.success);
            }];
}

- (void)setWifiStatus:(WifiStatus) wifiStatus completion:(void(^)(BOOL success))completion {
    
    [self queueRequest:[RESTRequest postURL:WS_wifistatus object:@{@"WifiStatus": [WifiStatusIDs idForValue:wifiStatus]}]
            completion:^(RESTResponse *response) {
                [User activeUser].wifiStatus = wifiStatus;
                completion(response.success);
            }];
}

- (void)loadWifiStatusCompletion:(void(^)(BOOL success))completion {
    [self queueRequest:[RESTRequest getURL:WS_wifistatus]
            completion:^(RESTResponse *response) {
                if (response.statusCode == 200)
                {
                    if(response.success)
                    {
                        self.wifiStatus = [WifiStatusIDs valueForID:response.object[@"WifiStatus"]]
                        ;
                    }
                    completion(response.success);
                }
                else
                {
                    completion(NO);
                }
            }];
}

- (void)getWifiPaymentURLCompletion:(void(^)(BOOL success, NSString *paymentURL))completion {
    [self queueRequest:[RESTRequest getURL:WS_getWifiPaymentUrl]
            completion:^(RESTResponse *response) {
                NSString *url = @"";
                if(response.success) {
                    url = response.object[@"message"];
                }
                completion(response.success, url);
            }];
}

- (void)loadWifiOptions {
    [self queueRequest:[RESTRequest getURL:WS_orderCreationMethod]
            completion:^(RESTResponse *response) {
                if(response.success) {
                   self.wifiOrderOption = response.object[@"orderCreationMethod"];
                }
            }];
}

@end
