//
//  OrderSumaryAddressCell.h
//  Flatland
//
//  Created by Bogdan Chitu on 02/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"

@interface OrderSumaryAddressCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *cellTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *streetLabel;
@property (nonatomic, weak) IBOutlet UILabel *cityLabel;

- (void)setAddress:(Address *)address;

@end
