//
//  CapsulesCell.m
//  Flatland
//
//  Created by Stefan Aust on 20.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CapsulesCell.h"

@implementation CapsulesCell

- (void)setCapsule:(Capsule *)capsule {
    self.capsuleImageView.image = [UIImage imageNamed:capsule.imageName];
    self.label.text = capsule.name;
}

@end
