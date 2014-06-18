//
//  EditAccountVC.h
//  Flatland
//
//  Created by Ionel Pascu
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "FlatViewController.h"
#import "User.h"
#import "Address.h"
#import "OrderInformationTabViewController.h"

/**
 * Show form of user personal information
 */
@interface EditAccountVC : FlatViewController <UITextFieldDelegate>


@property (nonatomic, strong) User *user; // the user that should be updated
@property (nonatomic, strong) Address *userAddress; // the address of the user

#ifdef BABY_NES_US
@property (nonatomic, strong) UIPickerView *statePicker; //State picker
@property (nonatomic) int pos;
#endif //BABY_NES_US


@property (nonatomic, weak) UIViewController *mainViewController;

- (UIView *)viewForHeaderWithTitle:(NSString *)title tableView:(UITableView *)tableView;
- (UIView *)viewForHeaderWithTitleDeliveryFR:(NSString *)title subtitle:(NSString *) subtitle tableView:(UITableView *)tableView;

- (void)presentViewControllerWithIdentifier:(NSString *)identifier;

- (void)setRightBarButtonItem:(UIBarButtonItem *)barButtonItem;

- (void)deleteRightBarButtonItem;

@end
