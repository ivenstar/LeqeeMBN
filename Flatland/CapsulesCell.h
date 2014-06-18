//
//  CapsulesCell.h
//  Flatland
//
//  Created by Stefan Aust on 20.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Capsule.h"

/**
 * Displays a capsule type as part of the `CapsulesViewController`.
 */
@interface CapsulesCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *capsuleImageView;
@property (nonatomic, weak) IBOutlet UILabel *label;

- (void)setCapsule:(Capsule *)capsule;

@end
