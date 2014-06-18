//
//  NewsletterSubscription.m
//  Flatland
//
//  Created by Jochen Block on 13.06.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "NewsletterSubscription.h"

#import "Baby.h"
#import "RESTService.h"
#import "User.h"

@implementation NewsletterSubscription

- (id)initWithJSONObject:(id)JSONObject {
    self = [self init];
    if (self) {
        [self updateWithJSONObject:JSONObject];
    }
    return self;
}

- (void)updateWithJSONObject:(id)JSONObject {
    _nestle = [StringFromJSONObject([JSONObject valueForKey:@"isNewsletterSubscribe"]) integerValue];
    _partner= [StringFromJSONObject([JSONObject valueForKey:@"isNestleAndPartnersNewsletterSubscribe"]) integerValue];
    
}

- (void)subscribeNewsletter:(void (^)(BOOL))completion {
    [[RESTService sharedService]
     queueRequest:[RESTRequest getURL:WS_newsletterSubscribe]
     completion:^(RESTResponse *response) {
         if (response.success) {
             completion(YES);
         }else{
             completion(NO);
         }
     }];
}

- (void)subscribeNewsletterPartner:(void (^)(BOOL))completion {
    [[RESTService sharedService]
     queueRequest:[RESTRequest getURL:WS_newsletterSubscribePartners]
     completion:^(RESTResponse *response) {
         if (response.success) {
             completion(YES);
         }else{
             completion(NO);
         }
     }];
}

- (void)unsubscribeNewsletter:(void (^)(BOOL))completion {
    [[RESTService sharedService]
     queueRequest:[RESTRequest getURL:WS_newsletterUnsubscribe]
     completion:^(RESTResponse *response) {
         if (response.success) {
             completion(YES);
         }else{
             completion(NO);
         }
     }];
}

- (void)unsubscribeNewsletterPartner:(void (^)(BOOL))completion {
    [[RESTService sharedService]
     queueRequest:[RESTRequest getURL:WS_newsletterUnsubscribePartners]
     completion:^(RESTResponse *response) {
         if (response.success) {
             completion(YES);
         }else{
             completion(NO);
         }
     }];
}


@end
