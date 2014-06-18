//
//  BottlefeedingViewController.h
//  Flatland
//
//  Created by Jochen Block on 24.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatViewController.h"
#import "Baby.h"
#import "BottlefeedingEditViewController.h"

@class HomeViewController;

@interface BottlefeedingViewController : FlatViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) Baby *baby;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSArray *feedings;
@property (nonatomic, weak) HomeViewController *parentView;
@end
