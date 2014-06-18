//
//  ShareVC.m
//  Flatland
//
//  Created by Ionel Pascu on 2/14/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "ShareVC.h"
#import "AlertView.h"
#import "OverlaySaveView.h"

@interface ShareVC ()

@end

@implementation ShareVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareFB:(id)sender {
    SLComposeViewController *fbVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [fbVC setInitialText:_text];
    //[fbVC addURL:[NSURL URLWithString:@"http://www.babynes.com"]];
    [fbVC addImage:_image];
    
    //completion handling
    [fbVC setCompletionHandler:^(SLComposeViewControllerResult result) {
        
        switch (result) {
            case SLComposeViewControllerResultCancelled:
            {
                //[[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
                NSLog(@"FB Post Canceled");
            }
                break;
            case SLComposeViewControllerResultDone:
            {
                [OverlaySaveView showOverlayLandscapeWithMessage:T(@"%general.added") afterDelay:2 performBlock:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];

                NSLog(@"Post Sucessful");
            }
                break;
                
            default:
                break;
        }
    }];
    
    
    [self presentViewController:fbVC animated:YES completion:nil];

}

- (IBAction)shareTwitter:(id)sender {
    SLComposeViewController *twitterVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [twitterVC setInitialText:_text];
    //[twitterVC addURL:[NSURL URLWithString:@"http://www.babynes.com"]];
    [twitterVC addImage:_image];
    
    //completion handling
    [twitterVC setCompletionHandler:^(SLComposeViewControllerResult result) {
        
        switch (result) {
            case SLComposeViewControllerResultCancelled:
            {
                //[[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
                NSLog(@"Twitter Post Canceled");
            }
                break;
            case SLComposeViewControllerResultDone:
            {
                [OverlaySaveView showOverlayLandscapeWithMessage:T(@"%general.added") afterDelay:2 performBlock:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                
                NSLog(@"Post Sucessful");
            }
                break;
                
            default:
                break;
        }
    }];
    
    [self presentViewController:twitterVC animated:YES completion:nil];
}

- (IBAction)shareEmail:(id)sender {
    // Compose dialog
    MFMailComposeViewController *emailDialog = [[MFMailComposeViewController alloc] init];
    emailDialog.mailComposeDelegate = self;
    NSMutableString *emailBody = [NSMutableString string];
    [emailDialog setToRecipients:[NSArray arrayWithObject:@""]];
    //
    [emailBody appendString:@"<html><body>"];
    [emailBody appendString:_text];
    [emailBody appendString:@"</body></html>"];
    //add image
    NSString *fileName = @"babynes_graph_share";
    fileName = [fileName stringByAppendingPathExtension:@"png"];
    [emailDialog addAttachmentData:[NSData dataWithContentsOfFile:_imagePath] mimeType:@"image/png" fileName:fileName];
    // Set subject
    [emailDialog setSubject:_subject];
    
    
    // Set body
    [emailDialog setMessageBody:emailBody isHTML:YES]; 

    
    // Show mail
    if (emailDialog != nil)
    [self presentViewController:emailDialog animated:YES completion:^{}];
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
        {
            [OverlaySaveView showOverlayLandscapeWithMessage:T(@"%general.added") afterDelay:2 performBlock:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
            NSLog(@"Email Post Sucessful");
        }
            break;
        case MFMailComposeResultFailed:
            [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark Orientation
- (void)deviceOrientationDidChange: (id) sender{
    NSLog(@"Orientation changed!!!!!");
    if ([[UIDevice currentDevice] orientation] == (UIDeviceOrientationPortrait)){
        NSLog(@"Landscape OFF");
        //[self.originNavigationController popViewControllerAnimated:YES];
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == (UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationLandscapeLeft));}
-(BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}

@end
