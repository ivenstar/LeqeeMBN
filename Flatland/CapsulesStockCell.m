//
//  CapsulesStockCell.m
//  Flatland
//
//  Created by Stefan Aust on 16.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CapsulesStockCell.h"

@implementation CapsulesStockCell

- (IBAction)smallCountChanged:(UIStepper *)sender {
    self.smallCountLabel.text = [NSString stringWithFormat:@"%.0f", sender.value];
    [self.stock setCount:sender.value ofCapsuleType:self.type size:@"Small"];
}

- (IBAction)largeCountChanged:(UIStepper *)sender {
    self.largeCountLabel.text = [NSString stringWithFormat:@"%.0f", sender.value];
    [self.stock setCount:sender.value ofCapsuleType:self.type size:@"Large"];
}

@end
