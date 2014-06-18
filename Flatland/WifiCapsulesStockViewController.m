//
//  WifiCapsulesStockViewController.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 18.06.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WifiCapsulesStockViewController.h"

#import "CapsulesStockCell.h"
#import "Capsule.h"
#import "Stock.h"
#import "AlertView.h"
#import "OverlaySaveView.h"
#import "User.h"
#import "WaitIndicator.h"

@interface WifiCapsulesStockViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *capsulesLeftLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Stock *stock;

@end

#pragma mark

@implementation WifiCapsulesStockViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [WaitIndicator waitOnView:self.view];
    [Stock get:^(Stock *stock) {
        [self.view stopWaiting];
        self.stock = stock;
        [self.stock addObserver:self selector:@selector(stockChanged)];
        [self stockChanged];
        [self.tableView reloadData];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.stock removeObserver:self];
}

#pragma mark - Table view data source & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stock ? 7 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = indexPath.row < 3 ? @"Cell2" : @"Cell1";
    CapsulesStockCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell changeSystemFontToApplicationFont];
    
    Capsule *capsule = [Capsule capsules][indexPath.row];
    
    cell.capsuleImageView.image = [UIImage imageNamed:capsule.imageName];
    cell.nameLabel.text = capsule.name;
    cell.smallSizeLabel.text = [NSString stringWithFormat:@"%@ %@", capsule.sizes[0],T(@"%bottlefeeding.ml")];
    cell.smallCountLabel.text = [NSString stringWithFormat:@"%d", [self.stock countOfCapsuleType:capsule.type size:@"Small"]];
    cell.smallCountStepper.value = [self.stock countOfCapsuleType:capsule.type size:@"Small"];
    if (indexPath.row < 3) {
        cell.largeSizeLabel.text = [NSString stringWithFormat:@"%@ %@", capsule.sizes[1],T(@"%bottlefeeding.ml")];
        cell.largeCountLabel.text = [NSString stringWithFormat:@"%d", [self.stock countOfCapsuleType:capsule.type size:@"Large"]];
        cell.largeCountStepper.value = [self.stock countOfCapsuleType:capsule.type size:@"Large"];
    }
    cell.stock = self.stock;
    cell.type = capsule.type;
    [cell icnhLocalizeSubviews];
    return cell;
}

#pragma mark - Private

- (void)stockChanged {
    self.capsulesLeftLabel.text = [NSString stringWithFormat:T(@"%capsuleStock.capsulesLeftLabel"), self.stock.capsulesLeft];
}

- (IBAction)save {
    if (!self.stock) {
        [[AlertView alertViewFromString:@"Error|No stock|Ok" buttonClicked:nil] show];
    } else {
        [WaitIndicator waitOnView:self.view];
        [self.stock save:^(BOOL success) {
            if (success) {
                [[User activeUser] setWifiStatus:WIFI_STATUS_CONFIGURED completion:^(BOOL success) {
                    [self.view stopWaiting];
                    if(success) {
                        [self dismiss];
                        [[AlertView alertViewFromString:T(@"%wifi.success") buttonClicked:nil] show];
                    } else {
                        [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
                    }
                }];
            } else {
                [self.view stopWaiting];
                [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
            }
    }];
    }
}

@end