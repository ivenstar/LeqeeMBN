//
//  BabyNesSlider.h
//  Flatland
//
//  Created by Bogdan Chitu on 06/02/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BabyNesSliderDelegate
- (void) sliderValueChanged: (float) newValue;
@end

@interface BabyNesSlider : UIView <UITabBarControllerDelegate>

@property(nonatomic,readwrite) float value;
@property (weak) id<BabyNesSliderDelegate> delegate;

@end

