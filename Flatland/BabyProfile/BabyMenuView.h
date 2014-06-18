//
//  BabyMenuView.h
//  Flatland
//
//  Created by Rinf Hackintosh on 18/02/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"

@interface BabyMenuView : UIView <SwipeViewDataSource, SwipeViewDelegate>

@property (nonatomic, strong) NSMutableArray *babyProfileViews;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic,strong) IBOutlet SwipeView *swipeView;
@property (nonatomic) int index;
@property (strong, nonatomic) UIView *overlay;

@property (nonatomic,readonly) BOOL isLoading;


-(void)resetPageControl;
- (void)showLoadingOverlay;
- (void)hideLoadingOverlay;

@end
