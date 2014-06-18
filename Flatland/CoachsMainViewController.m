//
//  CoachsMainViewController.m
//  Flatland
//
//  Created by Magdalena Kamrowska on 12.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CoachsMainViewController.h"
#import "CoachsChatViewController.h"

@interface CoachsMainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *header;
@property (weak, nonatomic) IBOutlet UILabel *body;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *footer;

@end

@implementation CoachsMainViewController

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
    [_header setFont:[UIFont lightFontOfSize:30]];
    [_body setFont:[UIFont lightFontOfSize:18]];
    [_footer setFont:[UIFont lightFontOfSize:10]];
    [_chatButton.titleLabel setFont:[UIFont lightFontOfSize:20]];
    [_callButton.titleLabel setFont:[UIFont lightFontOfSize:20]];
    _chatButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _chatButton.titleLabel.numberOfLines = 0;
    _chatButton.titleLabel.textAlignment = NSTextAlignmentRight;
    
    _callButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _callButton.titleLabel.numberOfLines = 0;
    _callButton.titleLabel.textAlignment = NSTextAlignmentRight;
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:T(@"%coach.phoneNo")]]) {
        [_callButton setEnabled:YES];
    } else {
        [_callButton setEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - actions
- (IBAction)openChat:(id)sender {
    CoachsMainViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CoachsChat"];
    vc.baby = _baby;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)callNutritionist:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:T(@"%coach.phoneNo")]];
}
@end
