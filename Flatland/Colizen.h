//
//  Colizen.h
//  Flatland
//
//  Created by Stefan Matthias Aust on 30.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Provides helper methods to compute the correct rendezvous date for "Colizen" delivey mode.
 */
@interface Colizen : NSObject

/// Trigger loading the shipping configuration needed for the next two methods.
+ (void)loadShippingConfiguration:(void(^)(BOOL success))completion;

/// Tests whether the given ZIP code is valid for colizen delivery mode.
+ (BOOL)isZIPCodeValidForColizen:(NSString *)ZIPCode;

/// Returns an error message explaining the valid ZIP codes for colizen.
+ (NSString *)invalidZIPCodeErrorMessage;

/// Returns the date in \c days days and \c hour hours from now.
+ (NSDate *)dateInDays:(NSInteger)days hour:(NSInteger)hour;

/// Returns the number of full days between "now" and the specified date.
+ (NSInteger)daysFromDateSinceNow:(NSDate *)date;

/// Returns the number of full hours between "now" and the specified date.
+ (NSInteger)hoursFromDate:(NSDate *)date;

/// Returns the weekday of the given date, Sunday being 1, Monday being 2, and so on.
+ (NSInteger)weekdayFromDate:(NSDate *)date;

/// Computes the earliest rendezvous date (day and hour).
+ (NSDate *)earliestRendezvousDate;

/// Computes the earliest rendezvous hour for the given date.
+ (NSInteger)minHourForDate:(NSDate *)date;

/// Computes the latest rendezvous hour for the given date.
+ (NSInteger)maxHourForDate:(NSDate *)date;

/// Normalize date to 07:00 - 20:00 on all days but Sunday and 09:00 - 11:00 on Sundays.
+ (NSDate *)normalizeDate:(NSDate *)date;

@end
