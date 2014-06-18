//
//  NewsletterSubscriptionDataService.h
//  Flatland
//
//  Created by Jochen Block on 13.06.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baby.h"
#import "NewsletterSubscription.h"

@interface NewsletterSubscriptionDataService : NSObject

- (void)loadNewsletterSubscriptions:(BOOL)subscribe completion:(void (^)(NewsletterSubscription *subscriptions))completion;

@end
