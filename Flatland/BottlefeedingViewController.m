//
//  BottlefeedingViewController.m
//  Flatland
//
//  Created by Jochen Block on 24.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BottlefeedingViewController.h"
#import "BottlefeedingEditViewController.h"
#import "BottlefeedingDataService.h"
#import "BottlefeedingCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AlertView.h"
#import "CalendarView.h"
#import "Capsule.h"
#import "WaitIndicator.h"
#import "HomeViewController.h"

@interface BottlefeedingViewController ()<CalendarViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *editTableView;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet CalendarView *calendarView;
@property (nonatomic, strong) Bottle *bottle;
@property (nonatomic) BOOL isEditing;
@property (nonatomic) NSIndexPath *indexPath;
@end

@implementation BottlefeedingViewController

@synthesize date = _date;

- (void)setDate:(NSDate *)date {
    _date = date;
    [_calendarView setBaseDate:_date];
    //if (self.parentView)
    //{
    //    [self.parentView setDate:_date];
    //}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    _editTableView.delegate = self;
    
    [_editTableView setDataSource:self];
    
    [_addButton setCornerRadius:0.0f];
    
    self.navigationItem.rightBarButtonItem = MakeImageBarButton(@"barbutton-delete", self, @selector(deletePressed:));
    
    _isEditing = NO;
  
    [self.calendarView setBaseDate:self.date];
    [self.calendarView setDelegate:self];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateTodayFeedingsDataFromServer];
    [_editTableView reloadData];
}

- (void)deletePressed:(id)sender {
    if(_isEditing){
        [_editTableView setEditing:NO animated:YES];
        _isEditing = NO;
    }else{
        [_editTableView setEditing:YES animated:YES];
        _isEditing = YES;
    }
}

- (IBAction)addBottle:(id)sender {
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.feedings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BottleEditCellView";
    BottlefeedingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[BottlefeedingCell alloc] init];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    int row = [indexPath row];
    
    Bottle *bottle = self.feedings[row];
    
    Capsule *capsule = [Capsule capsuleForName:bottle.capsuleType];
    cell.capsuleImage.image = [UIImage imageNamed:capsule.imageName];
    
    NSArray* parts = [self.baby.capsuleImage componentsSeparatedByString: @"/"];
    NSString* image = [parts objectAtIndex: [parts count]-1];
    cell.bottleImage.image = [UIImage imageNamed:image];
    
    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"HH'h'mm"];
    NSString *time = [dateFormatter stringFromDate:bottle.date];
    cell.timeLabel.text = time;
    cell.quantityLabel.text = [[NSString alloc] initWithFormat:@"%@ %@", bottle.quantity, T(@"%bottlefeeding.ml")];
    
    cell.bottleImage.image = [UIImage imageNamed:bottle.bottleImageName];
    
    UIColor *myColor = [UIColor colorWithRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha: 1];
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 75, 320, 1)];
    line.backgroundColor = myColor;
    [cell addSubview:line];
    
    return cell;
}

#pragma mark - Table view delegate

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _indexPath = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:T(@"%bottlefeeding.delete") message:T(@"%bottlefeeding.alert") delegate:self cancelButtonTitle:T(@"%general.cancel") otherButtonTitles:T(@"%general.delete"), nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex]) {
        NSMutableArray *elements = [self.feedings mutableCopy];
        Bottle *bottle = self.feedings[_indexPath.row];
        [elements removeObjectAtIndex:_indexPath.row];
        
        [bottle removeBottle:^(BOOL success) {
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBottleFinishedNotification" object:nil];
                //[[AlertView alertViewFromString:@"Deleted|Element deleted.|Ok" buttonClicked:nil] show];
            } else {
                [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
            }
        }];
        
        self.feedings = [elements copy];
        [self.editTableView reloadData];
    }
}

#pragma mark -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editBottleEditEntry"])
    {
        BottlefeedingEditViewController *destViewController = segue.destinationViewController;
        destViewController.baby = self.baby;
        destViewController.isEditing = true;
        destViewController.date = _date;
        NSIndexPath *selectedIndexPath = [_editTableView indexPathForSelectedRow];
        destViewController.bottle = self.feedings[selectedIndexPath.row];
        destViewController.parentView = self;
    }
    else
    {
        BottlefeedingEditViewController *destViewController = segue.destinationViewController;
        destViewController.baby = self.baby;
        destViewController.isEditing = false;
        destViewController.date = _date;
        destViewController.parentView = self;
    }
}


#pragma mark - CalendarViewDelegate

- (void)calenderView:(CalendarView *)calenderView didSelectDate:(NSDate *)date {
    _date = date;
    
    if (self.parentView)
    {
        [self.parentView setDate:_date];
    }
    
    self.feedings = nil;
    [self.editTableView reloadData];
    
    [self updateTodayFeedingsDataFromServer];
}

// This code is here so that CalendarView openCalendar functions properly
- (void)doAdjustCapsuleStockNotification {

}

- (void) updateTodayFeedingsDataFromServer
{
    [WaitIndicator waitOnView:self.view];
    
    [BottlefeedingDataService loadBottlefeedingsForBaby:self.baby forExactDate:self.date completion:^(NSArray *bottles)
    {
        [self.view stopWaiting];
        
        self.feedings = bottles;
        [self.editTableView reloadData];
        if (!bottles)
        {
           [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
        }
    }];
    
//    [BottlefeedingDataService getLastBottlefeedingsWithBaby:self.baby date:self.date completion:^(NSArray *bottles) {
//        if (bottles)
//        {
////            self.lastFeedings = bottles;
////            [self.swipeView reloadData];
////            [self.swipeView reloadInputViews];
//        }
//    }];
}
//
//- (NSString *) getCapsuleImageForCapsule: (Capsule*) capsule withQuantity: (float) quantity;
//{
//    float percent =
//    
//    
//    
//    return @"bottle_01.png";
//}



@end
