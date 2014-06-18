//
//  BabyProfileView.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 03.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Baby.h"

@class BabyProfileViewController;

@protocol BabyProfileViewDelegate

/// called when a baby profile view should be removed
- (void)removeProfile:(BabyProfileViewController *)babyProfileView;

/// called when the view wants to present a new controller
- (void)presentController:(UIViewController *) controller;

@end

/**
 * Controller that is used as form controller for a baby profile
 * It is reused in the different baby edit szenarious
 */
@interface BabyProfileViewController : UIViewController

@property (nonatomic, weak) id<BabyProfileViewDelegate> delegate;
@property (nonatomic, weak) UIToolbar *actionSheetToolbar; // toolbar that should show the action sheet
@property (nonatomic, readonly) Baby *baby; //the baby object from the fields of the view

/// show or hide the remove button below the form
- (void)showRemoveButton:(BOOL)show;


/// Show or Hide Bottle Size Segmented Contrl and Associated Label
- (void) setCapsuleSizeOptionHidden:(BOOL) hidden;

///Show or Hide Are You Pregnant Segmented Control and Associated Label
- (void) setPregnantOptionHidden:(BOOL) hidden;

/// validate the fields
- (BOOL)validateFields;

/// create a new baby profile view with the given delegate
+ (BabyProfileViewController *)babyProfileViewControllerWithDelegate:(id<BabyProfileViewDelegate>)delegate;

/// create a new baby profile view with the given delegate and baby
+ (BabyProfileViewController *)babyProfileViewControllerWithDelegate:(id<BabyProfileViewDelegate>)delegate baby:(Baby *)baby;
@end
