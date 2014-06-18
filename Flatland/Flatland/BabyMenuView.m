//
//  BabyMenuVew.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 04.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BabyMenuView.h"
#import "Baby.h"
#import "CircularMaskImageView.h"

@interface BabyMenuView ()
@property (weak, nonatomic) IBOutlet UILabel *babyName;
@property (weak, nonatomic) IBOutlet CircularMaskImageView *babyPicture;

@end

@implementation BabyMenuView

+ (BabyMenuView *)babyMenuViewWithBaby:(Baby *)baby {
    BabyMenuView *babyMenuView = [self new];
    [[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] instantiateWithOwner:babyMenuView options:nil];
    [babyMenuView.view changeSystemFontToApplicationFont];
    babyMenuView.babyName.text = baby.name;
    
    return babyMenuView;
}

@end
