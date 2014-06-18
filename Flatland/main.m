//
//  main.m
//  Flatland
//
//  Created by Stefan Aust on 13.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "SpecificDefines.h"

int main(int argc, char *argv[])
{    
#if defined(BABY_NES_CH) && !defined(TARGET_PROD)
#ifdef SET_DEFAULT_LANGUAGE_DE
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"de", nil] forKey:@"AppleLanguages"]; //switching to german locale
    [[NSUserDefaults standardUserDefaults] synchronize];
#endif//SET_DEFAULT_LANGUAGE_DE
    
#endif//defined(BABY_NES_CH) && !defined(TARGET_PROD)

    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
    
}
