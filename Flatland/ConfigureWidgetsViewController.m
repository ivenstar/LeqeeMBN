//
//  ConfigureWidgetsViewController.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 13.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "ConfigureWidgetsViewController.h"
#import "User.h"

#import "BreastfeedingWidgetViewController.h"
#import "WeightWidgetViewController.h"
#import "BottlefeedingWidgetViewController.h"
#import "TimelineWidgetViewController.h"

#import "OverlaySaveView.h"
#import "FlatButton.h"

@interface ConfigureWidgetsViewController () <SwipeViewDataSource>

@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
@property (weak, nonatomic) IBOutlet UIButton *addRemoveWidgetBtn;
@property (strong, nonatomic) IBOutlet FlatButton *setDefaultWidgetBtn;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (copy, nonatomic) NSArray *widgets;
@property (strong, nonatomic) NSMutableArray *currentWidgetConfiguration;
@property (nonatomic) int index;
@property (nonatomic) BOOL isFirstRequest;
@end

@implementation ConfigureWidgetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = MakeImageBarButton(@"barbutton-done", self, @selector(donePressed));
    
    NSMutableArray *w = [NSMutableArray array];
    
    [w addObject:@{@"title": T(@"%configureWidgets.bottleFeed.title"),
                   @"subtitle": T(@"%configureWidgets.bottleFeed.subtitle"),
                   @"preview": @"widget-preview-bottles",
                   @"ID": [BottlefeedingWidgetViewController widgetIdentifier]}];
    
    [w addObject:@{@"title": T(@"%configureWidgets.breastFeed.title"),
                   @"subtitle": T(@"%configureWidgets.breastFeed.subtitle"),
                   @"preview": @"widget-preview-breast",
                   @"ID": [BreastfeedingWidgetViewController widgetIdentifier]}];
    
    [w addObject:@{@"title": T(@"%configureWidgets.weight.title"),
                   @"subtitle": T(@"%configureWidgets.weight.subtitle"),
                   @"preview": @"widget-preview-weight",
                   @"ID": [WeightWidgetViewController widgetIdentifier]}];

#ifdef WIP_TIMELINE
    //TODO propper title,subtitle and prev
    [w addObject:@{@"title": T(@"%configureWidgets.timeline.title"),
                   @"subtitle": T(@"%configureWidgets.timeline.subtitle"),
                   @"preview": @"widget-preview-weight",
                   @"ID": [TimelineWidgetViewController widgetIdentifier]}];
#endif//WIP_TIMELINE

    self.widgets = w;
    
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    self.pageControl.numberOfPages = [self.widgets count];
    [self.pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _isFirstRequest = YES;
    
    // copy current config in order to manipulate it
    self.currentWidgetConfiguration = [[User activeUser].widgetConfiguration mutableCopy];
    
    if([[User activeUser] pregnant] || [[User activeUser].babies count] == 0){
        [_addRemoveWidgetBtn setEnabled:NO];
        [_setDefaultWidgetBtn setEnabled:NO];
    }
    
}


#pragma mark - SwipeViewDataSource

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    if(_index >= 0){
        self.pageControl.currentPage = _index;
        [self updateAddRemoveButtonTitleForPageIndex:_index];
    }
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return [self.widgets count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    _index = index;
    
    if(_isFirstRequest){
        [self updateAddRemoveButtonTitleForPageIndex:index];
        _isFirstRequest = NO;
    }
    
    
    UIView *v = [[UIView alloc] initWithFrame:self.swipeView.frame];
    
    NSDictionary *widgetConfig = [self.widgets objectAtIndex:index];
    NSString *title = widgetConfig[@"title"];
    
    UIColor *color = [UIColor colorWithRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha: 1];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, v.frame.size.width - 10, 40)];
    titleLabel.textColor = color;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Bariol-Regular" size:27.0];
    titleLabel.text = title;
    [v addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, v.frame.size.width, 160)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:widgetConfig[@"preview"]];
    [v addSubview:imageView];
    
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, v.frame.size.height - 50, v.frame.size.width - 10, 50)];
    subtitleLabel.numberOfLines = 3;
    subtitleLabel.textColor = color;
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.font = [UIFont fontWithName:@"Bariol-Regular" size:12.0];
    subtitleLabel.text = widgetConfig[@"subtitle"];
    [v addSubview:subtitleLabel];

    return v;
}

#pragma mark - Helpers

- (void)changePage {
    [self.swipeView setCurrentItemIndex:self.pageControl.currentPage];
}

- (void)updateAddRemoveButtonTitleForPageIndex:(NSInteger)index {
    NSDictionary *widgetConfig = [self.widgets objectAtIndex:index];
    NSString *buttonTitle;
    if ([self.currentWidgetConfiguration containsObject:widgetConfig[@"ID"]]) {
        buttonTitle = T(@"%general.delete");
    } else {
        buttonTitle = T(@"%general.add");
    }
    [self.addRemoveWidgetBtn setTitle:buttonTitle forState:UIControlStateNormal];
}

#pragma mark - Actions

- (IBAction)donePressed {
    // set the configuration back to the user
    [User activeUser].widgetConfiguration = self.currentWidgetConfiguration;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WidgetsHadChangedNotification" object:nil];
    [OverlaySaveView showOverlayWithMessage:T(@"%general.modified") afterDelay:2 performBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)doSetDefaultConfigAndClose {
    
    self.currentWidgetConfiguration = [NSMutableArray array];
    [self.currentWidgetConfiguration addObject:[BottlefeedingWidgetViewController widgetIdentifier]];
    [self.currentWidgetConfiguration addObject:[BreastfeedingWidgetViewController widgetIdentifier]];
    [self.currentWidgetConfiguration addObject:[WeightWidgetViewController widgetIdentifier]];
#ifdef WIP_TIMELINE
    [self.currentWidgetConfiguration addObject:[TimelineWidgetViewController widgetIdentifier]];
#endif//WIP_TIMELINE
    
    [self donePressed];
}

- (IBAction)addRemoveWidgetClicked {
    NSDictionary *widgetConfig = [self.widgets objectAtIndex:self.swipeView.currentItemIndex];
    NSString *identifier = widgetConfig[@"ID"];

    if ([self.currentWidgetConfiguration containsObject:identifier]) {
        [self.currentWidgetConfiguration removeObject:identifier];
    } else {
        [self.currentWidgetConfiguration addObject:identifier];
    }
    
    [self updateAddRemoveButtonTitleForPageIndex:self.swipeView.currentItemIndex];
}

@end
