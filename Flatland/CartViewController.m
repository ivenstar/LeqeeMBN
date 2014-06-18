//
//  CartViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CartViewController.h"
#import "CartCell.h"
#import "CartModifyViewController.h"
#import "Order.h"
#import "User.h"
#import "Colizen.h"
#import "AlertView.h"

@interface CartViewController () <UITableViewDataSource, UITableViewDelegate, CartModifyViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, readonly) Order *order;

@end

#pragma mark

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = MakeImageBarButton(@"barbutton-edit", self, @selector(modifyCart));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updatePrice];
}

#pragma mark - Table View Data Source & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.order.orderItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cart"];
    [cell changeSystemFontToApplicationFont];
    [cell setOrderItem:self.order.orderItems[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.order removeOrderItem:self.order.orderItems[indexPath.row]];
        [self updatePrice];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Actions

- (IBAction)modifyCart {
    self.tableView.editing = !self.tableView.editing;
}

- (IBAction)nextStep {
    
    if([self.order.orderItems count] == 0 || self.order.orderItemCount == 0){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Shop" bundle:nil];
        [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"Shop"] animated:YES];
        return;
    }
    
    if([self.order.orderItems count] > 1 || self.order.orderItemCount > 1){
    
    self.tableView.editing = NO;
    
    User *u = [User activeUser];

    // if express checkout is requested and we have IDs for both addresses and the delivery mode
    // we will start to make sure (which requires asynchronous operations) that addresses exist
    // and the delivery mode is valid
    if (u.expressCheckout && u.preferredDeliveryAddressID && u.preferredBillingAddressID && u.preferredDeliveryModeID) {
        [self validateDeliveryAddress];
    } else {
        [self showSelectDeliveryAddress];
    }
    }else{
        if([self.order.orderItems count] > 0 && [[self.order.orderItems objectAtIndex:0] isMachine]){
            self.tableView.editing = NO;
            
            User *u = [User activeUser];
            
            // if express checkout is requested and we have IDs for both addresses and the delivery mode
            // we will start to make sure (which requires asynchronous operations) that addresses exist
            // and the delivery mode is valid
            if (u.expressCheckout && u.preferredDeliveryAddressID && u.preferredBillingAddressID && u.preferredDeliveryModeID) {
                [self validateDeliveryAddress];
            } else {
                [self showSelectDeliveryAddress];
            }
        }else{
            [[AlertView alertViewFromString:T(@"%cart.alert.checkout.text") buttonClicked:^(NSInteger buttonIndex) {
                if(buttonIndex == 0) {
                    
                }
            }] show];
        }
    }
}

- (void)validateDeliveryAddress {
    User *u = [User activeUser];
    [u loadDeliveryAddresses:^(NSArray *addresses) {
        for (Address *address in addresses) {
            if ([address.ID isEqualToString:u.preferredDeliveryAddressID]) {
                self.order.deliveryAddressID = address.ID;
                self.order.deliveryAddress = address;
                if ([u.preferredDeliveryAddressID isEqualToString:u.preferredBillingAddressID]) {
                    self.order.billingAddressID = address.ID;
                    self.order.billingAddress = address;
                    [self validateDeliveryMode];
                    return;
                }
                [self validateBillingAddress];
                return;
            }
        }
        // preferred delivery address does not exist, ask for a new one
        [self showSelectDeliveryAddress];
    }];
}
         
- (void)validateBillingAddress {
    User *u = [User activeUser];
    [u loadBillingAddresses:^(NSArray *addresses) {
        for (Address *address in addresses) {
            if ([address.ID isEqualToString:u.preferredBillingAddressID]) {
                self.order.billingAddressID = address.ID;
                self.order.billingAddress = address;
                [self validateDeliveryMode];
                return;
            }
        }
        // preferred billing address does not exist, ask for a new one (starting with the delivery address)
        [self showSelectDeliveryAddress];
    }];
}

- (void)validateDeliveryMode {
    User *u = [User activeUser];
    DeliveryMode *deliveryMode = [DeliveryMode deliveryModeForID:u.preferredDeliveryModeID];
    if (deliveryMode) {
        self.order.deliveryModeID = deliveryMode.ID;
        self.order.deliveryMode = deliveryMode;
        
        // if in France and if the delivery address' ZIP is valid for Colizen, offer this instead of Express
        if ([CountryCode() isEqualToString:@"FR"]) {
            if ([deliveryMode.ID isEqualToString:@"Default"]) {
                [self showCartSummary];
                return;
            }
            [Colizen loadShippingConfiguration:^(BOOL success) {
                if ([deliveryMode.ID isEqualToString:@"Colizen"]) {
                    if ([Colizen isZIPCodeValidForColizen:self.order.deliveryAddress.ZIP]) {
                        [self showCartSummary];
                        return;
                    }
                }
                if ([deliveryMode.ID isEqualToString:@"Express"]) {
                    if (![Colizen isZIPCodeValidForColizen:self.order.deliveryAddress.ZIP]) {
                        [self showCartSummary];
                        return;
                    }
                }
                [self showSelectDeliveryAddress];
            }];
        } else {
            [self showCartSummary];
        }
        return;
    }
    // delivery mode isn't valid for the address so ask for a new one
    [self showSelectDeliveryAddress];
}

- (void)showSelectDeliveryAddress {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectDeliveryAddress"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showCartSummary {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CartSummary"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"modify"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        OrderItem *orderItem = self.order.orderItems[indexPath.row];
        
        UINavigationController *navigationController = segue.destinationViewController;
        CartModifyViewController *viewController = navigationController.viewControllers[0];
        viewController.price = orderItem.price;
        viewController.quantity = orderItem.quantity;
        viewController.delegate = self;
    } else {
        self.tableView.editing = NO;
    }
}

#pragma mark - Modify cart delegate

- (void)quantityChangedTo:(NSUInteger)quantity {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    OrderItem *orderItem = self.order.orderItems[indexPath.row];
    orderItem.quantity = quantity;
    [self.order save];
    [self updatePrice];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Private

- (Order *)order {
    return [Order sharedOrder];
}

- (void)updatePrice {
    self.priceLabel.text = FormatPrice([self.order capsulesPrice]);
}

@end
