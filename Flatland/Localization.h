//
//  Localization.h
//  DolceGusto
//
//  Created by Stefan Matthias Aust on 21.08.12.
//  Copyright (c) 2012 I.C.N.H GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

// return the localized string for the given key
extern NSString *T(NSString *key);

// return a localized string if the given string starts with "%"; otherwise return unchanged
extern NSString *AutoLocalize(NSString *string);


@interface UIViewController (ICNH)

- (void)icnhLocalizeView;

@end


@interface UIView (ICNH)

- (void)icnhLocalizeView;
- (void)icnhLocalizeSubviews;

@end
