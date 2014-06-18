//
//  Globals.h
//  Flatland
//
//  Created by Stefan Aust on 13.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

typedef NS_ENUM(NSInteger, Breastside) {
    BreastsideLeft = 0,
    BreastsiteRight = 1
};

extern UIBarButtonItem *MakeImageBarButton(NSString *imageName, id target, SEL selector);

/**
 * Adds a useful constructor method to `UIColor`.
 */
@interface UIColor (ICNH)

/// Returns a color object parsed from a 6-digit hex string (with an optional `#`).
+ (UIColor *)colorWithRGBString:(NSString *)rgbString;
@end

@interface UIImage (BabyNes)

//Ionel: create an image with a color background
+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage*)scaleToSize:(CGSize)size;

- (UIImage *)rotatedImage;//returns a new UIImage rotated using the old image orientation.Usefull for rotating pngs since they don't save orientation

@end


@interface UIFont (BabyNes)

+ (UIFont *)thinFontOfSize:(CGFloat)fontSize;
+ (UIFont *)lightFontOfSize:(CGFloat)fontSize;
+ (UIFont *)regularFontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldFontOfSize:(CGFloat)fontSize;

@end


@interface UIView (BabyNes)

/// changes all occurrences of system fonts to the application's custom font
/// (because the stupid InterfaceBuilder doesn't support changing label fonts)
- (void)changeSystemFontToApplicationFont;

// enumerates all the subviews of view recursevly until condition in block is true
+ (UIView*) enumerateAllSubviewsOf: (UIView*) view UsingBlock: (BOOL (^)( UIView* view )) block;

/// provides easier access to the layer's corner radius property
@property (nonatomic, assign) CGFloat cornerRadius;

@end


@interface NSString (ICNH)

/// convert a string with <b></b> and <u></u> HTML tags into an attributed string
- (NSAttributedString *)attributedTextFromHTMLStringWithFont:(UIFont *)font;

@end


@interface NSArray (ICNH)

- (NSArray *)arrayByRemovingObject:(id)object;

@end

@interface NSArray (Reverse)

- (NSArray *)reversedArray;

@end

@interface NSMutableArray (Reverse)

- (void)reverse;

@end

@interface UIColor (BabyNes)

+ (UIColor*) BabyNesDarkPurpleColor;
+ (UIColor*) BabyNesLightPurpleColor;

@end


@interface UIViewController (BabyNes)

- (void) fitTitle;//meant to fit title strings(not personalized views)

@end


/// returns the current locale, forced to the valid options
extern NSLocale *CurrentLocale();

/// returns the current locale's country code (either CH or FR)
extern NSString *CountryCode();

/// returns the current locale's language code (either fr or de)
extern NSString *LanguageCode();

/// returns localized string associated with the given key
extern NSString *T(NSString *key);

/// returns YES if the given string is empty after stripping all white space
extern BOOL IsEmpty(NSString *s);

/// returns YES if the given string is a valid email address NO otherwise
extern BOOL ValidateEmailAddress(NSString *addressString);

/// returns YES if the given string is a valid name (Starts with character, no numbers) NO otherwise
extern BOOL ValidateName(NSString *addressString, int maxLength);

/// returns a string or nil instead of `NSNull`
extern NSString *StringFromJSONObject(id value);

/// returns an array or nil instead of `NSNull`
extern NSArray *ArrayFromJSONObject(id value);

/// converts a .NET-style JSON-encoded date into a real date object, adding the time
/// zone so that these dates must be printed based on UTC and not on a local time zone
extern NSDate *DateFromJSONValue(id value);

extern NSDate *DateWithoutTimezoneFromJSONValue(id value);

/// converts a date object into a .NET-style JSON-encoded date string
extern id JSONValueFromDate(NSDate *date);

extern id JSONValueFromDateWithoutAddingTimeZoneDiff(NSDate *date);

extern id JSONValueFromDateWithTimezone(NSDate *date);

/// returns the JSON value as object, converting NSNull to nil
extern id ObjectFromJSONValue(id value);

/// returns the object as JSON value, converting nil to NSNull
extern id JSONValueFromObject(id object);

/// converts a NSData to a base64 encoded string
extern NSString *Base64forData(NSData *theData);
//Ionel url-encoding  method
extern NSString *URLencodeForString(NSString *string);

/// ?
extern id GetJSONResource(NSString *name);

/// format the given price (in cent) with two digit, prefixed/postfixed by the currency unit
extern NSString *FormatPrice(NSInteger price);

/// calls the support hotline or displays an error message
extern void CallSupport();
extern NSString *GetSSID();

//Checks if a string matches a regular expression
extern BOOL MatchesRegex(NSString* string,NSString* regex);

//get Growth Path from Json
extern NSArray *AboveCurveFromJSON();
extern NSArray *MidCurveFromJSON();
extern NSArray *BelowCurveFromJSON();
extern NSArray *GrowthPathFromJSON(int gender);
extern NSArray *PartialGrowthPathFromJSON(int gender,int start,int end); //returns growthpath from json from start to end index(weeks);

extern NSArray *CountriesJSON();
extern NSArray *StatesUSJSON(); //get US States from JSON

// faq sections
extern NSArray *FAQSectionsJSON(); //returns NSArray of FAQSections

//
extern int WeeksBetween(NSDate *dt1, NSDate *dt2);
extern int DaysBetween(NSDate *dt1, NSDate *dt2);
extern NSString * const BabyNesID;

//
extern BOOL MobileShouldChangeCharactersInRange(UITextField *textField,NSRange range,NSString* string);
extern BOOL IsPhoneNumberValid(NSString* phoneNumber);

//
extern NSString* FormattedDateForTimeline(NSDate* date);