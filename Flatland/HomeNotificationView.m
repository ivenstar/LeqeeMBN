//
//  HomeNotificationView.m
//  Flatland
//
//  Created by Stefan Aust on 15.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "HomeNotificationView.h"
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "NotificationCenter.h"
#import "HomeViewController.h"
#import "BabyMenuViewController.h"
#import "WidgetViewController.h"

@interface HomeNotificationView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation HomeNotificationView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self awakeFromNib];
    [self sortNotifications];
    return self;
}

- (void)awakeFromNib {
    self.layer.cornerRadius = 4;
    
    // hide the notification view
    // (it might be visible in the storyboard)
    CGRect frame = self.frame;
    frame.size.height = 8;
    self.alpha = 0;
    self.frame = frame;
    
}

- (void)toggle {
    [self sortNotifications];
    [self.tableView reloadData];
    CGRect frame = self.frame;
    CGFloat alpha;
    if (!self.alpha) {
        NSUInteger count = [self.notifications count];
        if (count > 7) {
            count = 7;
        }
        alpha = .95;
        frame.size.height = 8 + count * 60 - 1;
    } else {
        alpha = 0;
        frame.size.height = 8;
    }
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = alpha;
        self.frame = frame;
    }];
}

- (void)close {
    CGRect frame = self.frame;
    CGFloat alpha; 
    alpha = 0;
    frame.size.height = 8;
    
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = alpha;
        self.frame = frame;
    }];
}

- (void)sortNotifications {
    NSMutableArray *warn = [NSMutableArray new];
    NSMutableArray *note = [NSMutableArray new];
    for(Notification *n in _notifications) {
        if ( ([n notificationType] == NotificationTypeOrderRecommendation) || ([n notificationType] == NotificationTypeBottleFeed) || ([n notificationType] == NotificationTypeLowStock) ) {
            [warn addObject:n];
        } else {
            [note addObject:n];
        }
    }
    [warn addObjectsFromArray:note];
    _notifications = warn;
}

#pragma mark - Table view date source & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.notifications count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( ([[_notifications objectAtIndex:indexPath.row] notificationType] == NotificationTypeOrderRecommendation) || ([[_notifications objectAtIndex:indexPath.row] notificationType] == NotificationTypeLowStock) ) {
        HomeNotificationWarnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Warn"];
        [cell setData:[_notifications objectAtIndex:indexPath.row]];
        return cell;
    }
    HomeNotificationNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Note"];
    [cell setData:[_notifications objectAtIndex:indexPath.row]];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Notification *n = [_notifications objectAtIndex:indexPath.row];
    //Ionel: do not remove order recommendation entry when clicked
    if ([n notificationType] != NotificationTypeOrderRecommendation) {
    [[User activeUser] removeUnreadNotification:n];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationsChangedNotification" object:nil];
    [self toggle];
    if(n.notificationType == NotificationTypeTips) {
            [[User activeUser] addReadNotification:((NSNumber*)n.ID)];
        [((HomeViewController*)self.delegate) goToTip:((NSNumber*)n.ID)];
    }
    else if (n.notificationType == NotificationTypeOrderRecommendation){
        [((HomeViewController*)self.delegate) doOrderRecommendation];
        //[[NotificationCenter sharedCenter] decreaseBadgeCountBy:1];
    }
    else if (n.notificationType == NotificationTypeLowStock){
        [[NotificationCenter sharedCenter] decreaseBadgeCountBy:1];
        [((HomeViewController*)self.delegate) doAdjustCapsuleStockNotification];
    }
    else if (n.notificationType == NotificationTypeBottleFeed) {
       //load baby with id babyID from notification and go to Dashboard
        [[NotificationCenter sharedCenter] decreaseBadgeCountBy:1];
        Baby *selBaby = nil;
        for (Baby *baby in [User activeUser].babies) {
            if (([baby.ID isEqualToString:n.babyID]) || ([baby.name isEqualToString:n.babyID])) {
                selBaby = baby;
            }
        }
        if (selBaby != nil){
            //[[NSNotificationCenter defaultCenter] postNotificationName:BabiesChangedNotification object:[User activeUser]];

            [[((HomeViewController*)self.delegate) menuViewController] babyClicked:selBaby];
            if (selBaby == [User activeUser].favouriteBaby){
                //force update widgets if baby is the favorite baby
                for (WidgetViewController *wc in [((HomeViewController*)self.delegate) widgetControllers])
                {
                    wc.baby = selBaby;
                }

            }
        }
    }
}

@end


@implementation HomeNotificationWarnTableViewCell

- (void)setData:(id)notification {
    self.notificationTextLabel.text = ((Notification *)notification).message;
}

@end


@implementation HomeNotificationNoteTableViewCell

- (void)setData:(id)notification {
    self.notificationTextLabel.text = ((Notification *)notification).message;
}

@end
