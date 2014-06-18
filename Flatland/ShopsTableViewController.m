//
//  ShopsTableViewController.m
//  Flatland
//
//  Created by Jochen Block on 10.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "ShopsTableViewController.h"
#import "RESTService.h"
#import "ShopTableViewCell.h"
#import "ShopsDetailsViewController.h"

@interface ShopsTableViewController ()

@end

@implementation ShopsTableViewController

@synthesize stores;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    return stores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"shopCellView"; //why static?
    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    int row = [indexPath row];

    cell.shopDescription.text = [stores[row] valueForKey:@"name"];
    
    NSString *shopAddress = nil;
    if ([stores[row] valueForKey:@"street"] != nil)
    {
        shopAddress = [[stores[row] valueForKey:@"street"] copy];
    }
    
    if ([stores[row] valueForKey:@"city"] != nil)
    {
        if (shopAddress != nil)
        {
            shopAddress = [NSString stringWithFormat:@"%@ %@",shopAddress,[stores[row] valueForKey:@"city"]];
        }
        else
        {
            shopAddress = [[stores[row] valueForKey:@"city"] copy];
        }
    }
    
    cell.shopAddress.text = shopAddress;
    

    
    return cell;
}


#pragma mark - Table view delegate


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showShopDetailsView"]) {
        ShopsDetailsViewController *destViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        int row = [indexPath row];
        
        
        destViewController.store = stores[row];
    }
}

@end
