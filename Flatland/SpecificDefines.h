//
//  SpecificDefines.h
//  Flatland
//
//  Created by Bogdan Chitu on 11/03/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#ifndef Flatland_SpecificDefines_h
#define Flatland_SpecificDefines_h

//#define TARGET_DEV
#define TARGET_PRE_PROD
//#define TARGET_PROD


///////////////////////////App Macros///////////////////////////
#define MAX_NB_WIFI_REFILL_PROMPTS 3
#define MAX_NB_WIFI_SETUP_PROMPTS 3
#define TIMELINE_INTERVAL_TO_HIDE_FRIENDS_POPUP 10
#define TIMELINE_FIRST_LOAD_ENTRIES_PER_PAGE 4 //30
#define TIMELINE_ENTRIES_PER_PAGE 3 //10
/////////////////////////End App Macros/////////////////////////


//when adding,make sure they only work on dev and preprod//
///////////////////////////////////////////////////////////
#ifndef TARGET_PROD
//#define SET_DEFAULT_LANGUAGE_DE //sets the default language to german
//#define DEBUG_LOG_SHOW_VC_CLASS_NAME
#endif //TARGET_PROD

//////////////////////////END HACKS////////////////////////

///////////////////////////WIP///////////////////////////
#ifndef TARGET_PROD
//#define WIP_TIMELINE
#endif
//////////////////////////END WIP////////////////////////

// Defines check
// We must not be able to have 2 targets active at the same time
#ifdef TARGET_DEV
    #if defined(TARGET_PRE_PROD) || defined(TARGET_PROD)
        #error You cannot define 2 prod targets at the same tine
    #endif//defined(TARGET_PRE_PROD) || defined(TARGET_PROD)
#endif//TARGET_DEV

#ifdef TARGET_PRE_PROD
    #if defined(TARGET_DEV) || defined(TARGET_PROD)
        #error You cannot define 2 prod targets at the same tine
    #endif//defined(TARGET_DEV) || defined(TARGET_PROD)
#endif//TARGET_PRE_PROD

#ifdef TARGET_PROD
    #if defined(TARGET_DEV) || defined(TARGET_PRE_PROD)
        #error You cannot define 2 prod targets at the same tine
    #endif//defined(TARGET_DEV) || defined(TARGET_PRE_PROD)
#endif//TARGET_PROD

#if !defined(TARGET_DEV) && !defined(TARGET_PRE_PROD) && !defined(TARGET_PROD)
    #error At least one target must be defined
#endif //!defined(TARGET_DEV) && !defined(TARGET_PRE_PROD) && !defined(TARGET_PROD)
#endif
