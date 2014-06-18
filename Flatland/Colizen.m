//
//  Colizen.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 30.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Colizen.h"
#import "RESTService.h"

@implementation Colizen

static id _shippingConfiguration;

+ (void)loadShippingConfiguration:(void(^)(BOOL success))completion {
    if (_shippingConfiguration) {
        return completion(YES);
    }
    [[RESTService sharedService] queueRequest:[RESTRequest getURL:@"/babynes/documents?key=shippingconfig"]
                                   completion:^(RESTResponse *response) {
                                       if (response.success) {
                                           _shippingConfiguration = response.object;
                                           completion(YES);
                                           NSLog(@"colizenr: %@", _shippingConfiguration);
                                       } else {
                                           completion(NO);
                                       }
                                   }];
}

+ (BOOL)isZIPCodeValidForColizen:(NSString *)ZIPCode {
    static NSRegularExpression *zipCodeRE = nil;
    if (!zipCodeRE) {
        NSString *pattern = [_shippingConfiguration valueForKey:@"zipregex"];
        if (!pattern) {
            pattern = @"^(75|9[234]|78000|781[014567]0|782[239]0|783[68]0|784[03]0|78560)";
        }
        zipCodeRE = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    }
    return [zipCodeRE numberOfMatchesInString:ZIPCode options:0 range:NSMakeRange(0, [ZIPCode length])] > 0;
}

+ (NSString *)invalidZIPCodeErrorMessage {
    NSString *errorMessage = [_shippingConfiguration valueForKey:@"errormessage"];
    if (!errorMessage) {
        errorMessage = @"Le mode de livraison \"Express avec rendez-vous\" est uniquement disponible à Paris (75), petite couronne (92, 93, 94) et certaines communes des Yvelines.";
    }
    return errorMessage;
}

#pragma mark

/// Returns the today's date at 00:00:00 based on the local time zone, that is only the year/month/day part of a timestamp.
+ (NSDate *)today {
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setTimeZone:[NSTimeZone defaultTimeZone]];
    [df setDateFormat:@"yyyy-MM-dd"];
    return [df dateFromString:[df stringFromDate:today]];
}

/// Returns the date in \c days days and \c hour hours from now.
+ (NSDate *)dateInDays:(NSInteger)days hour:(NSInteger)hour {
    return [[self today] dateByAddingTimeInterval:days * 24 * 60 * 60 + hour * 60 * 60];
}

/// Returns the number of full days between "now" and the specified date.
+ (NSInteger)daysFromDateSinceNow:(NSDate *)date {
    return [date timeIntervalSinceDate:[self today]] / (24 * 60 * 60);
}

/// Returns the number of full hours between "now" and the specified date.
+ (NSInteger)hoursFromDate:(NSDate *)date {
    return [date timeIntervalSinceDate:[self dateInDays:[self daysFromDateSinceNow:date] hour:0]] / (60 * 60);
}

/// Returns the weekday of the given date, Sunday being 1, Monday being 2, and so on.
+ (NSInteger)weekdayFromDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    return [components weekday];
}

/// Computes the earliest date based on these rules: Before 14:00, its today, 18:00 or on Monday 18:00
/// if today is Saturday or Sunday. After 14:00, its the next working day, 18:00 for Sunday and Monday
/// to Thursday and Monday 18:00 if today is Friday or Saturday.
/// MKA 130828: Changed from 14:00 to 12:00 
+ (NSDate *)earliestRendezvousDate {
    // compute the day of the week
    int weekday = [self weekdayFromDate:[NSDate date]];
    
    if ([self hoursFromDate:[NSDate date]] < 12) {
        // orders placed before 14:00 can be picked up today or on the next working day at 18:00
        switch (weekday) {
            case 1: // Sunday -> Monday
                return [self dateInDays:1 hour:18];
            case 7: // Saturday -> Monday
                return [self dateInDays:2 hour:18];
            default: // Monday to Friday -> Monday to Friday
                return [self dateInDays:0 hour:18];
        }
    } else {
        // orders placed after 14:00 can be picked up next working day at 18:00
        switch (weekday) {
            case 6: // Friday -> Monday
                return [self dateInDays:3 hour:18];
            case 7: // Saturday -> Monday
                return [self dateInDays:2 hour:18];
            default: // Sunday, Monday to Thursday -> Monday, Tuesday to Friday
                return [self dateInDays:1 hour:18];
        }
    }
}

/// Computes the earliest rendezvous hour for the given date based on these rules: If the date's day is the
/// earliest day based on +earliestRendezvousDate, use the associated earliest hour, otherwise its 07:00.
+ (NSInteger)minHourForDate:(NSDate *)date {
    NSDate *earliestDate = [self earliestRendezvousDate];
    NSInteger eDays = [self daysFromDateSinceNow:earliestDate];
    NSInteger nDays = [self daysFromDateSinceNow:date];
    return eDays == nDays ? [self hoursFromDate:earliestDate] : 8;
}

/// Computes the latest rendezvous hour for the given date.
+ (NSInteger)maxHourForDate:(NSDate *)date {
    if ([self weekdayFromDate:date] == 1) {
        return 11;
    }
    return 20;
}

/// Normalize date to 07:00 - 20:00 on all days but Sunday and 09:00 - 11:00 on Sundays.
+ (NSDate *)normalizeDate:(NSDate *)date {
    NSInteger hour = [self hoursFromDate:date];

    if ([self weekdayFromDate:date] == 1) {
        if (hour < 8) {
            hour = 8;
        }
        if (hour > 10) {
            hour = 10;
        }
    } else {
        NSInteger minHour = [self minHourForDate:date];
        NSInteger maxHour = [self maxHourForDate:date];
        if (hour < minHour) {
            hour = minHour;
        }
        if (hour > maxHour) {
            hour = maxHour;
        }
    }
    return [self dateInDays:[self daysFromDateSinceNow:date] hour:hour];
}

@end
