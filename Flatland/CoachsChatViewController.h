//
//  CoachsChatViewController.h
//  Flatland
//
//  Created by Magdalena Kamrowska on 12.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Baby.h"
#import "FlatViewController.h"

@interface CoachsChatViewController : FlatViewController <UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *chatInput;
@property (weak, nonatomic) IBOutlet UITableView *chatView;
@property (weak, nonatomic) IBOutlet UIView *chatControlsContainer;
@property (nonatomic, retain) Baby* baby;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;


- (IBAction)send:(id)sender;

@end
