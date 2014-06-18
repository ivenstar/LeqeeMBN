//
//  NewsletterSubscriptionDataService.m
//  Flatland
//
//  Created by Jochen Block on 13.06.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "NewsletterSubscriptionDataService.h"
#import "RESTService.h"

@implementation NewsletterSubscriptionDataService
- (void)loadNewsletterSubscriptions:(BOOL)subscribe completion:(void (^)(NewsletterSubscription *))completion {
    [[RESTService sharedService] queueRequest:[RESTRequest getURL:WS_newsletterSubscriptionStatus] completion:^(RESTResponse *response) {
                if (response.success) {
                    NewsletterSubscription *newsletter = [[NewsletterSubscription alloc] init];
                    NSArray *jsonArray = ArrayFromJSONObject(response.object);
                    newsletter.nestle = [StringFromJSONObject([jsonArray valueForKey:@"isNewsletterSubscribe"]) integerValue];
                    newsletter.partner = [StringFromJSONObject([jsonArray valueForKey:@"isNestleAndPartnersNewsletterSubscribe"]) integerValue];
                    completion(newsletter);
                } else {
                    completion(nil);
                }
            }];
}

#pragma mark -

- (void)queueRequest:(RESTRequest *)request completion:(void(^)(RESTResponse *response))completion {
    [[RESTService sharedService] queueRequest:request completion:completion];
}
@end
