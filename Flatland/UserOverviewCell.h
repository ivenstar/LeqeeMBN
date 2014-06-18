//
//  UserOverviewCell.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 14.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Address.h"

@interface UserOverviewCell : UITableViewCell

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Address *userAddress;
@end
