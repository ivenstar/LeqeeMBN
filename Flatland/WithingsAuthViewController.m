//
//  WithingsAuthViewController.m
//  Flatland
//
//  Created by Jochen Block on 03.07.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WithingsAuthViewController.h"
#import "User.h"
#import "AlertView.h"
#import "WaitIndicator.h"

@interface WithingsAuthViewController () <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WithingsAuthViewController {
    BOOL finished;
    BOOL first;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.webView.delegate = self;
    finished = NO;
    [WaitIndicator waitOnView:self.view];
    [[User activeUser] getWithingsUrl:_baby completion:^(NSString *url) {
        [self.view stopWaiting];
        if ([url length] > 0) {
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            NSURL *URL = [[NSURL alloc] initWithString:url];
            NSString *stringHttps = [URL.absoluteString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
            URL = [NSURL URLWithString:stringHttps];
            [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
        } else {
            [[AlertView alertViewFromString:T(@"%balance.alert.newsLetterNoSuccess") buttonClicked:nil] show];
        }
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [WaitIndicator waitOnView:self.view];
    if(finished) {
        [self.view stopWaiting];
        return NO;
    }
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [self.view stopWaiting];
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view stopWaiting];
    if (([webView.request.URL.absoluteString rangeOfString:@"babynes_withings/authorization"].location != NSNotFound) && ([webView.request.URL.absoluteString rangeOfString:@"oauth.withings.com"].location == NSNotFound))
    {
        finished = YES;
        NSLog(@"%s: %@",__FUNCTION__, webView.request.URL.absoluteString);
        if(finished && !first)
        {
            first = YES;
            [[AlertView alertViewFromString:T(@"%balance.alert.registerFinished") buttonClicked:^(NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
            }] show];
            [self.baby setWithingsEnabled:YES];
        }
    }
}

@end
