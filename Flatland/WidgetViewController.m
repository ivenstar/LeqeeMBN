//
//  WidgetViewController.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 30.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WidgetViewController.h"
#import "WeightWidgetViewController.h"
#import "BottlefeedingWidgetViewController.h"
#import "BreastfeedingWidgetViewController.h"

@interface WidgetViewController ()

@property (strong, nonatomic) UIView *overlay;
@end

@implementation WidgetViewController {
    BOOL _isLoading;
}

+ (NSString *)widgetIdentifier {
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self icnhLocalizeView];
    [self.view changeSystemFontToApplicationFont];
    _isLoading = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWidget) name:@"UpdateWidgetNotification" object:nil];
    self.titleText.layer.shadowOpacity = 0.75f;
    self.titleText.layer.shadowRadius = 3.0f;
    self.titleText.layer.shadowColor = [UIColor blackColor].CGColor;
    self.titleText.layer.shadowOffset = CGSizeMake(1, 2);
}

- (void)showLoadingOverlay {
    if (_isLoading) {
        return;
    }
    self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 190)];
    self.overlay.backgroundColor = [UIColor colorWithRed:(255.0 / 255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha: 0.4];;
    UIActivityIndicatorView *_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    CGPoint center = self.overlay.center;
    _activityView.center = center;
    
    [_activityView startAnimating];
    [self.overlay addSubview:_activityView];
    [self.widgetView addSubview:self.overlay];
    _isLoading = YES;
}

- (void)hideLoadingOverlay
{
    if (self.overlay)
    {
        [self.overlay removeFromSuperview];
    }
    _isLoading = NO;
}

- (IBAction)share:(id)sender {
    //Share sheet method
    //    NSString *message = @"Babynes Test";
    //    UIImage *imageToShare = [UIImage imageNamed:@"wifi_bg_s2.png"];
    //
    //    NSArray *postItems = @[message, imageToShare];
    //
    //    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
    //                                            initWithActivityItems:postItems
    //                                            applicationActivities:nil];
    //
    //    [self presentViewController:activityVC animated:YES completion:nil];
    
    //Compose method
    //FB
    
    //    SLComposeViewController *fbVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    //
    //    [fbVC setInitialText:@"Babynes Test"];
    //    [fbVC addURL:[NSURL URLWithString:@"https://developers.facebook.com/ios"]];
    //    [fbVC addImage:[UIImage imageNamed:@"wifi_bg_s2.png"]];
    //
    //    [self presentViewController:fbVC animated:YES completion:nil];
    ShareVC *share = [[ShareVC alloc] initWithNibName:NSStringFromClass([ShareVC class]) bundle:nil];
    [self presentViewController:share animated:YES completion:nil];
    
}

- (void)updateWidget
{
    
}

-(void)viewPreviousFeeds
{
    if ([self isKindOfClass:[WeightWidgetViewController class]]) {
        
        [self.delegateHome pressedPreviousFeeds:0];
    }
    if ([self isKindOfClass:[BottlefeedingWidgetViewController class]]) {
        
        [self.delegateHome pressedPreviousFeeds:1];
    }
    if ([self isKindOfClass:[BreastfeedingWidgetViewController class]]) {
        
        [self.delegateHome pressedPreviousFeeds:2];
    }
}

@end
