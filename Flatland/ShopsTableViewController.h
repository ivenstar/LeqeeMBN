//
//  ShopsTableViewController.h
//  Flatland
//
//  Created by Jochen Block on 10.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopTableViewCell.h"
#import "FlatTableViewController.h"

@interface ShopsTableViewController : FlatTableViewController

@property (strong, nonatomic) IBOutlet UILabel *shopDescription;

@property (strong, nonatomic) IBOutlet UILabel *shopAddress;

@property (nonatomic, copy) NSArray *stores;

@end
