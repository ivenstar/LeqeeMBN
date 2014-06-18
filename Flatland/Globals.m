//
//  Globals.m
//  Flatland
//
//  Created by Stefan Aust on 13.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Globals.h"
#import "Specific.h"
#import "AlertView.h"
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "Country.h"
#import "State.h"
#import "NBPhoneNumber.h"
#import "NBPhoneNumberUtil.h"
#import "FaqSection.h"



//Babynes SSID name
NSString * const BabyNesID = @"BABYNES";

@implementation UIColor (ICNH)

+ (UIColor *)colorWithRGBString:(NSString *)rgbString {
    if (!rgbString) {
        return nil;
    }
    unsigned rgb;
    NSScanner *scanner = [NSScanner scannerWithString:rgbString];
    [scanner scanString:@"#" intoString:NULL];
    [scanner scanHexInt:&rgb];
    
    CGFloat red = (rgb >> 16) / 255.0;
    CGFloat green = ((rgb >> 8) & 255) / 255.0;
    CGFloat blue = (rgb & 255) / 255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}
@end
@implementation UIImage (BabyNes)

//Ionel
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)rotatedImage
{
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = self.imageOrientation;
    
    switch(orient)
    {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI + M_PI_2);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, M_PI + M_PI_2);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        default:
            break;
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -1, 1);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (UIImage*)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end


@implementation UIFont (BabyNes)

+ (UIFont *)thinFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Bariol-Thin" size:fontSize];
}

+ (UIFont *)lightFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Bariol-Light" size:fontSize];
}

+ (UIFont *)regularFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Bariol-Regular" size:fontSize];
}

+ (UIFont *)boldFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Bariol-Bold" size:fontSize];
}

@end


static UIFont *ReplaceFont(UIFont *font) {
    if  (font) {
        static NSDictionary *replacements = nil;
        if (!replacements) {
            replacements = @{@".HelveticaNeueUI": @"Bariol-Regular",
                             @".HelveticaNeueUI-Bold": @"Bariol-Bold",
                             @".HelveticaNeueUI-Italic": @"Bariol-Light",
                             @".HelveticaNeueInterface-M3": @"Bariol-Regular",
                             @".HelveticaNeueInterface-M3-Bold": @"Bariol-Bold",
                             @".HelveticaNeueInterface-M3-Italic": @"Bariol-Light"};
        }
        NSString *fontName = replacements[font.fontName];
        if (fontName) {
            font = [UIFont fontWithName:fontName size:font.pointSize];
        }
    }
    return font;
}

@implementation UIView (BabyNes)

