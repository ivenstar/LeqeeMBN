//
//  BottlefeedingEditViewController.h
//  Flatland
//
//  Created by Jochen Block on 24.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatViewController.h"
#import "Baby.h"
#import "Bottle.h"
#import "BabyNesSlider.h"
#import "BabyNesCapsulePicker.h"
#import "CalendarView.h"

@class BottlefeedingViewController;
@interface BottlefeedingEditViewController : FlatViewController <UITextFieldDelegate, UIPickerViewDelegate,BabyNesSliderDelegate,CalendarViewDelegate,BabyNesCapsulePickerDelegate>

@property (nonatomic, strong) Baby *baby;
@property (nonatomic, strong) Bottle *bottle;
@property (nonatomic) BOOL isEditing;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, weak) BottlefeedingViewController *parentView;

@end
