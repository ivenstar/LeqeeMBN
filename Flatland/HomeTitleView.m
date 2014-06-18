//
//  HomeTitleView.m
//  Flatland
//
//  Created by Stefan Aust on 15.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "HomeTitleView.h"
#import <QuartzCore/QuartzCore.h>

@interface HomeTitleView ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *notificationButton;
@property (nonatomic, weak) UILabel *notificationLabel;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

@end

@implementation HomeTitleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self awakeFromNib];
    return self;
}

- (void)awakeFromNib {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 2;
    titleLabel.font = [UIFont boldFontOfSize:22];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = .5;
    [self addSubview:titleLabel];
    
    UIButton *notificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [notificationButton setImage:[UIImage imageNamed:@"button-notification"] forState:UIControlStateNormal];
    [self addSubview:notificationButton];
    
    UILabel *notificationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    notificationLabel.backgroundColor = [UIColor colorWithRGBString:@"FCFCFC"];
    notificationLabel.text = [NSString stringWithFormat:@"%d", self.notificationCount];
    notificationLabel.textColor = [UIColor colorWithRGBString:@"4D4B5F"];
    notificationLabel.textAlignment = NSTextAlignmentCenter;
    notificationLabel.font = [UIFont systemFontOfSize:10];
    notificationLabel.hidden = self.notificationCount == 0;
    notificationLabel.layer.cornerRadius = 3;
    [self addSubview:notificationLabel];
    
    self.titleLabel = titleLabel;
    self.notificationButton = notificationButton;
    self.notificationLabel = notificationLabel;
}

- (void)setTitle:(NSString *)title {
    if (![_title isEqualToString:title]) {
        _title = title;
        self.titleLabel.text = title;
        [self setNeedsLayout];
    }
}

- (void)setNotificationCount:(NSInteger)notificationCount {
    if (_notificationCount != notificationCount) {
        _notificationCount = notificationCount;
        if (notificationCount) {
            self.notificationLabel.hidden = NO;
            self.notificationLabel.text = [NSString stringWithFormat:@"%d", notificationCount];
        } else {
            self.notificationLabel.hidden = YES;
        }
    }
}

- (void)addTarget:(id)target action:(SEL)action {
    [self.notificationButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    CGSize size = self.bounds.size;
    CGFloat viewWidth = size.width;
    
    CGFloat viewHeight = size.height;
    size.width -= 45;
    size = [self.titleLabel sizeThatFits:size];
    
    CGFloat x = (viewWidth - size.width - 40) / 2;
    self.titleLabel.frame = CGRectMake(x, (viewHeight - 40) / 2, size.width, viewHeight);
    self.notificationButton.frame = CGRectMake(x + size.width, (viewHeight - 40) / 2, 40, 40);
    self.notificationLabel.frame = CGRectMake(x + size.width + 40 - 12, (viewHeight - 40) / 2 + 6, 12, 12);
}

@end
