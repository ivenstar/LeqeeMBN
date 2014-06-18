//
//  PaymentViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "PaymentViewController.h"
#import "WaitIndicator.h"
#import "User.h"
#import "PaymentSuccessViewController.h"
#import "PaymentFailureViewController.h"

@interface PaymentViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([WaitIndicator waitOnView:self.view]) {
        [[User activeUser] postOrder:^(NSError *error, PaymentData *result)
        {
            if (!result)
            {
                [self.view stopWaiting];
                [[AlertView alertViewWithTitle:T(@"%general.error")
                                       message:T(@"%cart.payment.error")//[error localizedDescription]
                                  buttonTitles:@[@"OK"]
                                 buttonClicked:^(NSInteger buttonIndex)
                  {
                      [self.navigationController popViewControllerAnimated:YES];
                  }] show];
            }
            else
            {
                [Order sharedOrder].email = [User activeUser].email;

                // extract and store the order no which should be part of the result
                [Order sharedOrder].orderNo = result.orderNo;
                
                // extract the URL to hand over the payment process to the payment provider
                //extra check HTTPS
                NSString *stringHttps = [result.paymentURL stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
                NSURL *URL = [NSURL URLWithString:stringHttps];
                
                // load the web page of the payment provider; see delegate method for how to proceed
                [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
            }
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view stopWaiting];
}

#pragma mark - Web View Delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.view stopWaiting];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [WaitIndicator waitOnView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view stopWaiting];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // we look for magic URLs and allow all other navigation
//    if (navigationType == UIWebViewNavigationTypeFormSubmitted)  //bchitu Type is UIWebViewNavigationTypeOther for server redirects
    {
        if ([self isPaymentSuccess:request]) {
            PaymentSuccessViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentSuccess"];
            
            // save the order
            Order *order = [Order sharedOrder];
            viewController.order = order;
            
            // then remove all items from the original
            [order removeAllOrderItems];
            
            // then open success screen after poping all other screens
            UINavigationController *navigationController = self.navigationController;
            [navigationController popToRootViewControllerAnimated:NO];
            [navigationController pushViewController:viewController animated:YES];
            return NO;
        }
        
        if ([self isPaymentFailure:request]) {
            // open failure screen which allows to retry the payment process
            PaymentFailureViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentFailure"];
            [self.navigationController pushViewController:viewController animated:YES];
            return NO;
        }else{

        }
        
        
    }
    return YES;
}

- (BOOL)isPaymentSuccess:(NSURLRequest *)request {
    return [[[request URL] relativePath] rangeOfString:@"/payment/accept"].location != NSNotFound;
}

- (BOOL)isPaymentFailure:(NSURLRequest *)request {
    return [[[request URL] relativePath] rangeOfString:@"/payment/error"].location != NSNotFound;
}

@end
