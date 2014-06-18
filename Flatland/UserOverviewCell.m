//
//  UserOverviewCell.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 14.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "UserOverviewCell.h"
@interface UserOverviewCell()
{
    CGPoint streetLabelOriginalCenter;
    CGPoint cityLabelOriginalCenter;
    CGPoint mobilePhoneLabelOriginalCenter;
    CGPoint emailLabelOriginalCenter;
    
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobilePhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation UserOverviewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self storeCenters];
}

- (void) storeCenters
{
    streetLabelOriginalCenter = self.streetLabel.center;
    cityLabelOriginalCenter = self.cityLabel.center;
    mobilePhoneLabelOriginalCenter = self.mobilePhoneLabel.center;
    emailLabelOriginalCenter = self.emailLabel.center;
}

- (void)setUser:(User *)user
{
    self.emailLabel.text = user.email;
}

- (void)setUserAddress:(Address *)userAddress
{
    float dy = 0;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@ %@", userAddress.localizedTitle, userAddress.firstName, userAddress.lastName];
    
    if (nil != userAddress.street)
    {
        self.streetLabel.center = streetLabelOriginalCenter;
    }
    else
    {
        dy = self.streetLabel.frame.size.height;
        self.streetLabel.center = CGPointMake(-500, -500);
    }
    
    
    NSString *cityLabelText = nil;
    if (nil != userAddress.ZIP)
    {
        cityLabelText = [[NSString alloc] initWithString:userAddress.ZIP];
    }
    if (nil != userAddress.city)
    {
        if (nil!=cityLabelText)
        {
            cityLabelText = [NSString stringWithFormat:@"%@ %@",cityLabelText,userAddress.city];
        }
        else
        {
            cityLabelText = [[NSString alloc] initWithString:userAddress.city];
        }
    }
    
    if (nil != cityLabelText)
    {
        self.cityLabel.center = CGPointMake(cityLabelOriginalCenter.x, cityLabelOriginalCenter.y - dy);
        self.cityLabel.text = cityLabelText;
    }
    else
    {
        dy += self.cityLabel.frame.size.height;
        self.cityLabel.center = CGPointMake(-500, -500);
    }
    
    if (nil != userAddress.mobile)
    {
        self.mobilePhoneLabel.text = userAddress.mobile;
        self.mobilePhoneLabel.center = CGPointMake(mobilePhoneLabelOriginalCenter.x, mobilePhoneLabelOriginalCenter.y - dy);
    }
    else
    {
        dy += self.mobilePhoneLabel.frame.size.height;
        self.mobilePhoneLabel.center = CGPointMake(-500, -500);
    }
    
    self.emailLabel.center = CGPointMake(emailLabelOriginalCenter.x, emailLabelOriginalCenter.y - dy);
}
@end
