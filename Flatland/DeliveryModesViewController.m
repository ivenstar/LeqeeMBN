//
//  DeliveryModesViewController.m
//  Flatland
//
//  Created by Stefan Aust on 14.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "DeliveryModesViewController.h"
#import "DeliveryModeCell.h"
#import "User.h"

@interface DeliveryModesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *deliveryModes;

@end

@implementation DeliveryModesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self icnhLocalizeView];
    [self setRightBarButtonItem:nil];
    
    // if in France, remove Colizen and only show Express delivery mode
    if ([CountryCode() isEqualToString:@"FR"]) {
        NSMutableArray *deliveryModes = [[DeliveryMode deliveryModes] mutableCopy];
        [deliveryModes removeObjectIdenticalTo:[DeliveryMode deliveryModeForID:@"Colizen"]];
        self.deliveryModes = deliveryModes;
    } else {
        self.deliveryModes = [DeliveryMode deliveryModes];
    }
    [self.tableView icnhLocalizeSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [self deleteRightBarButtonItem];
}

#pragma mark - Table View Data Source & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.deliveryModes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeliveryModeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryMode"];
    [cell setDeliveryMode:self.deliveryModes[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectDeliveryMode:self.deliveryModes[indexPath.row]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
#ifdef BABY_NES_FR
    return [self viewForHeaderWithTitleDeliveryFR:T(@"%deliverMode.deliveryMode") subtitle:T(@"%deliverMode.subtitle") tableView:tableView];
#else
    return [self viewForHeaderWithTitle:T(@"%deliverMode.deliveryMode") tableView:tableView];
#endif
}

#pragma mark - Private

- (void)setDeliveryModes:(NSArray *)deliveryModes {
    _deliveryModes = deliveryModes;
    [self.tableView reloadData];
    
    // select the preferred delivery mode, if there is any
    NSInteger index = 0;
    NSString *preferredDeliveryMode = [[User activeUser] preferredDeliveryModeID];
    
    for (DeliveryMode *deliveryMode in deliveryModes) {
        if ([deliveryMode.ID isEqualToString:preferredDeliveryMode]) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionNone];
            break;
        }
        index++;
    }
}

- (void)selectDeliveryMode:(DeliveryMode *)deliveryMode {
    [User activeUser].preferredDeliveryModeID = deliveryMode.ID;
}


@end