- (void)changeSystemFontToApplicationFont {
    for (UIView *view in self.subviews) {
        [view changeSystemFontToApplicationFont];
    }
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

+ (UIView*) enumerateAllSubviewsOf: (UIView*) view UsingBlock: (BOOL (^)( UIView* view )) block {
    
    for ( UIView* subview in view.subviews )
    {
        if( block( subview ))
        {
            return subview;
        }
        else if(![ subview isKindOfClass: [ UIControl class ]])
        {
            UIView* result = [ self enumerateAllSubviewsOf: subview UsingBlock: block ];
            
            if( result != nil )
            {
                return result;
            }
        }
    }
    
    return nil;
}

@end


@implementation UILabel (BabyNes)

- (void)changeSystemFontToApplicationFont {
    [super changeSystemFontToApplicationFont];
    self.font = ReplaceFont(self.font);
}

@end


@implementation NSString (ICNH)

- (NSAttributedString *)attributedTextFromHTMLStringWithFont:(UIFont *)font {
    NSMutableAttributedString *t = [[NSMutableAttributedString alloc] init];
    NSMutableDictionary *a = [[NSMutableDictionary alloc] init];
    [a setObject:font forKey:NSFontAttributeName];
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"<([^>]+)>|&([^;]+);|([^<&]+)" options:0 error:NULL];
    [re enumerateMatchesInString:self options:0
                           range:NSMakeRange(0, [self length])
                      usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                          if ([result rangeAtIndex:1].location != NSNotFound) { // it's a start or end tag
                              NSString *tag = [[self substringWithRange:[result rangeAtIndex:1]] lowercaseString];
                              if ([tag isEqualToString:@"b"] || [tag isEqualToString:@"strong"]) {
                                  [a setObject:[UIFont boldFontOfSize:font.pointSize] forKey:NSFontAttributeName];
                              } else if ([tag isEqualToString:@"/b"] || [tag isEqualToString:@"/strong"]) {
                                  [a setObject:font forKey:NSFontAttributeName];
                              } else if ([tag isEqualToString:@"i"]) {
                                  [a setObject:[UIFont lightFontOfSize:font.pointSize] forKey:NSFontAttributeName];
                              } else if ([tag isEqualToString:@"/i"]) {
                                  [a setObject:font forKey:NSFontAttributeName];
                              } else  if ([tag isEqualToString:@"u"]) {
                                  [a setObject:@1 forKey:NSUnderlineStyleAttributeName];
                              } else  if ([tag isEqualToString:@"/u"]) {
                                  [a removeObjectForKey:NSUnderlineStyleAttributeName];
                              } else {
                                  return; // unknown tag
                              }
                          } else if ([result rangeAtIndex:2].location != NSNotFound) { // it's an entity
                              NSString *entity = [[self substringWithRange:[result rangeAtIndex:2]] lowercaseString];
                              NSString *character;
                              if ([entity isEqualToString:@"lt"]) {
                                  character = @"<";
                              } else if ([entity isEqualToString:@"gt"]) {
                                  character = @">";
                              } else if ([entity isEqualToString:@"amp"]) {
                                  character = @"&";
                              } else if ([entity isEqualToString:@"quot"]) {
                                  character = @"\"";
                              } else {
                                  if ([entity hasPrefix:@"#x"]) {
                                      NSScanner *s = [NSScanner scannerWithString:entity];
                                      [s setScanLocation:2];
                                      unsigned int value;
                                      if ([s scanHexInt:&value]) {
                                          character = [NSString stringWithFormat:@"%C", (unichar)value];
                                      } else {
                                          character = @"";
                                      }
                                  } else if ([entity hasPrefix:@"#"]) {
                                      NSScanner *s = [NSScanner scannerWithString:entity];
                                      [s setScanLocation:1];
                                      int value;
                                      if ([s scanInt:&value]) {
                                          character = [NSString stringWithFormat:@"%C", (unichar)value];
                                      } else {
                                          character = @"";
                                      }
                                  } else {
                                      character = @"";
                                  }
                              }
                              if ([character length]) {
                                  [t appendAttributedString:[[NSAttributedString alloc] initWithString:character attributes:a]];
                              }
                          } else {
                              NSString *text = [self substringWithRange:[result rangeAtIndex:3]];
                              [t appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:a]];
                          }
                      }];
    return t;
}

@end


@implementation NSArray (ICNH)

- (NSArray *)arrayByRemovingObject:(id)object {
    NSMutableArray *array = [self mutableCopy];
    [array removeObject:object];
    return [array copy];
}

@end

@implementation NSArray (Reverse)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end

@implementation NSMutableArray (Reverse)

