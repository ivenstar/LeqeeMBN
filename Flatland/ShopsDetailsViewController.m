//
//  ShopsDetailsViewController.m
//  Flatland
//
//  Created by Jochen Block on 11.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "ShopsDetailsViewController.h"

@interface ShopsDetailsViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) IBOutlet UILabel *shopName;
@property (strong, nonatomic) IBOutlet UILabel *shopStreet;
@property (strong, nonatomic) IBOutlet UILabel *shopZipCity;
@property (strong, nonatomic) IBOutlet UILabel *shopPhone;
@property (weak, nonatomic) IBOutlet UILabel *shopHours;
@property (weak, nonatomic) IBOutlet UIButton *callButton;

@property (strong, nonatomic) IBOutlet UILabel *shopSellType;
@property (strong, nonatomic) IBOutlet UILabel *shopDemonstration;
@property (strong, nonatomic) IBOutlet UILabel *shopNextDemonstration;

@property (nonatomic, copy) NSString *phoneNumber;

-(IBAction)callShop:(id)sender;
@end

@implementation ShopsDetailsViewController

@synthesize store;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([store valueForKey:@"name"])
    {
        _shopName.text = [store valueForKey:@"name"];
    }
    else
    {
        _shopName.text = nil;//cleanup
    }
    
    if ([store valueForKey:@"street"])
    {
        _shopStreet.text = [store valueForKey:@"street"];
    }
    else
    {
        _shopStreet.text = nil;//cleanup
    }
    
    NSString *city;
    if ([store valueForKey:@"zipCode"])
    {
        city = [[store valueForKey:@"zipCode"] copy];
    }
    if ([store valueForKey:@"city"])
    {
        if (city)
        {
            city = [NSString stringWithFormat:@"%@ %@",city,[store valueForKey:@"city"]];
        }
        else
        {
            city = [[store valueForKey:@"city"] copy];
        }
    }
    
    _shopZipCity.text = city;
    _shopPhone.text = [store valueForKey:@"phone"];
    
    //setup shop hours
    NSString* shopHoursStr = [store valueForKey:@"shopHours"];
    if (shopHoursStr != nil && (id)shopHoursStr != [NSNull null])
    {
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\n" options:NSRegularExpressionCaseInsensitive error:&error];
        int nbLines = [regex numberOfMatchesInString:shopHoursStr options:0 range:NSMakeRange(0, [shopHoursStr length])] + 1;
        
        [self fitText:shopHoursStr toLabel:self.shopHours withNumberOfLines:nbLines];
        
    }
    else
    {
        self.shopHours.text = nil; //cleanup
    }
    
    NSError *error = nil;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber | NSTextCheckingTypeLink error:&error];
    
    [detector enumerateMatchesInString:_shopPhone.text options:kNilOptions range:NSMakeRange(0, _shopPhone.text.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [_callButton setTitle:[NSString stringWithFormat:@"%@ %@", T(@"%general.call"), result.phoneNumber] forState:UIControlStateNormal];
        [_callButton setTitle:[NSString stringWithFormat:@"%@ %@", T(@"%general.call"), result.phoneNumber] forState:UIControlStateSelected];
        _phoneNumber = [NSString stringWithFormat:@"tel:%@", [result.phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""]];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_phoneNumber]]) {
            [_callButton setEnabled:YES];
        } else {
            [_callButton setEnabled:NO];
        }
    }];
    
    NSString *sellsText = @"";
    if ([[store valueForKey:@"sellsCapsules"] boolValue])
    {
        if ([[store valueForKey:@"sellsMachines"] boolValue])
        {
            sellsText = T(@"storeLocator.sellsBoth");
        }
        else
        {
            sellsText = T(@"storeLocator.sellsCapsules");
        }
    }
    else
    {
        if ([[store valueForKey:@"sellsMachines"] boolValue])
        {
            sellsText = T(@"storeLocator.sellsMachines");
        }
    }
    
    NSString *demonstrationText = @"";
    NSString *descriptionText = @"";
    
    NSArray *demonstrations = [store valueForKeyPath:@"demonstrations"];
    if ([demonstrations count] > 0)
    {
        demonstrationText = T(@"storeLocator.hasDemonstations");
        
        NSDictionary *demonstration = [demonstrations objectAtIndex:0];
        descriptionText = [demonstration valueForKey:@"description"];
    }
    
    _shopSellType.text = sellsText;
    
    [self fitText:demonstrationText toLabel:self.shopDemonstration];
    [self fitText:descriptionText toLabel:self.shopNextDemonstration];
    
    
    //disable scrolling for views that fit
    if (self.containerView.frame.size.height <= self.scrollView.frame.size.height)
    {
        [self.scrollView setScrollEnabled:NO];
    }
    
}

- (void) fitText:(NSString*)text toLabel:(UILabel*) label
{
    [self fitText:text toLabel:label withNumberOfLines:-1];
}

//the numberOfLines arg is for texts to witch you know the number of lines.No other calculations are made
- (void) fitText:(NSString*)text toLabel:(UILabel*) label withNumberOfLines:(int) numberOfLines
{
    
    CGRect frame = label.frame;
    if (numberOfLines<1)
    {
        label.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize constrain = CGSizeMake(label.bounds.size.width, FLT_MAX);
        CGSize size = [text sizeWithFont:label.font constrainedToSize:constrain lineBreakMode:NSLineBreakByWordWrapping];
        
        numberOfLines = ceil((float)size.height / label.font.lineHeight);
    }
    
    label.numberOfLines = numberOfLines;
    label.text = text;
    [label sizeToFit];
    
    int sizeDif = label.frame.size.height - frame.size.height;
    
    if (sizeDif > 0)
    {
        //modify container view size and scroll view content size to fit
        CGRect containerViewFrame = self.containerView.frame;
        containerViewFrame.size.height += sizeDif;
        self.containerView.frame = containerViewFrame;
        self.scrollView.contentSize = containerViewFrame.size;
        
        //move each view bellow label down
        for (UIView *view in self.containerView.subviews)
        {
            if (view.frame.origin.y > label.frame.origin.y)
            {
                CGPoint newCenter =  view.center;
                newCenter.y += sizeDif;
                view.center = newCenter;
            }
        }
    }
}

- (IBAction)callShop:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_phoneNumber]];
}
@end
