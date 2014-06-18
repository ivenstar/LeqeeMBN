//
//  WifiSetupTermsViewController.m
//  Flatland
//
//  Created by Bogdan Chitu on 03/03/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "WifiSetupTermsViewController.h"
#import "FlatCheckbox.h"
#import "WebViewViewController.h"

@interface WifiSetupTermsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *conditionsDetailsAttributedLabel;
@property (weak, nonatomic) IBOutlet FlatCheckbox *agreedCheck;
@property (weak, nonatomic) IBOutlet UIImageView *agreedCheckedError;

@end

@implementation WifiSetupTermsViewController

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
	// Do any additional setup after loading the view.
    
    
    [self icnhLocalizeView];
    
    //add gesture recognizer
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTermsAndConditions)];
    [self.conditionsDetailsAttributedLabel addGestureRecognizer:gr];
    [self.conditionsDetailsAttributedLabel setUserInteractionEnabled:YES];
    
    //set attributed text
    NSRange range = NSRangeFromString(T(@"%wifisetup.terms.linkRange"));
    NSMutableAttributedString *conditionsDetailsString = [[NSMutableAttributedString alloc] initWithString:T(@"%wifisetup.terms.details")];
    [conditionsDetailsString addAttribute:NSForegroundColorAttributeName value:[UIColor BabyNesLightPurpleColor] range:range];
    [self.conditionsDetailsAttributedLabel setAttributedText:conditionsDetailsString];
    [self.conditionsDetailsAttributedLabel setFont:[UIFont fontWithName:self.conditionsDetailsAttributedLabel.font.fontName size:14]];
    self.conditionsDetailsAttributedLabel.numberOfLines = 0;
    self.conditionsDetailsAttributedLabel.lineBreakMode = NSLineBreakByWordWrapping;

    
    [self.agreedCheck setOn:YES];
}

- (IBAction)doCancel:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doNext:(id)sender
{
    if (self.agreedCheck.isOn)
    {
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WifiSetupInstructions"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        [self.agreedCheckedError setHidden:NO];
    }
}


- (void) doTermsAndConditions
{
    WebViewViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    vc.title = T(@"%menu.information.wifi");
    vc.viewName = T(@"%menu.information.wifi.html");
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