- (void)reverse {
    if ([self count] == 0)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

@end


@implementation UIColor (BabyNes)


+ (UIColor*) BabyNesDarkPurpleColor
{
    static UIColor* s_BabyNesDarkPurpleColor;
    if (nil == s_BabyNesDarkPurpleColor)
    {
       s_BabyNesDarkPurpleColor = [UIColor colorWithRed:52.0f/255.0f green:48.0f/255.0f blue:78.0f/255.0f alpha:1.0f];
    }
    
    return s_BabyNesDarkPurpleColor;
}

+ (UIColor*) BabyNesLightPurpleColor
{
    static UIColor* s_BabyNesLightPurpleColor;
    if (nil == s_BabyNesLightPurpleColor)
    {
        s_BabyNesLightPurpleColor =[UIColor colorWithRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha: 1];
    }
    
    return s_BabyNesLightPurpleColor;
}

@end

@implementation UIViewController (BabyNes)

- (void)fitTitle
{
    if (self.navigationItem.titleView != nil)//this is only meant to fit string titles
    {
        return;
    }
    
    //get title label width
    float titleLabelWidth = self.view.frame.size.width - self.navigationItem.leftBarButtonItem.customView.frame.size.width - self.navigationItem.rightBarButtonItem.customView.frame.size.width - 20;
    
    if (IS_IOS7)//extra padding on ios7
    {
        if (self.navigationItem.leftBarButtonItem.customView)
        {
         titleLabelWidth -= 15;
        }
        if (self.navigationItem.rightBarButtonItem.customView)
        {
            titleLabelWidth -= 15;
        }
    }
    
    //get font
    UIFont *titleViewFont = [[[UINavigationBar appearance] titleTextAttributes] objectForKey:UITextAttributeFont];
    UIColor *textColor = [[[UINavigationBar appearance] titleTextAttributes] objectForKey:UITextAttributeTextColor];
    
    NSString* titleViewText = self.navigationItem.title;
    GLfloat originalPointSize = titleViewFont.pointSize;
    
    if ([titleViewText sizeWithFont:titleViewFont].width > titleLabelWidth)
    {
        //make it fit
        while ([titleViewText sizeWithFont:titleViewFont].width > titleLabelWidth && titleViewFont.pointSize > originalPointSize*2/3)
        {
            //make font smaller
            titleViewFont = [UIFont fontWithName:titleViewFont.fontName size:titleViewFont.pointSize -1];
        }
        
        CGRect frame = CGRectMake(0, 0, titleLabelWidth, 64);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = textColor!=nil ? textColor : [UIColor whiteColor];
        label.text = self.navigationItem.title;
        
        if (false && titleViewFont.pointSize > originalPointSize/2)
        {
            label.font = titleViewFont;
        }
        else
        {
            UIFont *originalFont = [[[UINavigationBar appearance] titleTextAttributes] objectForKey:UITextAttributeFont];
            label.font = [UIFont fontWithName:originalFont.fontName size:16];
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.numberOfLines = 2;
        }
        self.navigationItem.titleView = label;
    }

}

@end

UIBarButtonItem *MakeImageBarButton(NSString *imageName, id target, SEL selector) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 37, 37);
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


// deal with locales --------------------------------------------------------------------------------

static NSString * const kAppleLanguages = @"AppleLanguages";


// return the current locale; it is cached because accessing this object is expensive
NSLocale *CurrentLocale() {
    static NSLocale *currentLocale = nil;
    currentLocale = [NSLocale currentLocale];
    // remove any override to get the pristine system default
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAppleLanguages];
    [[NSUserDefaults standardUserDefaults] synchronize];
        
    currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:[NSString stringWithFormat:@"%@_%@", @"de", @"DE"]];
        
    // now force the system default to the current locale so that localized resources work as expected
    //[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:currentLocale] forKey:kAppleLanguages];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

    return [NSLocale currentLocale];
}

// return the current country code, for example CH or DE
NSString *CountryCode() {
    return [CurrentLocale() objectForKey:NSLocaleCountryCode];
}

// return the current language code, for example fr or de
NSString *LanguageCode() {
    return [CurrentLocale() objectForKey:NSLocaleLanguageCode];
}



