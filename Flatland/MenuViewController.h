//
//  MenuViewController.h
//  Flatland
//
//  Created by Stefan Aust on 18.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewControllerDelegate.h"

@interface MenuViewController : UIViewController

@property (nonatomic, weak) id<MenuViewControllerDelegate> delegate;
-(void)babyClicked:(Baby *)baby;
@end
