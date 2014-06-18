//
//  WidgetViewController.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 30.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetView.h"
#import "Baby.h"
#import "CalendarView.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeFeedsDelegate.h"
#import "ShareVC.h"
#import <Social/Social.h>

@class HomeViewController;

@interface WidgetViewController : UIViewController

@property (nonatomic, strong) Baby *baby;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) NSNumber *dateIndex;
@property (nonatomic, strong) UINavigationController *originNavigationController;
@property (strong, nonatomic) IBOutlet WidgetView *widgetView;
@property (strong, nonatomic) IBOutlet UILabel *titleText;
@property (nonatomic,weak) id<HomeFeedsDelegate> delegateHome;
@property (nonatomic, weak) HomeViewController *parentView;
//start and end dates used in graphs share title
@property (nonatomic, strong) NSString *shareStartDate;
@property (nonatomic, strong) NSString *shareEndDate;
//
+ (NSString *)widgetIdentifier;

- (void)updateWidget;
- (void)showLoadingOverlay;
- (void)hideLoadingOverlay;
- (IBAction)share:(id)sender;
- (UIImage*) getScreenImage;

@end