BOOL IsEmpty(NSString *s) {
    return [[s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0;
}

BOOL ValidateEmailAddress(NSString *addressString) {
    if([addressString length] > 50) {
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:addressString];
}

BOOL ValidateName(NSString *nameString, int maxLength) {
    if([nameString length] > maxLength) {
        return NO;
    }
    NSError *error = NULL;
    NSString *nameRegex = @"\\p{L}+[\\p{L}-^ '`´]*";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:nameRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:nameString options:0 range:NSMakeRange(0, [nameString length])];

    return match != nil;
}

NSString *StringFromJSONObject(id object) {
    return object == [NSNull null] ? nil : (NSString *)object;
}

NSArray *ArrayFromJSONObject(id object) {
    return object == [NSNull null] ? nil : (NSArray *)object;
}

NSDate *DateFromJSONValue(id value) {
    if (value == [NSNull null]) {
        return nil;
    }
    //Ionel fix for new magento API
    if (![value isKindOfClass:[NSString class]])
    {
        value = [value stringValue];
    }
    //
    if ([value length]) {
        
        long long d = [value longLongValue];
        return [NSDate dateWithTimeIntervalSince1970:d];
        
    }
    return nil;

}

//old DateFromJSONValue(id value), before Magento
/*
NSDate *DateFromJSONValue(id value) {
    if (value == [NSNull null]) {
        return nil;
    }
    //Ionel fix for new magento API
    value = [value stringValue];
    //
    if ([value length]) {
        static NSRegularExpression *re = nil;
        if (!re) {
            re = [NSRegularExpression regularExpressionWithPattern:@"/Date\\((\\d+)([-+]\\d+)\\)/" options:0 error:NULL];
        }
        NSTextCheckingResult *match = [re firstMatchInString:value options:0 range:NSMakeRange(0, [value length])];
        if (match) {
            long long milliseconds = [[value substringWithRange:[match rangeAtIndex:1]] longLongValue];
            int timezone = [[value substringWithRange:[match rangeAtIndex:2]] intValue];
            return [NSDate dateWithTimeIntervalSince1970:milliseconds / 1000 + timezone / 100 * 60 * 60];
        }
    }
    return nil;
}
 */
/*
//doesn't work with new Magento API
NSDate *DateWithoutTimezoneFromJSONValue(id value) {
    if (value == [NSNull null]) {
        return nil;
    }
    //Ionel fix for new magento API
    value = [value stringValue];
    //
    if ([value length]) {
        static NSRegularExpression *re = nil;
        if (!re) {
            re = [NSRegularExpression regularExpressionWithPattern:@"/Date\\((\\d{13})\\)/" options:0 error:NULL];
        }
        NSTextCheckingResult *match = [re firstMatchInString:value options:0 range:NSMakeRange(0, [value length])];
        if (match) {
            long long milliseconds = [[value substringWithRange:[match rangeAtIndex:1]] longLongValue];
            return [NSDate dateWithTimeIntervalSince1970:milliseconds / 1000];
        }
    }
    return nil;
}
*/
//new code for magento API
NSDate *DateWithoutTimezoneFromJSONValue(id value) {
    if (value == [NSNull null]) {
        return nil;
    }
    //Ionel fix for new magento API
    value = [value stringValue];
    //
    if ([value length]) {
        
        long long d = [value longLongValue];
            return [NSDate dateWithTimeIntervalSince1970:d];
    
    }
    return nil;
}
////

id JSONValueFromDate(NSDate *date) {
    if (date)
    {
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:date];
        //NSLog(@"hinterval: %d", interval/3600);
        date = [date dateByAddingTimeInterval:interval];
        //// old API
        //return [NSString stringWithFormat:@"/Date(%lld)/", (long long)[date timeIntervalSince1970] * 1000];
        ////new magento API
        return [NSString stringWithFormat:@"%lld", (long long)[date timeIntervalSince1970]];
    }
    return [NSNull null];
}

// Hotfix
id JSONValueFromDateWithoutAddingTimeZoneDiff(NSDate *date) {
    if (date) {
        return [NSString stringWithFormat:@"%lld", (long long)[date timeIntervalSince1970]];
    }
    return [NSNull null];
}

id JSONValueFromDateWithTimezone(NSDate *date) {
    if (date) {
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:date];
        //NSLog(@"hinterval: %d", interval/3600);
        date = [date dateByAddingTimeInterval:interval];
        return [NSString stringWithFormat:@"%lld", (long long)[date timeIntervalSince1970]];
    }
    return [NSNull null];
}

id ObjectFromJSONValue(id value) {
    return value == [NSNull null] ? nil : value;
}

id JSONValueFromObject(id object) {
    return object ? object : [NSNull null];
}

NSString *Base64forData(NSData *theData) {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

NSString *URLencodeForString(NSString *string){
    NSString *encoded;
    encoded = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                          NULL,
                                                                          (CFStringRef)string,
                                                                          NULL,
                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                          kCFStringEncodingUTF8 ));
    return encoded;
}

id GetJSONResource(NSString *name) {
    NSURL *URL = nil;
    for (NSString *localization in [[NSBundle mainBundle] preferredLocalizations]) {
        URL = [[NSBundle mainBundle] URLForResource:name
                                      withExtension:@"json"
                                       subdirectory:nil
                                       localization:localization];
        if (URL) {
            break;
        }
    }
    if (!URL) {
        NSString *region = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleDevelopmentRegionKey];
        URL = [[NSBundle mainBundle] URLForResource:name
                                      withExtension:@"json"
                                       subdirectory:nil
                                       localization:[region substringToIndex:2]];
    }
    NSData *data = [NSData dataWithContentsOfURL:URL];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
}

