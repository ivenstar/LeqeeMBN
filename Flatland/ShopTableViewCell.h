//
//  ShopTableViewCell.h
//  Flatland
//
//  Created by Jochen Block on 11.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *shopDescription;
@property (strong, nonatomic) IBOutlet UILabel *shopAddress;
@end
