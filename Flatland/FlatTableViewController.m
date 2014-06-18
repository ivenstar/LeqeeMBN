//
//  FlatTableViewController.m
//  Flatland
//
//  Created by Jochen Block on 11.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatTableViewController.h"

@interface FlatTableViewController ()

@end

@implementation FlatTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // apply the custom font to all labels (something that cannot be done via IB)
    [self icnhLocalizeView];
    [self.view changeSystemFontToApplicationFont];
    
    // add a graphical back button
    if ([self.navigationController.viewControllers count] > 1 && !self.navigationItem.hidesBackButton) {
        self.navigationItem.leftBarButtonItem = MakeImageBarButton(@"barbutton-back", self, @selector(goBack));
    }
}

#pragma mark - Actions

// required by the graphical back button
- (IBAction)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

// useful for modal dialogs
- (IBAction)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - Autorotation

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationPortrait;
}

@end
