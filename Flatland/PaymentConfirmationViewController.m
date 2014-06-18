//
//  PaymentConfirmationViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "PaymentConfirmationViewController.h"
#import "WaitIndicator.h"
#import "AddressCell.h"
#import "DeliveryModeCell.h"
#import "CartCell.h"

@interface PaymentConfirmationViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *orderNoLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger addressCount;

@end

#pragma mark

@implementation PaymentConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // determine whether we need one or two addresses
    self.addressCount = [self.order.deliveryAddressID isEqualToString:self.order.billingAddressID] ? 1 : 2;

    // compute and display the price including shipping
    self.priceLabel.text = FormatPrice([self.order totalPrice]);
    
    // display the order no
    self.orderNoLabel.text = [NSString stringWithFormat:T(@"%cart.payment.orderNo" ), self.order.orderNo];
}

#pragma mark - Table View Data Source & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.order.orderItems count] + self.addressCount + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.addressCount) {
        AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Address"];
        [cell changeSystemFontToApplicationFont];
        [cell setAddress:indexPath.row == 0 ? self.order.deliveryAddress : self.order.billingAddress];
        return cell;
    } else if (indexPath.row == self.addressCount) {
        DeliveryModeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryMode"];
        [cell changeSystemFontToApplicationFont];
        [cell setDeliveryMode:self.order.deliveryMode forOrder:self.order];
        return cell;
    } else {
        CartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cart"];
        [cell changeSystemFontToApplicationFont];
        [cell setOrderItem:self.order.orderItems[indexPath.row - self.addressCount - 1]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.addressCount) {
        return 94;
    } else if (indexPath.row == self.addressCount) {
        return 125;
    } else {
        return 84;
    }
}

@end
