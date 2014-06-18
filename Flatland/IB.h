//
//  IB.h
//  Flatland
//
//  Created by Stefan Matthias Aust on 19.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IBMode) {
    IBModeManual = 0,
    IBModeLeft = 1,
    IBModeRight = 2,
    IBModeCenter = 3,
    IBModeFill = 4
};

// an interface builder
@interface IB : NSObject

- (id)initWithView:(UIView *)view;

- (void)define:(NSString *)name as:(NSDictionary *)definition;
- (void)defineKind:(NSString *)name as:(NSDictionary *)definition;

- (void)gap:(CGFloat)gap;
- (void)padding:(NSString *)padding;
- (void)mode:(IBMode)mode;
- (void)add:(UIView *)view;
- (void)add:(UIView *)view at:(NSString *)position;
- (void)addGap:(CGFloat)gap;

- (UIView *)view;

- (void)sizeToFit;
- (void)pack;

#pragma mark - factory methods

- (UIView *)heading:(NSString *)text;
- (UIView *)paragraph:(NSString *)text;

- (UILabel *)label:(NSString *)text with:(NSDictionary *)definition;

- (UIImageView *)image:(NSString *)name;

- (UIButton *)button:(NSString *)name;
- (UIButton *)button:(NSString *)name with:(NSDictionary *)definition;

@end
