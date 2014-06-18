//
//  CapsulesStockViewController.m
//  Flatland
//
//  Created by Stefan Aust on 16.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CapsulesStockViewController.h"
#import "CapsulesStockCell.h"
#import "Capsule.h"
#import "Stock.h"
#import "AlertView.h"
#import "OverlaySaveView.h"
#import "WaitIndicator.h"

@interface CapsulesStockViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *capsulesLeftLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Stock *stock;

@end

#pragma mark

@implementation CapsulesStockViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.capsulesLeftLabel.text = T(@"%general.loading");
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
    [WaitIndicator waitOnView:self.view];
    [self.stock save:^(BOOL success) {
        [self.view stopWaiting];
        if (success) {
            [Stock get:^(Stock *stock) {
                self.stock = stock;
                [self stockChanged];
                [self.tableView reloadData];
            }];
            [self dismiss];
            [[AlertView alertViewFromString:T(@"%capsuleStock.success") buttonClicked:nil] show];
        } else {
            [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong")  buttonClicked:nil] show];
        }
    }];
}

@end
