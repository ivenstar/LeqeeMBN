//
//  OrderInformationViewController.m
//  Flatland
//
//  Created by Stefan Aust on 14.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "OrderInformationViewController.h"
#import "OrderInformationTabViewController.h"
#import "FlatSwitch.h"
#import "FlatButton.h"
#import "User.h"
#import "AlertView.h"
#import "EditAccountVC.h"

@interface OrderInformationViewController ()

@property (nonatomic, weak) IBOutlet FlatSwitch *expressSwitch;
@property (nonatomic, weak) IBOutlet UIView *tabBar;    // contains the tab buttons (see FlatTabButton class)
@property (nonatomic, weak) IBOutlet UIView *container; // contains the view of the child view controllers

@property (nonatomic, copy) NSArray *viewControllers;   // list of view controllers, one per tab
@property (nonatomic, assign) NSInteger selectedIndex;  // index of the selected view controller
@property (nonatomic, readonly) UIViewController *selectedViewController;

@end

#pragma mark

@implementation OrderInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self pushViewControllerWithIdentifier:@"UserOverview" inStoryboard:@"EditUserAccount"];
    //UIStoryboard *sb = [UIStoryboard storyboardWithName:@"EditUserAccount" bundle:nil];
   // EditUserViewController *account = [sb instantiateViewControllerWithIdentifier:@"UserOverview"];
    self.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"UserDetails"],
                             [self.storyboard instantiateViewControllerWithIdentifier:@"Addresses"],
                             [self.storyboard instantiateViewControllerWithIdentifier:@"Payment"]];
    for (OrderInformationTabViewController *viewController in self.viewControllers) {
        viewController.mainViewController = self;
    }
    [self setupTabs];
    [self selectTab:0];
    
    self.expressSwitch.on = [User activeUser].expressCheckout;
}

- (void)didReceiveMemoryWarning {
    for (UIViewController *viewController in self.viewControllers) {
        [viewController didReceiveMemoryWarning];
    }
}

#pragma mark - Actions

/// "Express checkout" switch was pressed.
- (IBAction)expressChanged:(FlatSwitch *)sender {
    if (![User activeUser].expressCheckout) {
        [[AlertView alertViewFromString:T(@"%orderInformation.alert.expressChanged") buttonClicked:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                sender.on = NO;
            } else {
                [User activeUser].expressCheckout = YES;
            }
        }] show];
    } else {
        [User activeUser].expressCheckout = NO;
    }
}

/// Tab button was pressed.
- (IBAction)tabSelectd:(UIButton *)sender {
    [self selectTab:sender.tag];
}

#pragma mark - Private

/// Returns the selected view controller.
- (UIViewController *)selectedViewController {
    return self.viewControllers[self.selectedIndex];
}

- (void)setupTabs {
    for (FlatButton *button in self.tabBar.subviews) {
        [button setTitleColor:[UIColor colorWithRGBString:@"4C4962"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRGBString:@"4C4962"] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal+UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor colorWithRGBString:@"9894B7"] forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor colorWithRGBString:@"9894B7"] forState:UIControlStateSelected+UIControlStateHighlighted];
    }
}

- (void)selectTab:(NSInteger)index {
    BOOL hasView = [self.container.subviews count]; // NO on the first call only
    
    if (hasView && index == self.selectedIndex) {
        return;
    }

    for (UIButton *button in self.tabBar.subviews) {
        button.selected = button.tag == index;
    }
    
    if (hasView) {
        [self.selectedViewController viewWillDisappear:NO];
        for (UIView *view in self.container.subviews) {
            [view removeFromSuperview];
        }
        [self.selectedViewController viewDidDisappear:NO];
    }
    
    self.selectedIndex = index;
    
    [self.selectedViewController viewWillAppear:NO];
    UIView *view = self.selectedViewController.view;
    view.backgroundColor = [UIColor clearColor];
    view.frame = self.container.bounds;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight;
    [self.container addSubview:view];
    [self.selectedViewController viewDidAppear:NO];
}

@end
