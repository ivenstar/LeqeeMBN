//
//  CapsulesRecommendationViewController.m
//  Flatland
//
//  Created by Stefan Aust on 16.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CapsulesRecommendationViewController.h"
#import "CartCell.h"
#import "CapsuleSummaryViewController.h"
#import "Stock.h"
#import "WaitIndicator.h"

@interface CapsulesRecommendationViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *capsuleStockLabel;

@end

#pragma mark -

@implementation CapsulesRecommendationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //Ionel: call again if nil (used if the user got here from the ShoppingReminder PUSH notif
    if (!self.recommendation) {
        [WaitIndicator waitOnView:self.view];
        [Recommendation get:^(Recommendation *recommendation)
         {
             [self.view stopWaiting];
             self.recommendation = recommendation;
             
             [self.tableView reloadData];
         }];
    }
    ///
    NSInteger price = 0;
    for (OrderItem *orderItem in self.recommendation.orderItems) {
        price += orderItem.price * orderItem.quantity;
    }
    self.priceLabel.text = FormatPrice(price);
    [Stock get:^(Stock *stock) {
        self.capsuleStockLabel.attributedText = [[NSString stringWithFormat:T(@"%capsuleRecommentation.capsuleStockLabel"), stock.capsulesLeft] attributedTextFromHTMLStringWithFont:self.capsuleStockLabel.font];
    }];
    
    [self.tableView icnhLocalizeSubviews];
}

#pragma mark - Table view data source & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recommendation.orderItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cart"];
    [cell changeSystemFontToApplicationFont];
    [cell setOrderItem:self.recommendation.orderItems[indexPath.row]];
    [cell icnhLocalizeSubviews];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Summary"]) {
        CapsuleSummaryViewController *viewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        OrderItem *orderItem = self.recommendation.orderItems[indexPath.row];
        viewController.capsule = [Capsule capsuleForType:orderItem.capsuleType];
    }
}

#pragma mark - Actions

- (IBAction)addToCart {
    for (OrderItem *orderItem in self.recommendation.orderItems) {
        [self.order addOrderItem:orderItem];
    }
    [self checkout];
}

@end
