//
//  BottlefeedingCell.h
//  Flatland
//
//  Created by Jochen Block on 24.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottlefeedingCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *bottleImage;
@property (strong, nonatomic) IBOutlet UIImageView *capsuleImage;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;


- (void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait;

@end
