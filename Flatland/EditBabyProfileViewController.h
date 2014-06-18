//
//  EditBabyProfileViewController.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 12.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"
#import "Baby.h"

/**
 * Edit/Create BabyProfile from Menu Button
 */
@interface EditBabyProfileViewController : FlatViewController

@property (nonatomic, strong) Baby *baby; ///the baby to edit; if nill than create one

@end
