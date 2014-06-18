//
//  TipsViewController.h
//  Flatland
//
//  Created by Magdalena Kamrowska on 29.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatTableViewController.h"
#import "Baby.h"

@interface TipsViewController : FlatTableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL favorites;
@property (nonatomic) BOOL isEdited;
@property (nonatomic, strong) Baby *baby;
@end
