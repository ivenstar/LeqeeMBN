//
//  WeightWidgetViewController.h
//  Flatland
//
//  Created by Jochen Block on 02.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetViewController.h"
#import "SwipeView.h"
//#import "GraphSwipeLandscapeVC.h"
#import "HomeFeedsDelegate.h"

@interface WeightWidgetViewController : WidgetViewController

@property (nonatomic, copy) NSString *descriptionLabelText;
@property (nonatomic) BOOL loadDone;
@property (nonatomic,weak) id<HomeFeedsDelegate> delegateHome;

+ (WeightWidgetViewController *)widgetWithBaby:(Baby *)baby;
- (IBAction)zoomGraph:(id)sender;

@end