NSString *FormatPrice(NSInteger price) {
    NSNumberFormatter *nf = [NSNumberFormatter new];
    [nf setPositiveFormat:T(@"$ 0.00")];
    [nf setLocale:CurrentLocale()];
    NSString *string = [nf stringFromNumber:[NSNumber numberWithDouble:price / 100.0]];
    if ([T(@"moneyunit") isEqualToString:@"CHF"] && [string hasSuffix:@"00"]) {
        string = [[string substringToIndex:[string length] - 2] stringByAppendingString:@"-"];
    }
    return string;
}

void CallSupport() {
    NSURL *supportURL = [NSURL URLWithString:T(@"support.phonenumber")];
    
    if ([[UIApplication sharedApplication] canOpenURL:supportURL]) {
        [[UIApplication sharedApplication] openURL:supportURL];
    } else {
        [AlertView alertViewFromString:T(@"support.nophone") buttonClicked:nil];
    }
}

NSString *GetSSID(){
    //get SSID
    CFArrayRef myArray = CNCopySupportedInterfaces();
    CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
    NSLog(@"Connected at:%@",myDict);
    NSDictionary *myDictionary = (__bridge_transfer NSDictionary*)myDict;
    NSString * SSID = [myDictionary objectForKey:@"SSID"];
    NSLog(@"ssid is %@",SSID);
    return SSID;
}

BOOL MatchesRegex(NSString* string,NSString* regex)
{
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:string];
}

// get Growth Path from JSON
NSArray *AboveCurveFromJSON() {
    static NSArray *curve;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *array = [NSMutableArray array];
        for (id value in GetJSONResource(@"growth_path")) {
            [array addObject:value[@"95th"]];
        }
        curve = [array copy];
    });
    return curve;
}

NSArray *MidCurveFromJSON() {
    static NSArray *curve;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *array = [NSMutableArray array];
        for (id value in GetJSONResource(@"growth_path")) {
            [array addObject:value[@"50th"]];
        }
        curve = [array copy];
    });
    return curve;
}

NSArray *BelowCurveFromJSON() {
    static NSArray *curve;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *array = [NSMutableArray array];
        for (id value in GetJSONResource(@"growth_path")) {
            [array addObject:value[@"5th"]];
        }
        curve = [array copy];
    });
    return curve;
}

NSArray *GrowthPathFromJSON(int gender) {
    static NSArray *downCurve;
    static NSArray *midCurve;
    static NSArray *upCurve;
    static NSArray *array;
    double a, b, c;
    
        NSMutableArray *arrayDown = [NSMutableArray array];
        NSMutableArray *arrayMid = [NSMutableArray array];
        NSMutableArray *arrayUp = [NSMutableArray array];
        for (id value in GetJSONResource(@"growth_path")) {
            if ([value[@"gender"] integerValue] == gender) {
                a = [value[@"5th"] doubleValue];
                b = [value[@"50th"] doubleValue];
                c = [value[@"95th"] doubleValue];
#ifdef BABY_NES_US
                //convert to pounds (from default kg)
                a = a * 2.20462;
                b = b * 2.20462;
                c = c * 2.20462;
#endif //BABY_NES_US
                [arrayDown addObject:[NSNumber numberWithDouble:a]];
                [arrayMid addObject:[NSNumber numberWithDouble:b]];
                [arrayUp addObject:[NSNumber numberWithDouble:c]];
            }
        }
        downCurve = [arrayDown copy];
        midCurve = [arrayMid copy];
        upCurve = [arrayUp copy];
        array = [NSArray arrayWithObjects:downCurve, midCurve, upCurve, nil];
    return array;
}

