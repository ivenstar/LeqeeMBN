//
//  ShareVC.h
//  Flatland
//
//  Created by Ionel Pascu on 2/14/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatViewController.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>

@interface ShareVC : FlatViewController <MFMailComposeViewControllerDelegate>
- (IBAction)shareFB:(id)sender;
- (IBAction)shareTwitter:(id)sender;
- (IBAction)shareEmail:(id)sender;
- (IBAction)backAction:(id)sender;
@property (nonatomic, strong) NSString* subject;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imagePath;

@end
