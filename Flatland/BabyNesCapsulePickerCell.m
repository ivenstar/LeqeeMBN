//
//  BabyNesCapsulePickerCell.m
//  Flatland
//
//  Created by Bogdan Chitu on 18/02/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "BabyNesCapsulePickerCell.h"
#import "FlatButton.h"

@interface BabyNesCapsulePickerCell()
{
    Capsule* currentCapsule;
}

@property (weak, nonatomic) IBOutlet UIImageView *capsuleImageView;
@property (weak, nonatomic) IBOutlet UILabel *capsuleNameLabel;
@property (weak, nonatomic) IBOutlet FlatButton *capsuleSmallSizeButton;
@property (weak, nonatomic) IBOutlet FlatButton *capsuleLargeSizeButton;


@end

@implementation BabyNesCapsulePickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self awakeFromNib];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}

- (void)awakeFromNib
{
    [self.capsuleSmallSizeButton setHidden:YES];
    [self.capsuleLargeSizeButton setHidden:YES];
    [self.capsuleSmallSizeButton setTag:0];
    [self.capsuleLargeSizeButton setTag:1];
    
    [self.capsuleSmallSizeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.capsuleLargeSizeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureForCapsule:(Capsule*) capsule
{
    //set image
    [self.capsuleImageView setImage:[UIImage imageNamed:[capsule imageName]]];
    
    //set name
    [self.capsuleNameLabel setText:capsule.title];
    //set visibility of buttons
    
    //set capsule size selector visiblility
    if ([capsule.sizes count] > 1)
    {
        //set visibility and texts
        [self.capsuleSmallSizeButton setHidden:NO];
        [self.capsuleLargeSizeButton setHidden:NO];
        [self.capsuleSmallSizeButton setTitle:T(@"%capsuleSize.Small") forState:UIControlStateNormal];
        [self.capsuleLargeSizeButton setTitle:T(@"%capsuleSize.Large") forState:UIControlStateNormal];
    }
    else //only one size available - reuse small button
    {
        CGPoint newCenter = self.capsuleSmallSizeButton.center;
        newCenter.x = ((self.capsuleSmallSizeButton.center.x + self.capsuleLargeSizeButton.center.x)/2) - (self.capsuleLargeSizeButton.frame.size.width/2);
        self.capsuleSmallSizeButton.center = newCenter;
        
        CGRect newFrame = self.capsuleSmallSizeButton.frame;
        newFrame.size.width *= 2;
        self.capsuleSmallSizeButton.frame =newFrame;
        
        [self.capsuleSmallSizeButton setTitle:T(@"%capsuleSize.Standard") forState:UIControlStateNormal];
        [self.capsuleSmallSizeButton setHidden:NO];
    
    }
    
    
    currentCapsule = capsule;
}


- (void) buttonClick: (id) sender
{
    if (self.cellDelegate)
    {
        [self.cellDelegate capsuleSelected:currentCapsule withSize:[(FlatButton*) sender tag]];
    }
}


@end
