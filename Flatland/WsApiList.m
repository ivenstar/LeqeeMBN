//
//  BabyNes
//
//  Created by Ionel Pascu on 10.02.14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "WsApiList.h"

//Ionel create const strings for WS methods
///
NSString * const WS_login = @"/babynes/login";
NSString * const WS_logout = @"/babynes/logout";
NSString * const WS_register = @"/babynes/register";
NSString * const WS_babies = @"/babynes/babies";
NSString * const WS_wifistatus = @"/babynes_user/wifistatus";
NSString * const WS_ordersRecommendation = @"/babynes_orders/recommendation";
NSString * const WS_newsletterSubscriptionStatus = @"/babynes_newsletter/subscriptionstatus";
NSString * const WS_orderCreationMethod = @"/babynes_user/ordercreationmethod";
NSString * const WS_NotificationEnabledStatusID = @"/babynes/notificationenabledstatus?id=%@";
//deprecated: NSString * const WS_babyWeights = @"/babynes_baby_weight/get";
NSString * const WS_babyWeights = @"/babynes_baby_weight/getWeights";
NSString * const WS_breastFeedings = @"/babynes_baby_breastfeeding/get";
NSString * const WS_breastFeedingsByDay = @"/babynes_baby_breastfeeding/byDay";
NSString * const WS_babyBottleConsumptionMonthly = @"/babynes_baby_consumption/monthly";
NSString * const WS_babyBottleConsumptionWeekly = @"/babynes_baby_consumption/weekly";
NSString * const WS_babyBottleConsumptionDaily = @"/babynes_baby_consumption/daily";
NSString * const WS_babyBottleConsumptionUpdate = @"/babynes_baby_consumption/update";

NSString * const WS_babyBreastConsumptionMonthly = @"/babynes_baby_breastfeeding/monthly";
NSString * const WS_babyBreastConsumptionWeekly = @"/babynes_baby_breastfeeding/weekly";
NSString * const WS_babyBreastConsumptionDaily = @"/babynes_baby_breastfeeding/daily";


NSString * const WS_babyBottleConsumptionByDay = @"/babynes_baby_consumption/byDay";
NSString * const WS_babyBottleConsumptionCreate = @"/babynes_baby_consumption/create";
NSString * const WS_babyBottleConsumptionDelete = @"/babynes_baby_consumption/delete?id=%@";
NSString * const WS_capsuleStock = @"/babynes/capsulestock";
NSString * const WS_lastBabyWeight = @"/babynes_baby_weight/last?id=%@&before=%lld";
NSString * const WS_createBaby = @"/babynes_baby/create";
NSString * const WS_deleteBaby = @"/babynes_baby/delete?id=%@";
NSString * const WS_updateBaby = @"/babynes_baby/update";
NSString * const WS_getUser = @"/babynes_user/get";
NSString * const WS_updateUser = @"/babynes_user/update";
NSString * const WS_babiesID = @"/babynes/babies?id=%@";
NSString * const WS_addressesGet = @"/babynes_address/get";
NSString * const WS_addressesUpdate = @"/babynes_address/update";
NSString * const WS_addressesBillingGet = @"/babynes_address_billing/get";
NSString * const WS_addressBillingCreate = @"/babynes_address_billing/create";
NSString * const WS_addressBillingUpdate = @"/babynes_address_billing/update?id=%@";
NSString * const WS_addressDelete = @"/babynes_address/delete?id=%@";
NSString * const WS_addressShippingUpdate = @"/babynes_address/update?id=%@";
NSString * const WS_loginRecover = @"/babynes/recover";
NSString * const WS_babyImageUpload = @"/babynes_baby_image/upload?id=%@";
NSString * const WS_babyMessages = @"/babynes_baby_messages/get?id=%@";
NSString * const WS_babyMessageCreate = @"/babynes_baby_message/create";
NSString * const WS_breastfeedingCreate = @"/babynes_baby_breastfeeding/create";
NSString * const WS_breastfeedingUpdate = @"/babynes_baby_breastfeeding/update?id=%@";
NSString * const WS_breastfeedingDelete = @"/babynes_baby_breastfeeding/delete?id=%@";
NSString * const WS_babyWeightCreate = @"/babynes_baby_weight/create";
NSString * const WS_babyWeightUpdate = @"/babynes_baby_weight/update?id=%@";
NSString * const WS_newsletterSubscribe = @"/babynes_newsletter/subscribe";
NSString * const WS_newsletterSubscribePartners = @"/babynes_newsletter/subscribe?to=NestleAndPartners";
NSString * const WS_newsletterUnsubscribe = @"/babynes_newsletter/unsubscribe";
NSString * const WS_newsletterUnsubscribePartners = @"/babynes_newsletter/unsubscribe?from=NestleAndPartners";
NSString * const WS_withingsAuthUrl = @"/babynes_withings/authorizationUrl?id=%@";
NSString * const WS_notificationEnabledStatus = @"/babynes/notificationenabledstatus";
NSString * const WS_orderCreationMethodPut = @"/babynes_user/ordercreationmethod?method=%@";
NSString * const WS_getWifiPaymentUrl = @"/babynes/wifipaymenturl";
NSString * const WS_storesForCityOrZipCode = @"/babynes/stores?cityOrZipCode=%@&buyMachine=%@&buyCapsules=%@&demonstration=%@";
NSString * const WS_ordersCreate = @"/babynes_orders/create";
NSString * const WS_getLastEventDate = @"/babynes/getLastEventDate";

NSString * const WS_getLastBreastfeedings = @"/babynes_baby_breastfeeding/getLastBreastfeedings";
NSString * const WS_getLastBottlefeedings = @"/babynes_baby_consumption/getLastBottlefeedings";
NSString * const WS_getLastWeights = @"/babynes_baby_weight/getLastWeights";
NSString * const WS_showStores = @"/babynes/stores?longitude=%f&latitude=%f&buyMachine=%@&buyCapsules=%@&demonstration=%@";

//Notifications and Alerts
NSString * const WS_getNotificationsStatus = @"/babynes_notifications/status";
NSString * const WS_updateNotificationsStatus = @"/babynes_notifications/update";

//timeline
NSString * const WS_timelineGet = @"/babynes_baby_timeline/get";
NSString * const WS_timelineCreate = @"/babynes_baby_timeline/create";

///
//Machine API methods
NSString * const WSM_getStatus = @"/getsetupstatus";
NSString * const WSM_getWifiList = @"/getwifilist";
NSString * const WSM_configureWifi = @"/configurewifi";
NSString * const WSM_completeSetup = @"/completesetup";

NSString *GetServiceEnv() {
    static NSString *serviceEnv;
    if (!serviceEnv)
    {
#if defined(TARGET_DEV)
     serviceEnv = @"Dev2";
#elif defined(TARGET_PRE_PROD)
     serviceEnv = @"Pre-Prod";
#else
     serviceEnv = @"Prod";
#endif
    }
    return serviceEnv;
}

NSString *GetMachineServiceURL() {
    NSString *serviceURL;
    if (!serviceURL) {
        serviceURL = @"http://10.178.191.1/interface/api";
    }
    return serviceURL;
}