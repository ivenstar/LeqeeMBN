//
//  CapsuleSummaryViewController.m
//  Flatland
//
//  Created by Stefan Aust on 15.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CapsuleSummaryViewController.h"
#import "FlatRadioButtonGroup.h"
#import "CapsuleDetailsViewController.h"
#import "CartModifyViewController.h"
#import "AlertView.h"
#import "GradientView.h"

@interface CapsuleSummaryViewController () <CartModifyViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *capsuleImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet FlatRadioButtonGroup *sizesRadioButtonGroup;
@property (nonatomic, weak) IBOutlet UIButton *changeQuantityButton;
@property (nonatomic, weak) IBOutlet UILabel *boxPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) IBOutlet GradientView *summaryView;
@property (strong, nonatomic) IBOutlet GradientView *sensitiveView;


@property (nonatomic, assign) NSInteger sizeIndex;
@property (nonatomic, assign) NSInteger quantity;

@end

#pragma mark

@implementation CapsuleSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup size of page
    UIView *contentView = [self.formScrollView.subviews objectAtIndex:0];
    self.formScrollView.contentSize = contentView.bounds.size;
    
    // setup labels based on capsule description
    self.capsuleImageView.image = [UIImage imageNamed:self.capsule.imageName];
    self.titleLabel.text = self.capsule.title;
    self.navigationItem.title = self.capsule.title;
    self.descriptionLabel.text = self.capsule.shortDescription;
    
    // setup the "radio buttons" for capsule sizes (normal and large)
    NSMutableArray *buttons = [NSMutableArray array];
    for (NSNumber *size in self.capsule.sizes) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:[NSString stringWithFormat:@"%@ %@", size, T(@"%bottlefeeding.ml")] forState:UIControlStateNormal];
        [buttons addObject:button];
    }
    self.sizesRadioButtonGroup.buttons = buttons;
    self.sizesRadioButtonGroup.selectedIndex = 0;
    
    self.title = self.capsule.title;
    
    self.sizeIndex = 0;
    self.quantity = 1;
    [self updateSizeOrQuantity];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    if ([kCountryCode isEqualToString:@"FR"] && [self.capsule.type isEqualToString:@"Sensitive"]) {
//        _summaryView.hidden = YES;
//        _sensitiveView.hidden = NO;
//    }else
    {
        _summaryView.hidden = NO;
        _sensitiveView.hidden = YES;
    }
}

- (IBAction)sizeChanged {
    self.sizeIndex = self.sizesRadioButtonGroup.selectedIndex;
    [self updateSizeOrQuantity];
}

- (IBAction)changeQuantity {
}

- (IBAction)addToCart {
    OrderItem *orderItem = [OrderItem new];
    orderItem.capsuleType = self.capsule.type;
    orderItem.itemType = @"CapsuleBox";
    orderItem.capsuleSize = @[@"Small", @"Large"][self.sizeIndex];
    orderItem.quantity = self.quantity;
    [self.order addOrderItem:orderItem];
    [[AlertView alertViewFromString:T(@"%cart.alert.text") buttonClicked:nil] show];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderChanged" object:self];
    [self orderChanged:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"modify"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        CartModifyViewController *viewController = navigationController.viewControllers[0];
        viewController.price = [self.capsule.prices[self.sizeIndex] integerValue];
        viewController.quantity = self.quantity;
        viewController.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"details"]) {
        CapsuleDetailsViewController *viewController = segue.destinationViewController;
        viewController.capsule = self.capsule;
    }
}

#pragma mark - Modify quantity delegate

- (void)quantityChangedTo:(NSUInteger)quantity {
    self.quantity = quantity;
    [self updateSizeOrQuantity];
}

#pragma mark - Private

- (void)updateSizeOrQuantity {
    NSInteger boxPrice = [self.capsule.prices[self.sizeIndex] integerValue];
    self.boxPriceLabel.text = FormatPrice(boxPrice);
    self.totalPriceLabel.text = FormatPrice(boxPrice * self.quantity);
    NSString *format = self.quantity == 1 ? T(@"%capsuleSummary.boxInCapsules") : T(@"%capsuleSummary.boxesInCapsules");
    NSString *title = [NSString stringWithFormat:format, self.quantity, self.quantity * 26];
    [self.changeQuantityButton setTitle:title forState:UIControlStateNormal];
}

- (IBAction)goToPartnerSite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.powersante.com/nestle-babynes/"]];
}

@end
