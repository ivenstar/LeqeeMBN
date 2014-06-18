//
//  CartPickDayViewController.h
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"

@protocol CartPickDayViewControllerDelegate
@required

- (void)datePicked:(NSDate *)date;

@end

/**
 * Allows the user to pick a day for Colizen delivery.
 * You must set a date and a delegate.
 * The `CartPickDayViewControllerDelegate` is informed about the new date.
 */
@interface CartPickDayViewController : FlatViewController

@property (nonatomic, weak) id<CartPickDayViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDate *date;

@end
