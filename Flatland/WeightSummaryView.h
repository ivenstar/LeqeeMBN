//
//  WeightSummaryView.h
//  Flatland
//
//  Created by Pirlitu Vasilica on 12/13/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeightSummaryView : UIView

+ (WeightSummaryView*) summaryView ;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageSecondScreen;
@property (weak, nonatomic) IBOutlet UIButton *buttonSecondScreen;
@property (weak, nonatomic) IBOutlet UIView *firstScreen;
@property (weak, nonatomic) IBOutlet UIView *secondScreen;
@property (weak, nonatomic) IBOutlet UIView *thirdScreen;

-(void)setUpFirstScreen;
-(void)setUpSecondScreen;
-(void)setUpThirdScreen:(NSArray*)weights;

@end
