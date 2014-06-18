//
//  FlatViewController.m
//  Flatland
//
//  Created by Stefan Aust on 14.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"
#import "AlertView.h"
#import "OverlaySaveView.h"

@interface FlatViewController ()

@end

@implementation FlatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // apply the custom font to all labels (something that cannot be done via IB)
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    [self icnhLocalizeView];
    [self.view changeSystemFontToApplicationFont];
    
    // add a graphical back button
    if ([self.navigationController.viewControllers count] > 1 && !self.navigationItem.hidesBackButton) {
        self.navigationItem.leftBarButtonItem = MakeImageBarButton(@"barbutton-back", self, @selector(goBack));
    } else {
        UIBarButtonItem *item = self.navigationItem.leftBarButtonItem;
        if (item.target == self && item.action == @selector(dismiss)) {
            self.navigationItem.leftBarButtonItem = MakeImageBarButton(@"barbutton-cancel", item.target, item.action);
        }
        item = self.navigationItem.rightBarButtonItem;
        if (item.target == self && item.action == @selector(save)) {
            self.navigationItem.rightBarButtonItem = MakeImageBarButton(@"barbutton-done", item.target, item.action);
        }
    }
    
    if (self.formContainer) {
        UITapGestureRecognizer *r = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        [self.formContainer addGestureRecognizer:r];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.formScrollView) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(shrinkFormScrollView:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(growFormScrollView:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        CGRect frame = self.formContainer.bounds;
        CGFloat height = self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height;
        if (frame.size.height < height) {
            frame.size.height = height;
        }
        self.formContainer.frame = frame;
        self.formScrollView.contentSize = frame.size;
    }
    
    [self fitTitle];
    
#ifdef DEBUG_LOG_SHOW_VC_CLASS_NAME
    NSLog(@"VIEW WILL APPEAR: Controller: %@",[[self class] description]);
#endif
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.formScrollView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}


#pragma mark - Actions

// required by the graphical back button
- (IBAction)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

// useful for modal dialogs
- (IBAction)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Autorotation

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - Shrinking & growing the scroll view

- (void)shrinkFormScrollView:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    
    CGSize size = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, size.height, 0);
    
    self.formScrollView.contentInset = insets;
    self.formScrollView.scrollIndicatorInsets = insets;
    
    // make sure that the active text field / text view is visible
    UIView *firstResponder = [UIView enumerateAllSubviewsOf:self.formContainer UsingBlock:^BOOL(UIView *view)
    {
        return [view isFirstResponder];
    }];
    
    if(firstResponder != nil)
    {
        CGRect viewFrame = [firstResponder.superview convertRect:firstResponder.frame toView:self.formScrollView];
        [self.formScrollView scrollRectToVisible:CGRectInset(viewFrame, -5, -5) animated:YES];
    }
}

- (void)growFormScrollView:(NSNotification *)notification {
    if (IS_IOS7)
    {
        if(!self.navigationController.isNavigationBarHidden)
        {
            self.formScrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }
    }
    else
    {
        self.formScrollView.contentInset = UIEdgeInsetsZero;
    }
    self.formScrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)hideKeyboard {
    for (UIView *view in self.formContainer.subviews) {
        [view resignFirstResponder];
    }
}

- (UIScrollView *)formScrollView {
    return [self.view isKindOfClass:[UIScrollView class]] ? (UIScrollView *)self.view : nil;
}

- (UIView *)formContainer {
    return [self.formScrollView.subviews objectAtIndex:0];
}

#pragma mark - Errors

- (void)showError:(NSError *)error {
    [[AlertView alertViewWithTitle:[NSString stringWithFormat:@"%d", [error code]]
                           message:[error localizedDescription]
                      buttonTitles:@[@"OK"]
                     buttonClicked:nil] show];
}

- (void)notYetImplementedError {
    [[AlertView alertViewFromString:@"|Not yet implemented!|OK" buttonClicked:nil] show];
}

#pragma mark - Utilities

- (void)dismissWithMessage:(NSString *)message {
    [OverlaySaveView showOverlayWithMessage:message afterDelay:1 performBlock:^{
        [self dismiss];
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
