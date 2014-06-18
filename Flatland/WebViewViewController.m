//
//  WebViewViewController.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 09.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.modal) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    }
    
    self.webView.delegate = self;

    NSURL *URL = [[NSBundle mainBundle] URLForResource:self.viewName withExtension:@"html"];
    NSString *stringHttps = [URL.absoluteString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    URL = [NSURL URLWithString:stringHttps];
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
    
    
    if(self.url!=nil)
    {
        NSString *stringHttps = [self.url stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
        self.url = stringHttps;
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
        [self.webView loadRequest:req];
    
    }
    
    if (IS_IOS7)
    {
        UIView *blackBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        [blackBar setBackgroundColor:[UIColor blackColor]];
        
        [self.view addSubview:blackBar];
        
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

- (void)done:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)donePressed:(id)sender {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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


@end
