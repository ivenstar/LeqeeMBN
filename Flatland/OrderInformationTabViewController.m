//
//  OrderInformationTabViewController.m
//  Flatland
//
//  Created by Stefan Aust on 21.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "OrderInformationTabViewController.h"

@implementation OrderInformationTabViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self icnhLocalizeView];
}

/// Creates a view suitable as a table header view.
- (UIView *)viewForHeaderWithTitle:(NSString *)title tableView:(UITableView *)tableView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 16, tableView.bounds.size.width, 20)];
    label.font = [UIFont regularFontOfSize:15];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:label];
    return view;
}
/// Creates a Custom view suitable as a table header view.
- (UIView *)viewForHeaderWithTitleDeliveryFR:(NSString *)title subtitle:(NSString *) subtitle tableView:(UITableView *)tableView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, tableView.bounds.size.width, 20)];
    label.font = [UIFont regularFontOfSize:15];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    
    UILabel *labelSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, tableView.bounds.size.width, 20)];
    labelSubtitle.font = [UIFont regularFontOfSize:10];
    labelSubtitle.backgroundColor = [UIColor clearColor];
    labelSubtitle.text = subtitle;//@"(La livraison aux points relais est disponible uniquement sur le site internet)";
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:label];
    [view addSubview:labelSubtitle];
    return view;
}


/// Presents a modal view controller named `identifier` from the current storybuild.
- (void)presentViewControllerWithIdentifier:(NSString *)identifier {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.mainViewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)barButtonItem {
    self.mainViewController.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)deleteRightBarButtonItem {
    self.mainViewController.navigationItem.rightBarButtonItem = nil;
}

@end
