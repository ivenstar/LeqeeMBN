//
//  RegistrationData.m
//  Flatland
//
//  Created by Stefan Aust on 22.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "RegistrationData.h"

@implementation RegistrationData

- (id)data {
    if(self.dateOfBirth) {
        return @{@"optlevel": self.optLevel,
                 @"email": self.email,
                 @"firstname": self.firstName,
                 @"lastname": self.lastName,
                 @"mobile": self.phone,
                 @"isNewsletterDeclined": self.acceptNewsletter ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES],
                 @"isNestleNewsletterDeclined": self.acceptNestleNewsletter ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES],
                 @"password": self.password,
                 @"salutation": self.salutation,
                 @"title": @"",
                 @"estimatedDateOfBirth" : JSONValueFromDate(self.dateOfBirth)};
    } else {
        return @{@"optlevel": self.optLevel,
             @"email": self.email,
             @"firstname": self.firstName,
             @"lastname": self.lastName,
             @"mobile": self.phone,
             @"isNewsletterDeclined": self.acceptNewsletter ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES],
             @"isNestleNewsletterDeclined": self.acceptNestleNewsletter ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES],
             @"password": self.password,
             @"salutation": self.salutation,
             @"title": @""};
    }
}

@end
