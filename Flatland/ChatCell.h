//
//  ChatCell.h
//  Flatland
//
//  Created by Magdalena Kamrowska on 16.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *chatBackground;
@property (nonatomic, weak) NotificationMessage* message;

@property (weak, nonatomic) IBOutlet UIView *requestBG;


- (void)configure;

-(void)roundCorners;

@end
