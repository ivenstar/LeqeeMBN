//
//  HomeNotificationView.h
//  Flatland
//
//  Created by Stefan Aust on 15.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeNotificationView : UIView

@property (nonatomic, strong) NSArray *notifications;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id delegate;

- (void)toggle;
- (void)close;

@end


@interface HomeNotificationWarnTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *notificationTextLabel;

- (void)setData:(id)notification;

@end

@interface HomeNotificationNoteTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *notificationTextLabel;

- (void)setData:(id)notification;

@end