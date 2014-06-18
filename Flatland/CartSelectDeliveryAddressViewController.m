//
//  CartSelectDeliveryAddressViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CartSelectDeliveryAddressViewController.h"
#import "User.h"
#import "WaitIndicator.h"
#import "AddressCell.h"
#import "FlatCheckbox.h"

@interface CartSelectDeliveryAddressViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;
@property (nonatomic, weak) IBOutlet FlatCheckbox *differentShippingAddressCheckbox;
@property (nonatomic, copy) NSArray *addresses;

@end

#pragma mark

@implementation CartSelectDeliveryAddressViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [WaitIndicator waitOnView:self.view];
    [[User activeUser] loadDeliveryAddresses:^(NSArray *addresses) {
        self.addresses = addresses;
        [self.tableView reloadData];
        [self.view stopWaiting];
        
        // select the preferred address, if there is any
        NSInteger index = 0;
        NSString *preferredDeliveryAddressID = [[User activeUser] preferredDeliveryAddressID];
        if (!preferredDeliveryAddressID) {
            preferredDeliveryAddressID = [Order sharedOrder].deliveryAddressID;
        }
        
        [Order sharedOrder].deliveryAddressID = nil;
        [Order sharedOrder].deliveryAddress = nil;

        for (Address *address in addresses) {
            if ([address.ID isEqualToString:preferredDeliveryAddressID]) {
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

#pragma mark - Actions

- (IBAction)nextStep {
    NSString *identifier;
    
    if (self.differentShippingAddressCheckbox.on) {
        identifier = @"SelectBillingAddress";
    } else {
        [Order sharedOrder].billingAddressID = [Order sharedOrder].deliveryAddressID;
        [Order sharedOrder].billingAddress = [Order sharedOrder].deliveryAddress;
        identifier = @"SelectDeliveryMode";
    }
    [self.navigationController
     pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:identifier]
     animated:YES];
}

#pragma mark - Private

- (void)selectAddress:(Address *)address {
    [Order sharedOrder].deliveryAddressID = address.ID;
    [Order sharedOrder].deliveryAddress = address;
    self.confirmButton.enabled = YES;
}

@end
