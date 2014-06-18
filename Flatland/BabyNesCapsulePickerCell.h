//
//  BabyNesCapsulePickerCell.h
//  Flatland
//
//  Created by Bogdan Chitu on 18/02/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Capsule.h"

@protocol BabyNesCapsulePickerCellDelegate;
@interface BabyNesCapsulePickerCell : UITableViewCell

@property (nonatomic, assign) id cellDelegate;

- (void) configureForCapsule:(Capsule*) capsule;
@end

@protocol BabyNesCapsulePickerCellDelegate

- (void) capsuleSelected:(Capsule*) capsule withSize:(int) capsuleSize;

@end
