//
//  CoachsMainViewController.h
//  Flatland
//
//  Created by Magdalena Kamrowska on 12.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Baby.h"
#import "FlatViewController.h"

@interface CoachsMainViewController : FlatViewController
@property (nonatomic, retain) Baby* baby;

- (IBAction)openChat:(id)sender;
- (IBAction)callNutritionist:(id)sender;

@end
