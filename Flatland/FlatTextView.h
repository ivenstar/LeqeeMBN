//
//  FlatTextView.h
//  Flatland
//
//  Created by Stefan Aust on 14.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Provides a flat multiline text area with a rounded border and a placeholder text.
 */
@interface FlatTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;

@end
