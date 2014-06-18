//
//  WifiWelcomeViewController.h
//  Flatland
//
//  Created by Stefan Matthias Aust on 19.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"
#import "WifiBaseViewController.h"
#import "FlatButton.h"

@interface WifiWelcomeViewController : WifiBaseViewController

@property (weak, nonatomic) IBOutlet FlatButton *buttonNext;
@property (weak, nonatomic) IBOutlet FlatDarkButton *buttonBegin;

@end
