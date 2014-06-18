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
NSString * const kValidCountryCodes = @"ch";
NSString * const kImagePrePath = @"https://babynes-int-ch.dev.isc4u.de";
NSString * const kCountryCode = @"CH";

NSString* const iTunesLink = @"https://itunes.apple.com/ch/app/nestle-apprendre-en-samusant/id453254849";

NSString* const kFacebookTwitterLink = @"http://www.babynes.com/";

NSString *GetServiceURL() {
    static NSString *serviceURL;
    if (!serviceURL)
    {
#if defined(TARGET_DEV)
        ////dev2
        serviceURL = [NSString stringWithFormat:@"http://babynes-dev2.ocentric.com/ch-%@/babynes_rest", T(@"%general.language")];
#elif defined(TARGET_PRE_PROD)
        //preprod
        serviceURL = [NSString stringWithFormat:@"https://preprod.babynes.com/ch-%@/babynes_rest", T(@"%general.language")];
#else
        //prod
        serviceURL = [NSString stringWithFormat:@"https://prod.babynes.com/ch-%@/babynes_rest", T(@"%general.language")];
#endif //defined(TARGET_DEV)
    }
    return serviceURL;
}

NSString *GetGoogleTrackingId()
{
#ifdef TARGET_PROD
    return @"UA-45257035-2";
#else
    return @"UA-46442337-2";
#endif //TARGET_PROD
}



