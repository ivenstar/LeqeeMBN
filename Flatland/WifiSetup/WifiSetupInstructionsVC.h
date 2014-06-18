//
//  WifiSetupInstructionsVC.h
//  Flatland
//
//  Created by Ionel Pascu on 12/3/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatWifiViewController.h"
#import "AppDelegate.h"


@interface WifiSetupInstructionsVC : FlatWifiViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextView *step1Text;
@property (strong, nonatomic) IBOutlet UITextView *step2Text;

@end
