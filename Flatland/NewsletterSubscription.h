//
//  NewsletterSubscription.h
//  Flatland
//
//  Created by Jochen Block on 13.06.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsletterSubscription : NSObject

@property (nonatomic) int nestle;
@property (nonatomic) int partner;

- (id)initWithJSONObject:(id)JSONObject;
- (void)updateWithJSONObject:(id)JSONObject;
- (void)subscribeNewsletter:(void (^)(BOOL))completion;
- (void)subscribeNewsletterPartner:(void (^)(BOOL))completion;
- (void)unsubscribeNewsletter:(void (^)(BOOL))completion;
- (void)unsubscribeNewsletterPartner:(void (^)(BOOL))completion;
@end
