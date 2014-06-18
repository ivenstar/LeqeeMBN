//
//  WaitIndicator.h
//  BabyNes
//
//  Created by Stefan Matthias Aust on 28.06.11.
//  Copyright 2011 Proximity GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WaitIndicator : UIView

+ (WaitIndicator *)waitIndicator;

+ (BOOL)waitOnView:(UIView *)view;

@end


@interface UIView (WaitIndicator)

- (void)stopWaiting;

@end