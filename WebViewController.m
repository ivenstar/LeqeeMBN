//
//  WebViewController.m
//  Flatland
//
//  Created by Pirlitu Vasilica on 12/6/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

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
    
    if(self.url!=nil)
    {
        NSString *stringHttps = [self.url stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
        self.url = stringHttps;
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
        [self.webView loadRequest:req];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(id)initWithLink:(NSString*)link
{
    self = [super initWithNibName:@"WebViewController" bundle:nil];
    self.webView.delegate = self;
    if (self) {
        // Custom initialization
        self.url=link;
    }
    return self;
}
- (IBAction)backAction:(id)sender {
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
