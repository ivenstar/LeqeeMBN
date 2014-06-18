//
//  BreastfeedingWidgetViewController.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 30.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetViewController.h"
#import "SwipeView.h"
#import "LastDateService.h"

/**
 * Displays the breastfeeding data in a widget
 */
@interface BreastfeedingWidgetViewController : WidgetViewController
@property (strong, nonatomic) IBOutlet UIButton *zoomButton;
- (IBAction)zoomGraph:(id)sender;
@property (nonatomic, strong) NSString *descriptionText;

@end
