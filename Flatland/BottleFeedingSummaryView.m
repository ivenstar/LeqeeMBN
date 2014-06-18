//
//  BottleFeedingSummaryView.m
//  Flatland
//
//  Created by Pirlitu Vasilica on 12/12/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "BottleFeedingSummaryView.h"

@implementation BottleFeedingSummaryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (BottleFeedingSummaryView*) summaryView
{
    BottleFeedingSummaryView *view = [[[UINib nibWithNibName:@"BottleFeedingSummaryView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    return view;
}

-(void)setUpFirstScreen
{
    self.thirdScreen.hidden=YES;
    self.secondScreen.hidden=YES;
    self.messageLabel.text=T(@"%defaultscreen.bottleMessageEmpty");
    self.secondMessageLabel.text=T(@"%defaultscreen.bottleMessageEmpty2");
    self.secondMessageLabel.font=[UIFont systemFontOfSize:9];
}

-(void)setUpThirdScreen
{
    self.firstScreen.hidden=YES;
    self.secondScreen.hidden=YES;
    self.thirdScreenMessage.text=T(@"%defaultscreen.bottleMessageEmpty3");
    self.viewPreviousButton.titleLabel.text=T(@"%default.buttonPrevious");
    [self.viewPreviousButton setTitle:T(@"%default.buttonPrevious") forState:UIControlStateNormal];
}

-(void)setUpSecondScreen
{
    self.firstScreen.hidden=YES;
    self.thirdScreen.hidden=YES;
}

@end
