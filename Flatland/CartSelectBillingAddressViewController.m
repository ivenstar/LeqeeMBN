//
//  CartSelectBillingAddressViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CartSelectBillingAddressViewController.h"
#import "User.h"
#import "WaitIndicator.h"
#import "AddressCell.h"

@interface CartSelectBillingAddressViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;
@property (nonatomic, copy) NSArray *addresses;

@end

#pragma mark

@implementation CartSelectBillingAddressViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [WaitIndicator waitOnView:self.view];
    [[User activeUser] loadBillingAddresses:^(NSArray *addresses) {
        self.addresses = addresses;
        [self.tableView reloadData];
        [self.view stopWaiting];
        
        // select the preferred address, if there is any
        NSInteger index = 0;
        NSString *preferredBillingAddressID = [[User activeUser] preferredBillingAddressID];
        if (!preferredBillingAddressID) {
            preferredBillingAddressID = [Order sharedOrder].billingAddressID;
        }
        [Order sharedOrder].billingAddressID = nil;
        [Order sharedOrder].billingAddress = nil;
        for (Address *address in addresses) {
            if ([address.ID isEqualToString:preferredBillingAddressID]) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                            animated:YES
                                      scrollPosition:UITableViewScrollPositionMiddle];
                [self selectAddress:address];
                break;
            }
            index++;
        }
    }];
}

#pragma mark - Table View Data Source & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.addresses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Address"];
    [cell changeSystemFontToApplicationFont];
    [cell setAddress:self.addresses[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectAddress:self.addresses[indexPath.row]];
}

#pragma mark - Private

- (void)selectAddress:(Address *)address {
    [Order sharedOrder].billingAddressID = address.ID;
    [Order sharedOrder].billingAddress = address;
    self.confirmButton.enabled = YES;
}

@end
