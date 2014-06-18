//
//  FAQTableViewCell.h
//  Flatland
//
//  Created by Bogdan Chitu on 08/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FaqSection;

@interface FAQTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void) setSection: (FaqSection*) section;

@end
