//
//  ContactViewController.m
//  Flatland
//
//  Created by Stefan Aust on 14.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "ContactViewController.h"
#import "FlatTextView.h"
#import "ScaleViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "AlertView.h"
#import "RESTService.h"
#import "WaitIndicator.h"
#import "OverlaySaveView.h"

@interface ContactViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet FlatTextView *messageField;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)initiateCall:(id)sender
{
    CallSupport();
}

- (IBAction)sendMessage:(id)sender
{
    if(self.messageField.text.length > 0){
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
         picker.mailComposeDelegate = self;
         [picker setSubject:T(@"%contact.email.subject")];
         [picker setMessageBody:self.messageField.text isHTML:NO];
         [picker setToRecipients:@[T(@"%contact.email")]];
         picker.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    switch (result)
    {
        case MFMailComposeResultSent:
            {
                [OverlaySaveView showOverlayWithMessage:T(@"%login.contact.sent") afterDelay:2 performBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.messageField resignFirstResponder];
    return YES;
}

@end
