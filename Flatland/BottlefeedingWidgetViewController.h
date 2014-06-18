//
//  BottlefeedingWidgetViewController.h
//  Flatland
//
//  Created by Jochen Block on 02.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetViewController.h"
#import "SwipeView.h"
#import "LastDateService.h"

@interface BottlefeedingWidgetViewController : WidgetViewController <SwipeViewDelegate>
@property (nonatomic, copy) NSString *descriptionLabelText;
@property (nonatomic, copy) NSDate *date;
@property (strong, nonatomic) IBOutlet UIButton *zoomButton;
/// create a new Widget with the given baby
- (IBAction)zoomGraph:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *periodLabelDescription;
+ (BottlefeedingWidgetViewController *)widgetWithBaby:(Baby *)baby;
@end
