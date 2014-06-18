//
//  ShopTableViewCell.m
//  Flatland
//
//  Created by Jochen Block on 11.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "ShopTableViewCell.h"

@implementation ShopTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

@end
