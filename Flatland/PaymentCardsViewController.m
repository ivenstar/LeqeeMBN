////
////  PaymentCardsViewController.m
////  Flatland
////
////  Created by Stefan Aust on 14.05.13.
////  Copyright (c) 2013 Proximity Technologies. All rights reserved.
////
//
//#import "PaymentCardsViewController.h"
//#import "WaitIndicator.h"
//#import "User.h"
//#import "PaymentCardCell.h"
//
//@interface PaymentCardsViewController () <UITableViewDataSource, UITableViewDelegate>
//
//@property (nonatomic, weak) IBOutlet UITableView *tableView;
//@property (nonatomic, copy) NSArray *paymentCards;
//
//@end
//
//@implementation PaymentCardsViewController
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self icnhLocalizeView];
//    [self setRightBarButtonItem:MakeImageBarButton(@"barbutton-edit", self, @selector(edit))];
//    
//    [WaitIndicator waitOnView:self.view];
//    [[User activeUser] loadPaymentCards:^(NSArray *paymentCards) {
//        self.paymentCards = paymentCards;
//        [self.tableView reloadData];
//        [self.view stopWaiting];
//        
//        // select the preferred address, if there is any
//        NSInteger index = 0;
//        NSString *preferredPaymentCardID = [[User activeUser] preferredPaymentCardID];
//        
//        for (Address *paymentCard in paymentCards) {
//            if ([paymentCard.ID isEqualToString:preferredPaymentCardID]) {
//                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
//                                            animated:YES
//                                      scrollPosition:UITableViewScrollPositionNone];
//                break;
//            }
//            index++;
//        }
//    }];
//}
//
//#pragma mark - Table View Data Source & Delegate
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.paymentCards count] + 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == [self.paymentCards count]) {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddPaymentCard"];
//        [cell changeSystemFontToApplicationFont];
//        [cell icnhLocalizeSubviews];
//        return cell;
//    }
//    PaymentCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentCard"];
//    [cell changeSystemFontToApplicationFont];
//    [cell setPaymentCard:self.paymentCards[indexPath.row]];
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == [self.paymentCards count]) {
//        [self presentViewControllerWithIdentifier:@"AddPaymentCard"];
//        return;
//    }
//    [self selectPaymentCard:self.paymentCards[indexPath.row]];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == [self.paymentCards count]) {
//        return 44; // height of the "add payment card" button
//    }
//    return tableView.rowHeight;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return [self viewForHeaderWithTitle:T(@"%paymentCards.title") tableView:tableView];
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return indexPath.row != [self.paymentCards count];
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    PaymentCard *paymentCard = self.paymentCards[indexPath.row];
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [[User activeUser] deletePaymentCard:paymentCard completion:^(BOOL success) {
//            self.paymentCards = [self.paymentCards arrayByRemovingObject:paymentCard];
//            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                                  withRowAnimation:UITableViewRowAnimationLeft];
//            if (![self.paymentCards count]) {
//                self.tableView.editing = NO;
//            }
//        }];
//    }
//}
//
//#pragma mark - Actions
//
//- (void)edit {
//    self.tableView.editing = !self.tableView.editing;
//}
//
//#pragma mark - Private
//
//- (void)selectPaymentCard:(Address *)paymentCard {
//    [User activeUser].preferredPaymentCardID = paymentCard.ID;
//}
//
//@end
