//
//  Localization.m
//  DolceGusto
//
//  Created by Stefan Matthias Aust on 21.08.12.
//  Copyright (c) 2012 I.C.N.H GmbH. All rights reserved.
//

#import "Localization.h"

// return the localized string for the given key
NSString *T(NSString *key) {
    return NSLocalizedString(key, nil);
}

NSString *AutoLocalize(NSString *text) {
    if ([text hasPrefix:@"%"]) {
        text = T(text);
    }
    return text;
}


@implementation UIViewController (ICNH)

- (void)icnhLocalizeView {
    if (self.navigationItem) {
        self.navigationItem.title = AutoLocalize(self.navigationItem.title);
        if (self.navigationItem.backBarButtonItem) {
            self.navigationItem.backBarButtonItem.title = AutoLocalize(self.navigationItem.backBarButtonItem.title);
        }
        for (UIBarButtonItem *item in self.navigationItem.leftBarButtonItems) {
            item.title = AutoLocalize(item.title);
        }
        for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
            item.title = AutoLocalize(item.title);
        }
    }
    if (self.tabBarItem) {
        self.tabBarItem.title = AutoLocalize(self.tabBarItem.title);
    }
    [self.view icnhLocalizeView];
}

@end


@implementation UIView (ICNH)

- (void)icnhLocalizeView {
    [self icnhLocalizeSubviews];
}

- (void)icnhLocalizeSubviews {
    for (UIView *subview in self.subviews) {
        [subview icnhLocalizeView];
    }
}

@end


@implementation UILabel (ICNH)

- (void)icnhLocalizeView {
    [super icnhLocalizeView];
    self.text = AutoLocalize(self.text);
}

@end


@implementation UIButton (ICNH)

- (void)icnhLocalizeView {
    [super icnhLocalizeView];
    [self setTitle:AutoLocalize([self titleForState:UIControlStateNormal]) forState:UIControlStateNormal];
    [self setTitle:AutoLocalize([self titleForState:UIControlStateHighlighted]) forState:UIControlStateHighlighted];
}

@end


@implementation UITabBar (ICNH)

- (void)icnhLocalizeView {
    for (UITabBarItem *item in self.items) {
        item.title = AutoLocalize(item.title);
    }
}

@end

@implementation UITextField (ICNH)

- (void)icnhLocalizeView {
    [super icnhLocalizeView];
    self.placeholder = AutoLocalize(self.placeholder);
}

@end


@implementation UINavigationBar (ICNH)

@end