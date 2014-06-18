//
//  RESTRequest.h
//  JSONRestRequest
//
//  Created by Stefan Matthias Aust on 10.06.11.
//  Copyright 2011 Proximity GmbH. All rights reserved.
//


/**
 * Provides a representation for REST requests for which you can set the method
 * (GET, POST, PUT, DELETE), the URL fragment (without the scheme, server and port
 * but including URL parameters) and an optional data object (which will be JSON
 * encoded). After performing the request, the \c error, the HTTP \c statusCode and
 * the optional data \c object can be inspected.
 */
@interface RESTRequest : NSObject

/// construct a GET request object to the given URL
+ (RESTRequest *)getURL:(NSString *)URL;
+ (RESTRequest *)getURLMachine:(NSString *)URL;

/// construct a POST request object to the given URL, posting the given object as JSON data
+ (RESTRequest *)postURL:(NSString *)URL object:(id)object;
+ (RESTRequest *)postURLMachine:(NSString *)URL object:(id)object;

/// construct a PUT request object to the given URL, posting the given object as JSON data
+ (RESTRequest *)putURL:(NSString *)URL object:(id)object;

/// construct a DELETE request object to the given URL
+ (RESTRequest *)deleteURL:(NSString *)URL;

/// construct a upload request
+ (RESTRequest *)uploadURL:(NSString *)URL data:(NSData *)data mimeType:(NSString *)mimeType;

/// create a new instance with the given HTTP method, URL and optional object for JSON data
- (id)initWithMethod:(NSString *)method URL:(NSString *)URL object:(id)object;
- (id)initWithMachineMethod:(NSString *)method URL:(NSString *)URL object:(id)object;

/// return the receiver's data object
- (NSData *)computeBody;

/// return the receiver's content type
- (NSString *)computeContentType;



/// store the HTTP method (one of GET, POST, PUT or DELETE)
@property (nonatomic, copy) NSString *method;

// store the URL fragment (including URL parameters)
@property (nonatomic, copy) NSString *URL;



@end
