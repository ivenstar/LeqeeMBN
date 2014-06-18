//
//  Specific.m
//  BabyNes
//
//  Created by Stefan Aust on 02.04.12.
//  Copyright (c) 2012 Proximity GmbH. All rights reserved.
//

#import "Specific.h"
#import "WsApiList.h"

NSString * const kValidLanguageCodes = @"";
NSString * const kValidCountryCodes = @"us";
NSString * const kImagePrePath = @"https://babynes-int-ch.dev.isc4u.de";
NSString * const kCountryCode = @"US";

NSString* const iTunesLink = @"https://google.com"; //TODO GET LINK FOR US

NSString* const kFacebookTwitterLink = @"http://www.babynes.com/";

NSString *GetServiceURL() {
    static NSString *serviceURL;
    if (!serviceURL)
    {
#if defined(TARGET_DEV)
        ////dev2
        serviceURL = @"http://babynes-dev2.ocentric.com/us-en/babynes_rest";
#elif defined(TARGET_PRE_PROD)
        //preprod
        serviceURL = @"https://preprod.babynes.com/us-en/babynes_rest";
#else
        //prod
        serviceURL =  @"https://prod.babynes.com/us-en-beta/babynes_rest";
#endif //defined(TARGET_DEV)
    }
    return serviceURL;
}

NSString *GetGoogleTrackingId()
{
#ifdef TARGET_PROD
    return @"UA-46446948-4";
#else
    return @"UA-46442337-2";
#endif //TARGET_PROD
}


