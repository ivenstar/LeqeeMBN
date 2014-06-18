//
//  EncryptTest.h
//  Flatland
//
//  Created by Ionel Pascu on 11/29/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/SecRandom.h>


@interface EncryptAES : NSObject

- (NSString*) encryptWithSSID:(NSString*)ssid password:(NSString*)password token:(NSString*)appToken lang:(NSString*)lang country:(NSString*)country;
- (NSData*) aesEncrypt: (NSData*) plain iv:(uint8_t*) iv;
- (NSString *)urlencode :(NSString*) string;
- (NSData*)encodeDictionary:(NSDictionary*)dictionary;

@end
