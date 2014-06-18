//
//  PaymentCardViewController.m
//  Flatland
//
//  Created by Magdalena Kamrowska on 05.07.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "PaymentCardViewController.h"
#import "WaitIndicator.h"
#import "AlertView.h"
#import "PaymentDataService.h"
#import "OverlaySaveView.h"

@interface PaymentCardViewController ()

@property (nonatomic, copy) NSString *paymentURL;
@property (nonatomic, copy) PaymentURLData *paymentURLData;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) BOOL hasScrolledUp;
@property (nonatomic) BOOL isCRC;
@end

@implementation PaymentCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollDown) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollUp) name:UIKeyboardDidShowNotification object:nil];
    
    _webView.delegate = self;
    if ([WaitIndicator waitOnView:self.view]) {
        [PaymentDataService getPaymentDataCompletion:^(PaymentURLData *paymentData) {
            if(paymentData) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
                tap.numberOfTapsRequired = 1;
                tap.delegate = self;
                
                [self.webView addGestureRecognizer:tap];
                _paymentURL = paymentData.cleanedURLstring;
                //extra https check for security
                NSString *stringHttps = [paymentData.paymentURL.absoluteString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
                paymentData.paymentURL = [NSURL URLWithString:stringHttps];
                _paymentURLData = paymentData;
                NSURLRequest *request = [NSURLRequest requestWithURL:paymentData.paymentURL];
                [self.webView loadRequest:request];
            }
            else {
                [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
                [WaitIndicator waitOnView:self.view];
            }
            [self.view stopWaiting];
        }];
    }
    
    self.navigationItem.leftBarButtonItem = MakeImageBarButton(@"barbutton-back", self, @selector(goBack));
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if(_isCRC && [self.webView canGoBack]){
        [self.webView goBack];
        _isCRC = NO;
    }
    return NO;
}

- (void)backButtonDidPressed:(id)aResponder {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)viewWillAppear:(BOOL)animated {
    [self deleteRightBarButtonItem];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scrollUp {
    if(!_hasScrolledUp){
        [UIView animateWithDuration:0.2 animations:^{
            UIView *view = self.mainViewController.view;
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y - 75, view.frame.size.width, view.frame.size.height + 75)];
        }];
        _hasScrolledUp = YES;
    }
}

- (void)scrollDown {
    if(_hasScrolledUp){
            [UIView animateWithDuration:0.2 animations:^{
            UIView *view = self.mainViewController.view;
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y + 75, view.frame.size.width, view.frame.size.height - 75)];
        }];
        _hasScrolledUp = NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view stopWaiting];
    
    if ([webView.request.URL.absoluteString rangeOfString:@"babynes_payment/successPayment"].location != NSNotFound) {
        NSString *firstResult = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].innerHTML.search(\"success\");"];
        if(![firstResult isEqualToString:@"-1"]) {
            NSString *stringHttps = [_paymentURLData.paymentURL.absoluteString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
            _paymentURLData.paymentURL = [NSURL URLWithString:stringHttps];
            [self.webView loadRequest:[NSURLRequest requestWithURL:_paymentURLData.paymentURL]];
            [OverlaySaveView showOverlayWithMessage:T(@"%general.added") afterDelay:2 performBlock:^{

            }];
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    
    NSString *urlA = [[url stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    if([urlA rangeOfString:_paymentURL].location == NSNotFound && [url rangeOfString:@"alias_gateway.asp"].location == NSNotFound && [url rangeOfString:@"wizard"].location == NSNotFound) {
        
        if([url rangeOfString:@"babynes_payment/payment"].location != NSNotFound){
            _isCRC = YES;
            [WaitIndicator waitOnView:self.view];
            return YES;
        }
        else
        {
            _isCRC = NO;
        }
//        [self.view stopWaiting];
//        [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
//        return NO;
    }
    [WaitIndicator waitOnView:self.view];
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.view stopWaiting];
    //[[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
}

- (void)keyboardWillShow:(NSNotification *)note {
    [self performSelector:@selector(removeBar) withObject:nil afterDelay:0];
}

- (void)removeBar {
    // Locate non-UIWindow.
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if (![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    // Locate UIWebFormView.
    //extra security dereference check
    if (keyboardWindow != nil)
        if ([[keyboardWindow subviews] count] != 0)
            for (UIView *possibleFormView in [keyboardWindow subviews]) {
                // iOS 5 sticks the UIWebFormView inside a UIPeripheralHostView.
                if ([[possibleFormView description] rangeOfString:@"UIPeripheralHostView"].location != NSNotFound) {
                    for (UIView *subviewWhichIsPossibleFormView in [possibleFormView subviews]) {
                        if ([[subviewWhichIsPossibleFormView description] rangeOfString:@"UIWebFormAccessory"].location != NSNotFound) {
                    [subviewWhichIsPossibleFormView removeFromSuperview];
                }
            }
        }
    }
}

// required by the graphical back button
- (IBAction)goBack {
    if(!_isCRC){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        _isCRC = NO;
        [self.webView goBack];
    }
}

@end
