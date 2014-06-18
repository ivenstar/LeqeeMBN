//
//  CartCell.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 25.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CartCell.h"
#import "Capsule.h"

@implementation CartCell

- (void)setOrderItem:(OrderItem *)orderItem {
    if ([orderItem isMachine]) {
        self.capsuleImageView.image = [UIImage imageNamed:@"machine"];
        self.nameLabel.text = T(@"%cart.machine");
        self.sizeLabel.text = T(@"%cart.machine.addition");
        
        NSString *format = orderItem.quantity == 1 ? T(@"%cart.onePiece") : T(@"%cart.morePieces");
        self.quantityLabel.text = [NSString stringWithFormat:format, orderItem.quantity];
        self.capsuleCountLabel.text = @"";
    } else {
        Capsule *capsule = [Capsule capsuleForType:orderItem.capsuleType];
        self.capsuleImageView.image = [UIImage imageNamed:capsule.imageName];
        self.nameLabel.text = capsule.name;
        self.sizeLabel.text = [NSString stringWithFormat:@"%d %@", orderItem.ml,T(@"%bottlefeeding.ml")];
        
        NSString *format = orderItem.quantity == 1 ? T(@"%cart.oneBox") : T(@"%cart.moreBoxes");
        self.quantityLabel.text = [NSString stringWithFormat:format, orderItem.quantity];
        self.capsuleCountLabel.text = [NSString stringWithFormat:T(@"%cart.moreCapsules"), orderItem.quantity * 26];
    }
    self.priceLabel.text = [NSString stringWithFormat:T(@"%cart.priceWithPrice"), FormatPrice([orderItem price] * orderItem.quantity)];
}

#pragma mark - Modify UI for edit mode

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    [super willTransitionToState:state];
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) != 0) {
        self.quantityLabel.hidden = YES;
        self.capsuleCountLabel.hidden = YES;
        self.priceLabel.hidden = YES;
    }
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {
    [super didTransitionToState:state];
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == 0) {
        self.quantityLabel.hidden = NO;
        self.capsuleCountLabel.hidden = NO;
        self.priceLabel.hidden = NO;
    }
}

- (void) prepareForReuse {
    [super prepareForReuse];
    self.quantityLabel.hidden = NO;
    self.capsuleCountLabel.hidden = NO;
    self.priceLabel.hidden = NO;
}

@end
