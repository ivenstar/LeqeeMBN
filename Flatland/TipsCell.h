//
//  TipsCell.h
//  Flatland
//
//  Created by Magdalena Kamrowska on 29.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tips.h"

@interface TipsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *categoryIndicator;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, weak) Tip *tip;
@property (weak, nonatomic) IBOutlet UIImageView *accessoryContainer;

- (void)configure;

@end
