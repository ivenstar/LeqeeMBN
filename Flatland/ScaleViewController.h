//
//  ScaleViewController.h
//  Flatland
//
//  Created by Jochen Block on 26.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatViewController.h"
#import "Baby.h"
#import "Weight.h"
#import "CalendarView.h"

@class HomeViewController;

@protocol ScaleProtocol <NSObject>

- (void) scaleDidChangeValue:(NSString *)newValue;

@end

@interface ScaleViewController : FlatViewController <ScaleProtocol, CalendarViewDelegate>
@property (nonatomic, strong) Baby *baby;
@property (nonatomic) double value;
@property (nonatomic, strong) Weight *weight;
@property (nonatomic) BOOL isEditing;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSNumber *didSelectedDate;
@property (weak, nonatomic) IBOutlet CalendarView *calendarViewEdit;
@property (nonatomic, weak) HomeViewController *parentView;
@end
