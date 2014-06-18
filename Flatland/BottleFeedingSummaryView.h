//
//  BottleFeedingSummaryView.h
//  Flatland
//
//  Created by Pirlitu Vasilica on 12/12/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottleFeedingSummaryView : UIView

+ (BottleFeedingSummaryView*) summaryView ;
@property (weak, nonatomic) IBOutlet UIView *firstScreen;
@property (weak, nonatomic) IBOutlet UIView *secondScreen;
@property (weak, nonatomic) IBOutlet UIView *thirdScreen;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdScreenMessage;
@property (weak, nonatomic) IBOutlet UIButton *viewPreviousButton;
-(void)setUpThirdScreen;
-(void)setUpFirstScreen;
-(void)setUpSecondScreen;

@end
