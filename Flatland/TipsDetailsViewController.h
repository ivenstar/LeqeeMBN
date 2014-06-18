//
//  TipsDetailsViewController.h
//  Flatland
//
//  Created by Magdalena Kamrowska on 29.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"
#import "Tips.h"
#import "Baby.h"
#import <MessageUI/MessageUI.h>

@interface TipsDetailsViewController : FlatViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, weak) Tip *tip;
@property (weak, nonatomic) IBOutlet UIView *colorIndicator;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *additionalTextLabel;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) Baby *baby;

- (IBAction)share:(id)sender;
- (IBAction)love:(id)sender;

@end
