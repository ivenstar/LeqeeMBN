//
//  CartPickHourViewController.h
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"

@protocol CartPickHourViewControllerDelegate
@required

- (void)datePicked:(NSDate *)date;

@end

/**
 * Allows the user to pick an hour for Colizen delivery.
 * You must set a date and a delegate.
 * The `CartPickHourViewControllerDelegate` is informed about the new date.
 */
@interface CartPickHourViewController : FlatViewController

@property (nonatomic, weak) id<CartPickHourViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDate *date;

@end
