//
//  FAQTableViewCell.m
//  Flatland
//
//  Created by Bogdan Chitu on 08/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "FAQTableViewCell.h"
#import "FaqSection.h"


@implementation FAQTableViewCell

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
    
- (void) setSection: (FaqSection*) section
{
    self.titleLabel.text = section.title;
}
    


@end