extern NSArray *PartialGrowthPathFromJSON(int gender,int start,int end)
{
    NSArray *growth = GrowthPathFromJSON(gender);
    start = start >=0 ? start : 0;
    end = end <= [[growth objectAtIndex:0] count] - 1 ? end : [[growth objectAtIndex:0] count] - 1;
    
    NSArray *d,*m,*u;
    NSMutableArray *md = [NSMutableArray array];
    NSMutableArray *mm = [NSMutableArray array];
    NSMutableArray *mu = [NSMutableArray array];
    float avg1;
    float avg2;
    float avg3;
    for (int i = start;i<end;i++)
    {
        //create values per day from weekely values we got from growth JSON
        //interpolate data
        avg1 = ([[[growth objectAtIndex:0] objectAtIndex:(i+1)] doubleValue] - [[[growth objectAtIndex:0] objectAtIndex:i] doubleValue])/7;
        avg2 = ([[[growth objectAtIndex:1] objectAtIndex:(i+1)] doubleValue] - [[[growth objectAtIndex:1] objectAtIndex:i] doubleValue])/7;
        avg3 = ([[[growth objectAtIndex:2] objectAtIndex:(i+1)] doubleValue] - [[[growth objectAtIndex:2] objectAtIndex:i] doubleValue])/7;
        for (int j=0; j<=6; j++){
            double aux = [[[growth objectAtIndex:0] objectAtIndex:i] doubleValue] + (avg1*j);
            [md addObject:[NSNumber numberWithDouble:aux]];
            aux = [[[growth objectAtIndex:1] objectAtIndex:i] doubleValue] + (avg2*j);
            [mm addObject:[NSNumber numberWithDouble:aux]];
            aux = [[[growth objectAtIndex:2] objectAtIndex:i] doubleValue] + (avg3*j);
            [mu addObject:[NSNumber numberWithDouble:aux]];
        }
    }
    //add last week
    for (int j=0; j<=6; j++){
        //float avg = ([[growth objectAtIndex:0] objectAtIndex:i+1] - [[growth objectAtIndex:0] objectAtIndex:i])/7;
        double aux = [[[growth objectAtIndex:0] objectAtIndex:end] doubleValue] + (avg1*j);
        [md addObject:[NSNumber numberWithDouble:aux]];
        aux = [[[growth objectAtIndex:1] objectAtIndex:end] doubleValue] + (avg2*j);
        [mm addObject:[NSNumber numberWithDouble:aux]];
        aux = [[[growth objectAtIndex:2] objectAtIndex:end] doubleValue] + (avg3*j);
        [mu addObject:[NSNumber numberWithDouble:aux]];    }
    
    d = [md copy];
    m = [mm copy];
    u = [mu copy];
    
    return [NSArray arrayWithObjects:d,m,u, nil];
}

NSArray *StatesUSJSON()
{
    static NSArray *usStates;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *array = [NSMutableArray array];
        for (id value in GetJSONResource(@"regions"))
        {
            
            if ([value[@"country_id"] isEqualToString:@"US"])
            {
                [array addObject:[[State alloc] initWithCode:value[@"code"] andName:value[@"default_name"]]];
            }
        }
        usStates = [array copy];
    });
    return usStates;
}

NSArray *CountriesJSON()
{
    static NSArray *countries;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *array = [NSMutableArray array];
        for (id value in GetJSONResource(@"countries"))
        {
            //NSDictionary with one key
            if ([[(NSDictionary*) value allKeys] count] > 0)
            {
                NSString* key = [[(NSDictionary*) value allKeys] objectAtIndex:0];
                [array addObject:[[Country alloc] initWithCode:key andName:[(NSDictionary*) value objectForKey:key]]];
            }
        }
        countries = [array copy];
    });
    return countries;
}

#define FAQ_SECTIONS_TITLE_KEY @"Title"
#define FAQ_SECTIONS_PAGE_KEY @"Page"

NSArray *FAQSectionsJSON()
{
    static NSArray *faqSections;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *array = [NSMutableArray array];
        for (id value in GetJSONResource(@"faqSections"))
        {
            //NSDictionary with 2 keys
            if ([[(NSDictionary*) value allKeys] count] > 0)
            {
                FaqSection *section = [[FaqSection alloc] init];
                section.title = [(NSDictionary*) value objectForKey:FAQ_SECTIONS_TITLE_KEY];
                section.page = [(NSDictionary*) value objectForKey:FAQ_SECTIONS_PAGE_KEY];
                
                [array addObject:section];
            }
        }
        faqSections = [array copy];
    });
    return faqSections;
}

