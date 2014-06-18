//
//  CapsulesStockCell.h
//  Flatland
//
//  Created by Stefan Aust on 16.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stock.h"

/**
 * Displays a capsule stock entry as part of the `CapsulesStockViewController`.
 */
@interface CapsulesStockCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *capsuleImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *smallSizeLabel;
@property (nonatomic, weak) IBOutlet UILabel *largeSizeLabel;
@property (nonatomic, weak) IBOutlet UILabel *smallCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *largeCountLabel;
@property (nonatomic, weak) IBOutlet UIStepper *smallCountStepper;
@property (nonatomic, weak) IBOutlet UIStepper *largeCountStepper;

@property (nonatomic, strong) Stock *stock;
@property (nonatomic, copy) NSString *type;

@end
