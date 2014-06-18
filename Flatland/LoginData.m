//
//  LoginData.m
//  Flatland
//
//  Created by Stefan Aust on 22.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "LoginData.h"

@implementation LoginData

- (id)data {
    NSString *deviceToken = @"";
    
    if (self.deviceToken) {
        deviceToken = [[[[self.deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString: @" " withString: @""];
    }
    
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"LoginData"
                                                  message:[NSString stringWithFormat:@"deviceToken=%@",deviceToken]
                                                 delegate:nil
                                        cancelButtonTitle:NSLocalizedString(@"OK",@"确定")
                                        otherButtonTitles:nil];
    [alert show];
    
    return @{@"email": self.email,
             @"password": self.password,
             @"deviceToken": deviceToken};
}

@end
