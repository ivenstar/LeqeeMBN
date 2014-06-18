//
//  EncryptTest.m
//  Flatland
//
//  Created by Ionel Pascu on 11/29/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "EncryptAES.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>



#define kChosenCipherBlockSize  kCCBlockSizeAES128
#define kChosenCipherKeySize    32


NSMutableData *receivedData_;
const uint8_t key[kChosenCipherKeySize] = {0x02, 'B', '@', 'b', 'y', 'N', '3', 'z', 0xF3, 0x37, 0x24, 0x52, 0x81, 0xBA, 0x83, 0x71, 0xA4, 0x69, 0x07, 0x55, 0x29, 0x34, 0x89, 0x43, 0x21, 0x62, 0xE4,  0xE9, 0xCD, 0x1E, 0x4D, 0xF3 };
//const NSString* ssid = @"MySSID";
//const NSString* password = @"MyPassword";
//const NSString* appToken = @"abcdef0123456789";
//const NSString* lang = @"en";
//const NSString* country = @"us";


@implementation EncryptAES

- (NSData*)encodeDictionary:(NSDictionary*)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedValue = [self urlencode:[dictionary objectForKey:key]];
        NSString *encodedKey = [self urlencode:key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlencode :(NSString*) string {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[string UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

-(NSData*) aesEncrypt: (NSData*) plain iv:(uint8_t*) iv
{
    
    
    NSMutableData* cipher = [NSMutableData dataWithLength:plain.length + kCCBlockSizeAES128];
    
    // Number of bytes moved to buffer.
    size_t movedBytes = 0;
    
    
    // In case plain text is empty
    if([plain length] <= 0) {
        NSLog(@"Empty plain text");
        return nil;
    }
    
    CCCryptorStatus
    result = CCCrypt(kCCEncrypt, // operation
                     kCCAlgorithmAES128, // Algorithm
                     kCCOptionPKCS7Padding, // options
                     key, // key
                     kChosenCipherKeySize, // keylength
                     iv,// iv
                     plain.bytes, // dataIn
                     plain.length, // dataInLength,
                     cipher.mutableBytes, // dataOut
                     cipher.length, // dataOutAvailable
                     &movedBytes); // dataOutMoved
    
    if (result == kCCSuccess) {
        cipher.length = movedBytes;
    }
    else {
        NSLog(@"Failed encryption");
    }
    
    return cipher;
    
}



- (NSString*) encryptWithSSID:(NSString*)ssid password:(NSString*)password token:(NSString*)appToken lang:(NSString*)lang country:(NSString*)country
{
    /* URL encode params */
    NSDictionary *paramsDict = [NSDictionary dictionaryWithObjectsAndKeys: ssid, @"ssid",
                                password,  @"password", appToken, @"apptoken", lang, @"lang", country, @"country", nil];
    
    NSData* paramsURLEncoded = [self encodeDictionary:paramsDict];
    
    /* Encrypt params */
    uint8_t iv[kChosenCipherBlockSize];
    
    // Set the iv random bytes
    if(SecRandomCopyBytes(kSecRandomDefault, kChosenCipherBlockSize, iv) != noErr){
        NSLog(@"Failed to generate random iv");
        return @"";
    }
    
    
    NSData* encryptedParams = [self aesEncrypt:paramsURLEncoded iv:iv];
    
    
    NSData* ivData = [NSData dataWithBytes:iv length:kChosenCipherBlockSize];
    
    /* Encode iv and encryptedParams in base64 format */
    NSString* base64Data = Base64forData(encryptedParams);// [encryptedParams base64EncodedStringWithOptions:0];
    NSString* base64IV = Base64forData(ivData); //[ivData base64EncodedStringWithOptions:0];
    
    base64Data = URLencodeForString(base64Data);
    base64IV = URLencodeForString(base64IV);
    /* URL encode POST body */
    NSString *final = [NSString stringWithFormat:@"data=%@&iv=%@", base64Data, base64IV];
    return final;
    
    //NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:base64IV, @"iv",
//                              base64Data, @"data", nil];
}

@end


