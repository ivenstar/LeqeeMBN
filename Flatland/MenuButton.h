//
//  MenuButton.h
//  Flatland
//
//  Created by Stefan Matthias Aust on 20.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuButton : UIButton

@property (nonatomic, assign) BOOL showArrow;

- (void) setSeparatorHidden:(BOOL)hidden;
- (void) setArrowImage:(UIImage *)image withSize:(CGSize) imageSize;

@end
