//
//  CartSelectDeliveryModeViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CartSelectDeliveryModeViewController.h"
#import "Colizen.h"
#import "User.h"
#import "WaitIndicator.h"
#import "DeliveryModeCell.h"

@interface CartSelectDeliveryModeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;
@property (nonatomic, copy) NSArray *deliveryModes;
@property (nonatomic, assign) BOOL machineInBasket;

@end

#pragma mark

@implementation CartSelectDeliveryModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _machineInBasket = NO;
    // if in France and if the delivery address' ZIP is valid for Colizen, offer this instead of Express
    if ([kCountryCode isEqualToString:@"FR"]) {
        [Colizen loadShippingConfiguration:^(BOOL success) {
            NSMutableArray *deliveryModes = [[DeliveryMode deliveryModes] mutableCopy];
            if (![Colizen isZIPCodeValidForColizen:[Order sharedOrder].deliveryAddress.ZIP])
            {
                [deliveryModes removeObjectIdenticalTo:[DeliveryMode deliveryModeForID:@"Colizen"]];
            }
            else
            {
               [deliveryModes removeObjectIdenticalTo:[DeliveryMode deliveryModeForID:@"Express"]];  //BNM 494
            }
            for(OrderItem *i in [[Order sharedOrder] orderItems])
            {
                if([i.capsuleType isEqualToString:@"Machine"])
                {
                    [deliveryModes removeObjectIdenticalTo:[DeliveryMode deliveryModeForID:@"Default"]];
                    _machineInBasket = YES;
                    break;
                }
            }
            self.deliveryModes = deliveryModes;
        }];
    } else {
        self.deliveryModes = [DeliveryMode deliveryModes];
    }
}

#pragma mark - Table View Data Source & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.deliveryModes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeliveryModeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryMode"];
    [cell changeSystemFontToApplicationFont];
    [cell setDeliveryMode:self.deliveryModes[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectDeliveryMode:self.deliveryModes[indexPath.row]];
}

#pragma mark - Actions

- (IBAction)nextStep {
    UIViewController *viewController;
    if ([[Order sharedOrder].deliveryModeID isEqualToString:@"Colizen"]) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CartColizen"];
    } else {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CartSummary"];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Private
     
 - (void)setDeliveryModes:(NSArray *)deliveryModes {
     _deliveryModes = deliveryModes;
     [self.tableView reloadData];
     
     // select the preferred delivery mode, if there is any
     NSInteger index = 0;
     NSString *preferredDeliveryMode = [[User activeUser] preferredDeliveryModeID];
     if (!preferredDeliveryMode) {
         preferredDeliveryMode = [Order sharedOrder].deliveryModeID;
     }
     
     [Order sharedOrder].deliveryModeID = nil;
     [Order sharedOrder].deliveryMode = nil;
     [Order sharedOrder].rendezvousDate = nil;
     
     for (DeliveryMode *deliveryMode in deliveryModes) {
         if ([deliveryMode.ID isEqualToString:preferredDeliveryMode]) {
             [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                         animated:YES
                                   scrollPosition:UITableViewScrollPositionNone];
             [self selectDeliveryMode:deliveryMode];
             break;
         }
         index++;
     }
 }

- (void)selectDeliveryMode:(DeliveryMode *)deliveryMode {
    [Order sharedOrder].deliveryModeID = deliveryMode.ID;
    [Order sharedOrder].deliveryMode = deliveryMode;
    [Order sharedOrder].rendezvousDate = [deliveryMode deliveryDate];
    self.confirmButton.enabled = YES;
}

@end
