//
//  HomeTitleView.h
//  Flatland
//
//  Created by Stefan Aust on 15.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTitleView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger notificationCount;

- (void)addTarget:(id)target action:(SEL)action;

@end
