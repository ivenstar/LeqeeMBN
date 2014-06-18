//
//  RESTRequest.m
//  JSONRestRequest
//
//  Created by Stefan Matthias Aust on 10.06.11.
//  Copyright 2011 Proximity GmbH. All rights reserved.
//

#import "RESTRequest.h"
@interface RESTRequest()

@property (nonatomic, copy) id object;
@property (nonatomic, copy) NSString *mimeType;
@end
@implementation RESTRequest

+ (RESTRequest *)getURL:(NSString *)URL {
    return [[RESTRequest alloc] initWithMethod:@"GET" URL:URL object:nil];
}

+ (RESTRequest *)postURL:(NSString *)URL object:(id)object {
    return [[RESTRequest alloc] initWithMethod:@"POST" URL:URL object:object];
}

+ (RESTRequest *)putURL:(NSString *)URL object:(id)object {
    return [[RESTRequest alloc] initWithMethod:@"PUT" URL:URL object:object];
}

+ (RESTRequest *)deleteURL:(NSString *)URL {
    return [[RESTRequest alloc] initWithMethod:@"DELETE" URL:URL object:nil];
}

+ (RESTRequest *)uploadURL:(NSString *)URL data:(NSData *)data mimeType:(NSString *)mimeType {
    RESTRequest *r = [[RESTRequest alloc] initWithMethod:@"POST" URL:URL object:data];
    r.mimeType = mimeType;
    return r;
}
/////
// Machine calls
/////

+ (RESTRequest *)getURLMachine:(NSString *)URL {
    return [[RESTRequest alloc] initWithMachineMethod:@"GET" URL:URL object:nil];
}

+ (RESTRequest *)postURLMachine:(NSString *)URL object:(id)object {
    return [[RESTRequest alloc] initWithMachineMethod:@"POST" URL:URL object:object];
}

- (id)initWithMachineMethod:(NSString *)method URL:(NSString *)URL object:(id)object {
    self = [super init];
    if (self) {
        self.method = method;
        
        // add scheme, hostname and port if the request's URL is just a fragment
        if ([URL hasPrefix:@"/"]) {
            URL = [NSString stringWithFormat:@"%@%@", GetMachineServiceURL(), URL];
        }
        self.URL = URL;
        
        self.object = object;
    }
    return self;
}

////
- (id)initWithMethod:(NSString *)method URL:(NSString *)URL object:(id)object {
    self = [super init];
    if (self) {
        NSLog(@"RESRRequest initWithMethod %@ URL=%@ object=[%@]",method,URL,object);
        self.method = method;
        // add scheme, hostname and port if the request's URL is just a fragment
        if ([URL hasPrefix:@"/"])
        {
            URL = [NSString stringWithFormat:@"%@%@", GetServiceURL(), URL];
        }
        self.URL = URL;
        
        self.object = object;
    }
    return self;
}



- (NSData *)computeBody {
    // keep an NSData object unchanged and otherwise assume something that can be converted into JSON data
    if (self.object) {
        if([self.object isKindOfClass:[NSData class]]) {
            return self.object;
        }
        else if ([self.object isKindOfClass:[NSString class]]){
            NSLog(@"String data:: %@", self.object);
            return [self.object dataUsingEncoding:NSUTF8StringEncoding];
        }
        else {
            NSError *error = nil;
            id data = [NSJSONSerialization dataWithJSONObject:self.object options:0 error:&error];
            if (!data || error) {
                NSLog(@"error while creating JSON object: %@", error);
                return nil;
            }
            NSLog(@"JSON data<<%@>>", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            return data;
        }
    }
    return nil;
}

- (NSString *)computeContentType {
    if(self.mimeType) {
        return self.mimeType;
    } else {
        if ([self.method isEqualToString:WSM_configureWifi])
            return @"application/x-www-form-urlencoded";
        else return @"application/json";
    }
}

@end
