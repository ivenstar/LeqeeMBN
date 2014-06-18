//
//  ListBreastfeedingViewController.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 29.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "ListBreastfeedingViewController.h"
#import "BreastfeedingCell.h"
#import "EditBreastfeedingViewController.h"
#import "CalendarView.h"
#import "BreastfeedingsDataService.h"
#import "WaitIndicator.h"
#import "HomeViewController.h"

@interface ListBreastfeedingViewController () <UITableViewDataSource, UITableViewDelegate, CalendarViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet CalendarView *calendarView;
@property (nonatomic, copy) NSArray *feedings;

@end

@implementation ListBreastfeedingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = MakeImageBarButton(@"barbutton-delete", self, @selector(deletePressed));

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.calendarView setDelegate:self];
    [self.calendarView setBaseDate:self.date];

}

- (void) setDate:(NSDate *)date
{
    if (date!=_date)
    {
        [_calendarView setBaseDate:date];
        _date = date;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateTableData];
}

#pragma mark - Actions

- (void)deletePressed
{
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
}

#pragma mark - CalendarView Delegate

-(void)calenderView:(CalendarView *)calenderView didSelectDate:(NSDate *)date
{
    if (_date != date)
    {
        _date = date;
        [self updateTableData];
        
        if (self.parentView)
        {
            [self.parentView setDate:_date];
        }
    }
}

#pragma mark - Table view Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feedings count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BreastfeedingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"breastfeedingCell"];
    if(!cell)
    {
        cell = [[BreastfeedingCell alloc] init];
    }
    [cell changeSystemFontToApplicationFont];
    cell.feeding = [self.feedings objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Breastfeeding *feeding = [self.feedings objectAtIndex:indexPath.row];
        [feeding remove:^(BOOL success)
        {
            NSMutableArray *f = [self.feedings mutableCopy];
            [f removeObject:feeding];
            self.feedings = f;
            [self.tableView reloadData];
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EditBreastfeedingViewController *destViewController = segue.destinationViewController;
    destViewController.baby = self.baby;
    
    if ([segue.identifier isEqualToString:@"editBrestfeeding"])
    {
        destViewController.breastfeeding = self.feedings[self.tableView.indexPathForSelectedRow.row];
        destViewController.isEditing = YES;
        destViewController.baby = self.baby;
    }
    
    destViewController.parentView = self;
    destViewController.date = self.date;
}

#pragma mark - Helpers

- (void)updateTableData
{
    [WaitIndicator waitOnView:self.view];

//    [BreastfeedingsDataService loadBreastfeedingsForBaby:self.baby withStartDate:_date timeSpanDays:0 completion:^(NSArray *breastfeedings)
    NSLog(@"epic date before breast list request getByDay: %@", self.date);
    //NSDate *currentTime = [self.date dateByAddingTimeInterval:(24*60*60 -1)];
    [BreastfeedingsDataService loadBreastfeedingsForBaby:self.baby forExactDate:self.date completion:^(NSArray *breastfeedings)
    {
        [self.view stopWaiting];
       
        self.feedings = [breastfeedings copy];
        [self.tableView reloadData];
    }];
}

@end
