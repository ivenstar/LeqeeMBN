//
//  CartModifyViewControllerDelegate.h
//  Flatland
//
//  Created by Stefan Matthias Aust on 25.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CartModifyViewControllerDelegate <NSObject>

- (void)quantityChangedTo:(NSUInteger)quantity;

@end
