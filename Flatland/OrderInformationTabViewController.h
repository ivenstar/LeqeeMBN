//
//  OrderInformationTabViewController.h
//  Flatland
//
//  Created by Stefan Aust on 21.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Abstract superclass of all tabs of the OrderInformationViewController.
 */
@interface OrderInformationTabViewController : UIViewController

@property (nonatomic, weak) UIViewController *mainViewController;

- (UIView *)viewForHeaderWithTitle:(NSString *)title tableView:(UITableView *)tableView;
- (UIView *)viewForHeaderWithTitleDeliveryFR:(NSString *)title subtitle:(NSString *) subtitle tableView:(UITableView *)tableView;

- (void)presentViewControllerWithIdentifier:(NSString *)identifier;

- (void)setRightBarButtonItem:(UIBarButtonItem *)barButtonItem;

- (void)deleteRightBarButtonItem;

@end
