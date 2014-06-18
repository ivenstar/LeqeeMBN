//
//  CartSummaryViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CartSummaryViewController.h"
#import "User.h"
#import "AddressCell.h"
#import "DeliveryModeCell.h"
#import "CartCell.h"
#import "WaitIndicator.h"
#import "PaymentViewController.h"
#import "OrderSumaryAddressCell.h"
#import "OrderSummaryDeliveryModeCell.h"

@interface CartSummaryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UILabel *priceLabel; //Grand Total

@property (nonatomic, weak) IBOutlet UILabel *subTotalLabel;
@property (nonatomic, weak) IBOutlet UILabel *storeCreditLabel;
@property (nonatomic, weak) IBOutlet UILabel *taxLabel;

@property (nonatomic, assign) NSInteger addressCount;
@property (nonatomic, readonly) Order *order;

@end

#pragma mark

@implementation CartSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // determine whether we need one or two addresses
    self.addressCount = [self.order.deliveryAddressID isEqualToString:self.order.billingAddressID] ? 1 : 2;
    
    // compute and display the price including shipping
    self.priceLabel.text = FormatPrice([self.order totalPrice]);
    
    //TODO : real prices
    self.subTotalLabel.text = FormatPrice(0);
    self.storeCreditLabel.text = FormatPrice(0);
    self.taxLabel.text = FormatPrice(0);
    
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark - Actions

- (IBAction)modify {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SelectDeliveryAddress"] animated:YES];
}

#pragma mark - Table View Data Source & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.order.orderItems count] + self.addressCount + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.addressCount)
    {
        OrderSumaryAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Address"];
        [cell changeSystemFontToApplicationFont];
        [cell icnhLocalizeSubviews];
        [cell setAddress:indexPath.row == 0 ? self.order.deliveryAddress : self.order.billingAddress];
        return cell;
    }
    else if (indexPath.row == self.addressCount)
    {
        OrderSummaryDeliveryModeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryMode"];
        [cell changeSystemFontToApplicationFont];
        [cell icnhLocalizeSubviews];
        [cell setDeliveryMode:self.order.deliveryMode];
        return cell;
    }
    else
    {
        CartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cart"];
        [cell changeSystemFontToApplicationFont];
        [cell setOrderItem:self.order.orderItems[indexPath.row - self.addressCount - 1]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.addressCount) //addreses
    {
        return 105;
    }
    else
    if (indexPath.row == self.addressCount) //delivery mode
    {
        return 115;
    }
    else
    {
        return 84;
    }
}

#pragma mark - Private

- (Order *)order {
    return [Order sharedOrder];
}

@end
