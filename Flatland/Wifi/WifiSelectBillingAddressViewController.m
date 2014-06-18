//
//  WifiSelectBillingAddressViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 19.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WifiSelectBillingAddressViewController.h"
#import "AddressCell.h"
#import "User.h"
#import "WaitIndicator.h"
#import "AlertView.h"

@interface WifiSelectBillingAddressViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *continueButton;

@property (nonatomic, copy) NSArray *addresses;

@end

@implementation WifiSelectBillingAddressViewController

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

#pragma mark - Actions
- (IBAction)performSequeIfValid {
    Address *address = [Address new];
    for(Address *a in self.addresses) {
        if([a.ID isEqualToString:[User activeUser].preferredBillingAddressID]) {
            a.preferred = YES;
            address = a;
            break;
        }
    }
    [[User activeUser] updateBillingAddress:address completion:^(BOOL success) {
        if(success) {
            [self performSegueWithIdentifier:@"configurePayment" sender:self];
        } else {
            [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
        }
    }];
    
}

#pragma mark - Private

- (void)selectAddress:(Address *)address {
    [User activeUser].preferredBillingAddressID = address.ID;
    self.continueButton.enabled = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
@end
