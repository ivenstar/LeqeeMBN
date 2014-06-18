//
//  BabyNesCapsulePicker.h
//  Flatland
//
//  Created by Bogdan Chitu on 18/02/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Capsule.h"


@protocol BabyNesCapsulePickerDelegate;

@interface BabyNesCapsulePicker : UIControl


@property(nonatomic,assign) id<BabyNesCapsulePickerDelegate> capsulePickerDelegate;

@end


@protocol BabyNesCapsulePickerDelegate

- (void) picker:(BabyNesCapsulePicker*)picker didSelectCapsule: (Capsule*) selectedCapsule capsuleSize:(int) capsuleSize;

@end

