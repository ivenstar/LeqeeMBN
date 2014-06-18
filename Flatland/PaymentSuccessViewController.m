//
//  PaymentSuccessViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "PaymentSuccessViewController.h"
#import "PaymentConfirmationViewController.h"

@interface PaymentSuccessViewController ()

@property (nonatomic, weak) IBOutlet UILabel *emailLabel;
@property (nonatomic, weak) IBOutlet UILabel *orderNoLabel;

@end

#pragma mark

@implementation PaymentSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orderNoLabel.text = [NSString stringWithFormat:T(@"%cart.payment.orderNo"), self.order.orderNo];
    self.emailLabel.text = [NSString stringWithFormat:T(@"%cart.payment.emailLabel"), self.order.email];
    
    //Ionel: remove order recommendation entry in Home notif, if any
    for(Notification* n in [[User activeUser] notifications]) {
        //if([[n babyID] isEqualToString:[[[User activeUser] favouriteBaby] ID]] || [n babyID].length < 1)
        if ([n notificationType] == NotificationTypeOrderRecommendation)
        {
            [[User activeUser] removeUnreadNotification:n];
            [[NotificationCenter sharedCenter] decreaseBadgeCountBy:1];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationsChangedNotification" object:nil];
        }
    }
    
    ////
}

#pragma mark - Actions

- (IBAction)activateExpressCheckout {
    User *u = [User activeUser];
    u.expressCheckout = YES;
    u.preferredBillingAddressID = _order.billingAddressID;
    u.preferredDeliveryAddressID = _order.deliveryAddressID;
    u.preferredDeliveryModeID = _order.deliveryModeID;
    [[AlertView alertViewFromString:T(@"%cart.payment.expressCheckout") buttonClicked:nil] show];
}

- (IBAction)callSupport {
    CallSupport();
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PaymentConfirmationViewController *viewController = segue.destinationViewController;
    viewController.order = self.order;
}

@end
