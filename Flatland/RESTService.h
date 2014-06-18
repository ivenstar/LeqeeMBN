//
//  RESTService.h
//  JSONRestRequest
//
//  Created by Stefan Matthias Aust on 10.06.11.
//  Copyright 2011 Proximity GmbH. All rights reserved.
//

#import "RESTRequest.h"
#import "RESTResponse.h"
#import "SecureUDID.h"

/**
 * Provides a singleton to access the backend service.
 *
 * Every request has for custom headers:
 *  - \c X-Token        the access token, if available
 *  - \c X-Device-ID    the device's unique ID
 *  - \c X-Country      current country, for example \c CH (from \c NSLocale)
 *  - \c X-Language     current language, for example \c de (from \c NSLocale)
 *
 * Data is PUT or POSTed as JSON data.
 * Data is received as JSON data.
 */

// return the unique device ID; it is cached because accessing this object is expensive
static NSString *DeviceID() {
    static NSString *deviceID = nil;
    if (!deviceID) {
        deviceID = [SecureUDID UDIDForDomain:@"babynes" usingKey:@"xu3Tu9vOy1"];
    }
    return deviceID;
}

@interface RESTService : NSObject <NSCacheDelegate, NSURLConnectionDelegate>

/// return the singleton service object
+ (RESTService *)sharedService;

/// queue a request and call the completion block with the response added to the request object
- (void)queueRequest:(RESTRequest *)request completion:(void(^)(RESTResponse *response))block;

/// queue an image request
- (void)queueImageRequest:(NSString *) URL completion:(void(^)(UIImage *image))block;;

/// queue an image request with nil as completion in case of errors
-(void)queueImageRequest:(NSString *)URL completionWithNil:(void(^)(UIImage *image))block;

@end
