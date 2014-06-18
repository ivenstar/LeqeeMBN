//
//  BabyMenuVew.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 04.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baby.h"

@interface BabyMenuView : NSObject

@property (nonatomic, strong) IBOutlet UIView *view;

+ (BabyMenuView *)babyMenuViewWithBaby:(Baby *)baby;
@end
