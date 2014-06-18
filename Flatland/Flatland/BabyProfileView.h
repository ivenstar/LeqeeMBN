//
//  BabyProfileView.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 03.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Baby.h"

@class BabyProfileView;

@protocol BabyProfileViewDelegate

/// called when a baby profile view should be removed
- (void)removeProfile:(BabyProfileView *)babyProfileView;

/// called when the view wants to present a new controller
- (void)presentController:(UIViewController *) controller;

@end

@interface BabyProfileView : NSObject

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, weak) IBOutlet UIImageView *babyPictureImageView;
@property (nonatomic, weak) id<BabyProfileViewDelegate> delegate;
@property (nonatomic, weak) UIToolbar *actionSheetToolbar;

/// show or hide the remove button below the form
- (void)showRemoveButton:(BOOL)show;

/// validate the fields and returns YES if everything is fine
- (BOOL) validateFields;

/// creates a Baby object from the fields (valid or not, does not matter)
- (Baby *) createBaby;

/// create a new baby profile view with the given delegate
+ (BabyProfileView *)babyProfileViewWithDelegate:(id<BabyProfileViewDelegate>)delegate;

@end
