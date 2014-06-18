//
//  BabyMenuVew.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 04.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baby.h"

/**
 * Informs about actions on the baby in the menu
 */
@protocol BabyMenuViewDelegate

/// user requested to edit the given baby
- (void)editBaby:(Baby *)baby;

- (void)babyClicked:(Baby *)baby;

@end

/**
 * The view
 */
@interface BabyMenuViewContainer : UIView

@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

/**
 * Displays one baby in the menu
 */
@interface BabyMenuViewController : UIViewController

@property (nonatomic, weak) id<BabyMenuViewDelegate> delegate;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, readonly) Baby *baby;


+ (BabyMenuViewController *)babyMenuViewControllerWithBaby:(Baby *)baby;
-(void)enableEditButtons;
@end
