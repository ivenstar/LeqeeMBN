//
//  EditBreastfeedingViewController.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 23.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatViewController.h"
#import "Baby.h"
#import "Breastfeeding.h"
#import "CalendarView.h"

@class ListBreastfeedingViewController;

/**
 * Edit/Create a breastfeeding entry
 */
@interface EditBreastfeedingViewController : FlatViewController <CalendarViewDelegate>

@property (nonatomic, strong) Baby *baby;
@property (nonatomic) BOOL isEditing;
@property (nonatomic, strong) Breastfeeding *breastfeeding;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, weak) ListBreastfeedingViewController *parentView;


@end
