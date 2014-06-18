//
//  RESTService.m
//  JSONRestRequest
//
//  Created by Stefan Matthias Aust on 10.06.11.
//  Copyright 2011 Proximity GmbH. All rights reserved.
//

#import "RESTService.h"
#import "SecureUDID.h"
#import "User.h"

static NSError *MakeError(RESTRequest *request, NSInteger statusCode, NSString *reason) {
    NSString *description = [NSString stringWithFormat:@"Error: HTTP %d - %@", statusCode, reason];
    return [NSError errorWithDomain:NSURLErrorDomain
                               code:statusCode
                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                     description, NSLocalizedDescriptionKey,
                                     request.URL, NSURLErrorFailingURLStringErrorKey,
                                     [NSURL URLWithString:request.URL], NSURLErrorKey,
                                     reason, NSLocalizedFailureReasonErrorKey,
                                     nil]];
}


#define HTTP_TIMEOUT 30

@interface RESTService()

@end

@implementation RESTService

// return the service singleton
+ (RESTService *)sharedService {
    static RESTService *sharedService = nil;
    if (!sharedService) {
        sharedService = [self new];
        [NSURLCache setSharedURLCache:[[NSURLCache alloc] initWithMemoryCapacity:2000000 diskCapacity:20000000 diskPath:@"DC"]];
    }
    return sharedService;
}


- (void)queueRequest:(RESTRequest *)request completion:(void(^)(RESTResponse *response))block {
    NSLog(@"Requesting %p: %@ %@", request, request.method, request.URL);
    
    //get timezone
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSString *timeZone = [NSString stringWithFormat:@"%@", zone];
    timeZone = [[timeZone componentsSeparatedByString:@" "] objectAtIndex:0];
    //NSLog(@"timezone...%@", timeZone);
    
    // initialize HTTP request
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request.URL]];
    // set timeout
    [URLRequest setTimeoutInterval:HTTP_TIMEOUT];
    
    // setup the custom header fields
    NSLog(@"User AccessToken=%@",[User activeUser].accessToken);
    [URLRequest addValue:[User activeUser].accessToken forHTTPHeaderField:@"X-Authentication-Token"];
    [URLRequest addValue:DeviceID() forHTTPHeaderField:@"X-Unique-Device-Id"];
    [URLRequest addValue:kCountryCode forHTTPHeaderField:@"X-Country"];
    [URLRequest addValue:T(@"%general.language") forHTTPHeaderField:@"X-Language"];
    [URLRequest addValue:@"NNBN" forHTTPHeaderField:@"X-Brand"];
    [URLRequest setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [URLRequest addValue:timeZone forHTTPHeaderField:@"X-Timezone"];
    // setup the content type which is required for the .NET API
    [URLRequest addValue:[request computeContentType] forHTTPHeaderField:@"Content-Type"];
    
    NSData *d = [request computeBody];
    [URLRequest addValue:[NSString stringWithFormat:@"%d",[d length] ] forHTTPHeaderField:@"Content-Length"];
    NSLog(@"Headers: %@", [URLRequest allHTTPHeaderFields]);
    
    
    // set method and body (which must be done after setting the header)
    [URLRequest setHTTPMethod:request.method];
    [URLRequest setHTTPBody:d];
    
    [NSURLConnection sendAsynchronousRequest:URLRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *r, NSData *_data, NSError *_error){
        NSHTTPURLResponse *_response = (NSHTTPURLResponse*)r;
        RESTResponse *response = [RESTResponse new];
        
        response.statusCode = _response.statusCode;
        if ([_data length]) {
            NSString *JSONString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
            
            // the .NET API might send us an HTML formatted error message
            if ([JSONString hasPrefix:@"<html"]) {
                if (response.statusCode == 200) {
                    response.statusCode = 500;
                }
                response.error = MakeError(request,response.statusCode, JSONString);
            } else if ([JSONString rangeOfString:@"X-Authentication-Token header missing"].location != NSNotFound) {
                response.statusCode = 401;
                response.object = nil;
            } /*else if(response.statusCode == 0) {
                response.statusCode = 404;
            }*/ else {
                response.statusCode = [_response statusCode];
                response.object = [NSJSONSerialization JSONObjectWithData:_data options:0 error:NULL];
            }
        }
        
        if ((!_error && _response.statusCode < 200) || _response.statusCode >= 300) {
            NSString *reason = @"";
            //sometimes we don't have strings but data
            if(response.object) {
                reason = [NSString stringWithFormat: @"Reason: %@", response.object];
            }
            response.error = MakeError(request,_response.statusCode, reason);
        }
        NSLog(@"Request %@ completed with %d", request.URL, response.statusCode);
        
        if(response.object) {
            NSLog(@"%@", response.object);
        }
        if (response.error) {
            NSLog(@"and error: %@", response.error);
        }

        block(response);
    }];
    
    //Ionel remove cache
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


-(void)queueImageRequest:(NSString *)URL completion:(void(^)(UIImage *image))block{
    if(!URL) {
        return;
    }
    // add scheme, hostname and port if the request's URL is just a fragment starting with "/"
    if ([URL hasPrefix:@"/"]) {
        URL = [GetServiceURL() stringByAppendingString:URL];
    }
    
    // setup the HTTP request
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:HTTP_TIMEOUT];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    
    NSLog(@"loading image from %@ with request: %p", URL, request);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *r, NSData *_data, NSError *_error) {
        NSHTTPURLResponse *_response = (NSHTTPURLResponse*)r;
        NSLog(@"Image Loading %p completed with %d", request, _response.statusCode);
        if (!_error && _response.statusCode == 200) {
            if (block) {
                block([UIImage imageWithData:_data ]);
            }
        } else {
            NSLog(@"Could not load image. HTTP Status %d", _response.statusCode);
        }
    }];
}

-(void)queueImageRequest:(NSString *)URL completionWithNil:(void(^)(UIImage *image))block
{
    if(!URL)
    {
        block(nil);
        return;
    }
    // add scheme, hostname and port if the request's URL is just a fragment starting with "/"
    if ([URL hasPrefix:@"/"])
    {
        URL = [GetServiceURL() stringByAppendingString:URL];
    }
    
    // setup the HTTP request
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:HTTP_TIMEOUT];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    
    NSLog(@"loading image from %@ with request: %p", URL, request);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *r, NSData *_data, NSError *_error) {
        NSHTTPURLResponse *_response = (NSHTTPURLResponse*)r;
        NSLog(@"Image Loading %p completed with %d", request, _response.statusCode);
        if (!_error && _response.statusCode == 200)
        {
            if (block)
            {
                block([UIImage imageWithData:_data ]);
            }
        }
        else
        {
            block(nil);
            NSLog(@"Could not load image. HTTP Status %d", _response.statusCode);
        }
    }];
}


//cache delegate
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}


@end
