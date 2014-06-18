//
//  OrderAwareViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 25.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "OrderAwareViewController.h"
#import "CartViewController.h"

@interface OrderAwareViewController ()

@end

@implementation OrderAwareViewController

- (Order *)order {
    return [Order sharedOrder];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addCartButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeCartButton];
}

#pragma mark - Cart button

- (void)addCartButton {
    [self.order addObserver:self selector:@selector(orderChanged:)];
    [self orderChanged:nil]; // this will add the button
}

- (void)removeCartButton {
    [self.order removeObserver:self];
    self.navigationItem.rightBarButtonItem = nil; // remove the button
}

/// Shows a "checkout" button if the shared order object contains order items and hides it otherwise
- (void)orderChanged:(NSNotification *)notification {
    NSUInteger count = [self.order orderItemCount];
    if (count) {
        NSString *title = [NSString stringWithFormat:@"%d", count];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = [self createCheckoutBarButtonItem: title];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (UIBarButtonItem *)createCheckoutBarButtonItem:(NSString *)title {
    UIBarButtonItem *barButtonItem = MakeImageBarButton(@"barbutton-shop", self, @selector(checkout));
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, 10, 10)];
    label.font = [UIFont boldFontOfSize:7];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRGBString:@"8B88A8"];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    [barButtonItem.customView addSubview:label];
    return barButtonItem;
}

- (void)setCheckoutButtonBadge:(NSString *)badge {
    UILabel *label = [self.navigationItem.rightBarButtonItem.customView.subviews lastObject];
    label.text = badge;
}

#pragma mark - Actions

/// Shows the cart
- (IBAction)checkout {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Cart" bundle:nil];
    CartViewController *viewController = [storyboard instantiateInitialViewController];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
