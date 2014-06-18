//
//  TimelineAddEntryCell.h
//  Flatland
//
//  Created by Bogdan Chitu on 05/05/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineAddEntryCell : UITableViewCell

@property (nonatomic, weak) UINavigationController* navController;

- (void) setUpCell;

@end
