//
//  AddressesViewController.m
//  Flatland
//
//  Created by Stefan Aust on 14.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "AddressesViewController.h"
#import "WaitIndicator.h"
#import "AddressCell.h"
#import "User.h"
#import "AddAddressViewController.h"
#import "EditAddressViewController.h"

@interface AddressesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *deliveryAddresses;
@property (nonatomic, copy) NSArray *billingAddresses;

@end

@implementation AddressesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Load delivery and billing addresses in parallel and stop the waiting dialog if both are loaded
    __block NSInteger counter = 2;
    
    [self setRightBarButtonItem:MakeImageBarButton(@"barbutton-edit", self, @selector(edit))];
    
    [WaitIndicator waitOnView:self.view];
    
    [[User activeUser] loadDeliveryAddresses:^(NSArray *addresses) {
        self.deliveryAddresses = addresses;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (--counter == 0) [self.view stopWaiting];
        
        // select the preferred address, if there is any
        NSInteger index = 0;
        NSString *preferredDeliveryAddressID = [[User activeUser] preferredDeliveryAddressID];
        
        for (Address *address in addresses) {
            if ([address.ID isEqualToString:preferredDeliveryAddressID]) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                            animated:YES
                                      scrollPosition:UITableViewScrollPositionNone];
                break;
            }
            index++;
        }
    }];
    
    [[User activeUser] loadBillingAddresses:^(NSArray *addresses) {
        self.billingAddresses = addresses;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (--counter == 0) [self.view stopWaiting];
        
        // select the preferred address, if there is any
        NSInteger index = 0;
        NSString *preferredBillingAddressID = [[User activeUser] preferredBillingAddressID];
        
        for (Address *address in addresses) {
            if ([address.ID isEqualToString:preferredBillingAddressID]) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:1]
                                            animated:YES
                                      scrollPosition:UITableViewScrollPositionNone];
                break;
            }
            index++;
        }
    }];

}

#pragma mark - Table View Data Source & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? [self.deliveryAddresses count] + 1 : [self.billingAddresses count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *addresses = indexPath.section == 0 ? self.deliveryAddresses : self.billingAddresses;
    if (indexPath.row == [addresses count]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddAddress"];
        [cell changeSystemFontToApplicationFont];
        [cell icnhLocalizeSubviews];
        return cell;
    }
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Address"];
    [cell changeSystemFontToApplicationFont];
    [cell setAddress:addresses[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == [self.deliveryAddresses count]) {
            [self addAddressWithMode:AddressModeDeliveryAddress];
            return;
        }
        [self selectDeliveryAddress:self.deliveryAddresses[indexPath.row]];
    } else {
        if (indexPath.row == [self.billingAddresses count]) {
            [self addAddressWithMode:AddressModeBillingAddress];
            return;
        }
        [self selectBillingAddress:self.billingAddresses[indexPath.row]];
    }
    for (NSIndexPath *i in [tableView indexPathsForSelectedRows]) {
        if (i.section == indexPath.section && i.row != indexPath.row) {
            [tableView deselectRowAtIndexPath:i animated:NO];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *addresses = indexPath.section == 0 ? self.deliveryAddresses : self.billingAddresses;
    if (indexPath.row == [addresses count]) {
        return 44; // height of the "add address" button
    }
    return tableView.rowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self viewForHeaderWithTitle:section == 0 ? T(@"%profile.deliveryWith") : T(@"%profile.billingWith")
                              tableView:tableView];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *addresses = indexPath.section == 0 ? self.deliveryAddresses : self.billingAddresses;
    return indexPath.row != [addresses count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Address *address = self.deliveryAddresses[indexPath.row];
        [[User activeUser] deleteDeliveryAddress:address completion:^(BOOL success) {
            if (success) {
                self.deliveryAddresses = [self.deliveryAddresses arrayByRemovingObject:address];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                      withRowAnimation:UITableViewRowAnimationLeft];
                if ([self.deliveryAddresses count] + [self.billingAddresses count] == 0) {
                    self.tableView.editing = NO;
                }
            }
        }];
    } else {
        Address *address = self.billingAddresses[indexPath.row];
        [[User activeUser] deleteBillingAddress:address completion:^(BOOL success) {
            if (success) {
                self.billingAddresses = [self.billingAddresses arrayByRemovingObject:address];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                      withRowAnimation:UITableViewRowAnimationLeft];
                if ([self.deliveryAddresses count] + [self.billingAddresses count] == 0) {
                    self.tableView.editing = NO;
                }
            }
        }];
    }
}

#pragma mark - Actions

- (void)edit {
    self.tableView.editing = !self.tableView.editing;
}

#pragma mark - Private

- (void)selectDeliveryAddress:(Address *)address {
    if (self.tableView.editing) {
        [self editAddress:address mode:AddressModeDeliveryAddress];
        return;
    }
    [User activeUser].preferredDeliveryAddressID = address.ID;
}

- (void)selectBillingAddress:(Address *)address {
    if (self.tableView.editing) {
        [self editAddress:address mode:AddressModeBillingAddress];
        return;
    }
    [User activeUser].preferredBillingAddressID = address.ID;
}

- (void)addAddressWithMode:(AddressMode)mode {
    if (self.tableView.editing) {
        return;
    }
    AddAddressViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAddress"];
    viewController.mode = mode;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.mainViewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)editAddress:(Address *)address mode:(AddressMode)mode {
    if (!self.tableView.editing) {
        return;
    }
    EditAddressViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditAddress"];
    viewController.address = address;
    viewController.mode = mode;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.mainViewController presentViewController:navigationController animated:YES completion:nil];
}

@end
