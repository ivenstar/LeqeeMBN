//
//  UserOverviewViewController.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 14.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "UserOverviewViewController.h"
#import "UserOverviewCell.h"
#import "Address.h"
#import "EditUserViewController.h"
#import "WaitIndicator.h"

@interface UserOverviewViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Address *userAddress;
@property (nonatomic) BOOL dataLoaded;
@end

@implementation UserOverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [WaitIndicator waitOnView:self.view];
    [[User activeUser] loadPersonalInformation:^(Address *personalAddress) {
        [self.view stopWaiting];
        self.userAddress = personalAddress;
        _dataLoaded = YES;
        [self.tableView reloadData];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EditUserViewController *vc = segue.destinationViewController;
    vc.user = [User activeUser];
    vc.userAddress = self.userAddress;
}

#pragma mark - Table view Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    UserOverviewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[UserOverviewCell alloc] init];
    }
    if(_dataLoaded){
        [cell changeSystemFontToApplicationFont];
        cell.user = [User activeUser];
        cell.userAddress = self.userAddress;
    }
    return cell;
}

@end
