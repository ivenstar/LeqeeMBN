////
////  EditPaymentCardViewController.m
////  Flatland
////
////  Created by Stefan Aust on 27.05.13.
////  Copyright (c) 2013 Proximity Technologies. All rights reserved.
////
//
//#import "EditPaymentCardViewController.h"
//#import "WaitIndicator.h"
//
//@interface EditPaymentCardViewController () <UIWebViewDelegate>
//
//@property (nonatomic, weak) IBOutlet UIWebView *webView;
//
//@end
//
//#pragma mark
//
//@implementation EditPaymentCardViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [WaitIndicator waitOnView:self.view];
//    
//    NSURL *URL = [NSURL URLWithString:[GetServiceURL() stringByAppendingString:@"/paymentcard.html"]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
//}
//
//#pragma mark - Web view delegate
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [self.view stopWaiting];
//    [self showError:error];
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [self.view stopWaiting];
//}
//
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    // we look for magic URLs and allow all other navigation
//    if (navigationType == UIWebViewNavigationTypeFormSubmitted) {
//        if ([self isPaymentSuccess:request]) {
//            [self dismissWithMessage:T(@"%general.add")];
//            
//            return NO;
//        }
//        
//        if ([self isPaymentFailure:request]) {
//            [self dismiss];
//            
//            return NO;
//        }
//    }
//    return YES;
//}
//
//- (BOOL)isPaymentSuccess:(NSURLRequest *)request {
//    return [[[request URL] relativePath] rangeOfString:@"ConfirmationDeCommande.aspx"].location != NSNotFound;
//}
//
//- (BOOL)isPaymentFailure:(NSURLRequest *)request {
//    return [[[request URL] relativePath] rangeOfString:@"OrderError.aspx"].location != NSNotFound;
//}
//
//@end
