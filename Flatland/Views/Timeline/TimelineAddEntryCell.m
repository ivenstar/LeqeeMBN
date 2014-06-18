//
//  TimelineAddEntryCell.m
//  Flatland
//
//  Created by Bogdan Chitu on 05/05/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineAddEntryCell.h"

#import "TimelineAddEntryViewController.h"
#import "RadioButtonGroup.h"

@interface TimelineAddEntryCell()
@property (weak, nonatomic) IBOutlet RadioButtonGroup *radiobuttonGroup;


@end


@implementation TimelineAddEntryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setUpCell
{
    [self icnhLocalizeSubviews];
    [self changeSystemFontToApplicationFont];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)doAddEntry:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Timeline" bundle:nil];
    TimelineAddEntryViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TimelineAddEntry"];
    
    switch (self.radiobuttonGroup.selectedIndex)
    {
        case 0: //photo
            vc.selectedIndex = 1;
            break;
        case 1: //journal
            vc.selectedIndex = 2;
            break;
        case 2: //mood
            vc.selectedIndex = 0;
            break;
        default:
            break;
    }
    
    [self.navController pushViewController:vc animated:YES];
}
@end
