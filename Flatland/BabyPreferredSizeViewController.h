//
//  BabyPreferredSizeViewController.h
//  Flatland
//
//  Created by Magdalena Kamrowska on 02.07.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Capsule.h"
#import "FlatViewController.h"

@class BabyPreferredSizeViewController;

@protocol BabyPreferredSizePickerDelegate <NSObject>

- (void)picker:(BabyPreferredSizeViewController*)picker didSelectPreferredSize:(NSString*)size;

@end

@interface BabyPreferredSizeViewController : FlatViewController

@property (nonatomic, weak) id<BabyPreferredSizePickerDelegate> delegate;
@property (nonatomic, retain) Capsule *capsule;

@end
