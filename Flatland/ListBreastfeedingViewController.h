//
//  ListBreastfeedingViewController.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 29.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatViewController.h"
#import "Baby.h"

@class HomeViewController;

/**
 * Show a list of breastfeedings
 */
@interface ListBreastfeedingViewController : FlatViewController

@property (nonatomic, strong) Baby *baby;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, weak) HomeViewController *parentView;

@end
