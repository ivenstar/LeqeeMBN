//
//  ScaleDisk.h
//  Flatland
//
//  Created by Jochen Block on 26.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleViewController.h"

@interface ScaleDisk : UIControl

@property (weak) id <ScaleProtocol> delegate;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *scale;
@property int numberOfSections;
@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *sections;
@property int currentValue;


- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber;
- (void)moveScaleToWeight:(float)weight;
@end