int WeeksBetween(NSDate *dt1, NSDate *dt2) {
    NSUInteger unitFlags = NSWeekCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return abs([components week]+1);
}

int DaysBetween(NSDate *dt1, NSDate *dt2) {
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return [components day];
}

BOOL MobileShouldChangeCharactersInRange(UITextField *textField,NSRange range,NSString* string)
{
    // For some reason, the 'range' parameter isn't always correct when backspacing through a phone number
    // This calculates the proper range from the text field's selection range.
    UITextRange *selRange = textField.selectedTextRange;
    UITextPosition *selStartPos = selRange.start;
    UITextPosition *selEndPos = selRange.end;
    NSInteger start = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selStartPos];
    NSInteger end = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selEndPos];
    NSRange repRange;
    if (start == end)
    {
        if (string.length == 0)
        {
            repRange = NSMakeRange(start - 1, 1);
        }
        else
        {
            repRange = NSMakeRange(start, end - start);
        }
    }
    else
    {
        repRange = NSMakeRange(start, end - start);
    }
    
    // This is what the new text will be after adding/deleting 'string'
    NSString *txt = [textField.text stringByReplacingCharactersInRange:repRange withString:string];
    
    NBEPhoneNumberFormat format = NBEPhoneNumberFormatNATIONAL;
    NSString *phone = nil;
    NSError *fromatError = nil;
    NBPhoneNumberUtil *phoneUtil = [NBPhoneNumberUtil sharedInstance];
    
    NBPhoneNumber *phoneNumber = [phoneUtil parse:txt defaultRegion:kCountryCode error:&fromatError];
    
    if (nil == fromatError)
    {
        // This is the newly formatted version of the phone number
        phone = [phoneUtil format:phoneNumber numberFormat:format
                            error:&fromatError];
        if (fromatError == nil && phone != nil)
        {
            if ([phone isEqualToString:txt])
            {
                return YES;
            }
            else
            {
                
                NSMutableCharacterSet *phoneChars = [[NSCharacterSet decimalDigitCharacterSet] mutableCopy];
                [phoneChars addCharactersInString:@"+*#,"];
                
                // The two are different which means the adding/removal of a character had a bigger effect
                // from adding/removing phone number formatting based on the new number of characters in the text field
                // The trick now is to ensure the cursor stays after the same character despite the change in formatting.
                // So first let's count the number of non-formatting characters up to the cursor in the unchanged text.
                int cnt = 0;
                for (NSUInteger i = 0; i < repRange.location + string.length; i++) {
                    if ([phoneChars characterIsMember:[txt characterAtIndex:i]]) {
                        cnt++;
                    }
                }
                
                // Now let's find the position, in the newly formatted string, of the same number of non-formatting characters.
                int pos = [phone length];
                int cnt2 = 0;
                for (NSUInteger i = 0; i < [phone length]; i++) {
                    if ([phoneChars characterIsMember:[phone characterAtIndex:i]]) {
                        cnt2++;
                    }
                    
                    if (cnt2 == cnt) {
                        pos = i + 1;
                        break;
                    }
                }
                
                
                
                // Replace the text with the updated formatting
                textField.text = phone;
                
                // Make sure the caret is in the right place
                UITextPosition *startPos = [textField positionFromPosition:textField.beginningOfDocument offset:pos];
                UITextRange *textRange = [textField textRangeFromPosition:startPos toPosition:startPos];
                textField.selectedTextRange = textRange;
                
                return NO;
            }
        }
    }
    
    return YES;
}

BOOL IsPhoneNumberValid(NSString* phoneNumber)
{
    NSError *fromatError = nil;
    NBPhoneNumberUtil *phoneUtil = [NBPhoneNumberUtil sharedInstance];
    NBPhoneNumber *number = [phoneUtil parse:phoneNumber defaultRegion:kCountryCode error:&fromatError];
    
    if (nil == fromatError)
    {
            return [phoneUtil isValidNumber:number];
    }
    
    return NO;
}

NSString* FormattedDateForTimeline(NSDate* date)
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setLocale:[NSLocale currentLocale]];
    [dateFormater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormater setDateFormat:[NSString stringWithFormat:@"%@",T(@"%timeline.date.format")]];
    
    return [dateFormater stringFromDate:date];
    return nil;
}
