//
//  RESTResponse.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 19.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RESTResponse : NSObject

/// return YES if the server did not return a failure
- (BOOL)success;

// store the optional data object (must conform to NSCopying and JSON serialisation)
@property (nonatomic, copy) id object;

@property (nonatomic, copy) id data;



// return the error if something went wrong while performing the request, return nil otherwise
@property (nonatomic, strong) NSError *error;

// return the HTTP status code after performing the request
@property (nonatomic, assign) NSInteger statusCode;

@end
