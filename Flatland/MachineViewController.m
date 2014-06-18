//
//  MachineViewController.m
//  Flatland
//
//  Created by Stefan Aust on 20.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "MachineViewController.h"
#import "IB.h"
#import "AlertView.h"

@interface MachineViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;

@end

#pragma mark 

@implementation MachineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup size of image gallery
    UIView *contentView = [self.scrollView.subviews objectAtIndex:0];
    self.scrollView.contentSize = contentView.bounds.size;
    
    // add the machine description
    IB *ib = [[IB alloc] initWithView:self.contentView];
    [ib padding:@"0"];
    [ib add:[ib heading:T(@"machine.title")]];
    [ib add:[ib paragraph:T(@"machine.text")]];
    [ib sizeToFit];
    
    // add the machine price
    NSInteger price = [T(@"machine.priceInCents") integerValue];
    self.priceLabel.text = [NSString stringWithFormat:T(@"machine.price"), FormatPrice(price)];
    
    // setup size of page after IB's size has been fit
    contentView = [self.formScrollView.subviews objectAtIndex:0];
    self.formScrollView.contentSize = contentView.bounds.size;
}

#pragma mark - Scroll view delegate

// update page control after image gallery was scrolled
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
}

#pragma mark - Page control action

// update image gallery after page was changed
- (IBAction)pageChanged:(UIPageControl *)pageControl {
    CGPoint offset = CGPointMake(pageControl.currentPage * self.scrollView.bounds.size.width, 0);
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - Actions

/// Add one machine order item to the shared order object
- (IBAction)buy {
    OrderItem *orderItem = [OrderItem new];
    orderItem.capsuleType = @"Machine";
    orderItem.itemType = @"Dispenser";
    orderItem.capsuleSize = @"normal";
    orderItem.quantity = 1;
    [[AlertView alertViewFromString:T(@"%cart.alert.text") buttonClicked:nil] show];
    [self.order addOrderItem:orderItem];
}

@end
