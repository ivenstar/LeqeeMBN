//
//  RegistrationData.h
//  Flatland
//
//  Created by Stefan Aust on 22.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistrationData : NSObject

@property (nonatomic, copy) NSString *optLevel;
@property (nonatomic, copy) NSString *salutation;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSDate *dateOfBirth;
@property (nonatomic, assign) BOOL acceptNewsletter;  //YES enables newsletter
@property (nonatomic, assign) BOOL acceptNestleNewsletter; //YES enables newsletter

- (id)data;

@end
