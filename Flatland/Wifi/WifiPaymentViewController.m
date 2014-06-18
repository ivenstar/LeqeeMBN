//
//  WifiPaymentViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 19.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WifiPaymentViewController.h"
#import "WaitIndicator.h"
#import "User.h"
#import "AlertView.h"
#import "FlatButton.h"
#import "FlatCheckbox.h"
#import "RESTService.h"
#import "PaymentDataService.h"
#import "OverlaySaveView.h"


@interface WifiPaymentViewController () <UIWebViewDelegate>
{
    BOOL otherScenePushed; //bchitu: refactoring needed.this is a hack
}

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, copy) NSString *paymentURL;
@property (weak, nonatomic) IBOutlet FlatCheckbox *acceptCheck;
@property (weak, nonatomic) IBOutlet FlatButton *nextButton;
@property (nonatomic, retain) PaymentURLData *paymentData;
@property (nonatomic) BOOL isSecondRequest;
@property (nonatomic) BOOL isCRC;

@end

@implementation WifiPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_nextButton setEnabled:(self.wifiOption != 1)];
    if ([WaitIndicator waitOnView:self.view]) {
        [PaymentDataService getPaymentDataCompletion:^(PaymentURLData *paymentData) {
            if(paymentData) {
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
                tap.numberOfTapsRequired = 1;
                tap.delegate = self;
                
                [self.webView addGestureRecognizer:tap];
                
                _paymentURL = paymentData.cleanedURLstring;
                NSString *stringHttps = [paymentData.paymentURL.absoluteString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
                paymentData.paymentURL = [NSURL URLWithString:stringHttps];
                _paymentData = paymentData;
                [[NSURLCache sharedURLCache] removeAllCachedResponses];
                [self.webView loadRequest:[NSURLRequest requestWithURL:paymentData.paymentURL]];
            }
            else {
                [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
            }
            [self.view stopWaiting];
        }];
    }
    
    self.navigationItem.leftBarButtonItem = MakeImageBarButton(@"barbutton-back", self, @selector(goBack));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    otherScenePushed = NO;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if(_isCRC && [self.webView canGoBack]){
        [self.webView goBack];
        _isCRC = NO;
    }
    return NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    
//    NSString *urlA = [[url stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    if([url rangeOfString:@"babynes_payment/payment"].location != NSNotFound) {
            _isCRC = YES;
            [WaitIndicator waitOnView:self.view];
            return YES;
    }
    else
    {
        _isCRC = NO;
    }
    
    [WaitIndicator waitOnView:self.view];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view stopWaiting];
    
    NSLog(@"URL: %@",webView.request.URL.absoluteString);
    
    if ([webView.request.URL.absoluteString rangeOfString:@"babynes_payment/successPayment"].location != NSNotFound) {
        NSString *firstResult = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].innerHTML.search(\"success\");"];
        if(![firstResult isEqualToString:@"-1"]) {
            [OverlaySaveView showOverlayWithMessage:T(@"%general.added") afterDelay:2 performBlock:^{
                _isSecondRequest = NO;
                NSString *stringHttps = [_paymentData.paymentURL.absoluteString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
                _paymentData.paymentURL = [NSURL URLWithString:stringHttps];
                [self.webView loadRequest:[NSURLRequest requestWithURL:_paymentData.paymentURL]]; //???
                if (!otherScenePushed)
                {
                    otherScenePushed = YES;
                    [self performSegueWithIdentifier:@"configureStock" sender:self];
                }
            }];
        }
    }
}

#pragma mark - Actions
- (IBAction)performSequeIfValid {
    NSString *result = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('cardno')[0].value.search(\"XXXXXXXXXXXX\");"];
        if(([result isEqualToString:@"-1"])) {
            [[AlertView alertViewFromString:T(@"%wifi.payment.pleaseCheck") buttonClicked:nil] show];
        }
        else
        {
            if (!otherScenePushed)
            {
                otherScenePushed = YES;
                [self performSegueWithIdentifier:@"configureStock" sender:self];
            }
        }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WifiBaseViewController *vc = segue.destinationViewController;
    if([[[User activeUser] wifiOrderOption] isEqualToString:@"Automatic"]) {
        vc.wifiOption = 1;
    } else if([[[User activeUser] wifiOrderOption] isEqualToString:@"QuickOrder"]) {
        vc.wifiOption = 2;
    } else if([[[User activeUser] wifiOrderOption] isEqualToString:@"TrackerOnly"]) {
        vc.wifiOption = 3;
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
