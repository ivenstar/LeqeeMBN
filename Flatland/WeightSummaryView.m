//
//  WeightSummaryView.m
//  Flatland
//
//  Created by Pirlitu Vasilica on 12/13/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "WeightSummaryView.h"
#import "Weight.h"

@implementation WeightSummaryView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}


+ (WeightSummaryView*) summaryView
{
    WeightSummaryView *view = [[[UINib nibWithNibName:@"WeightSummaryView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    return view;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.buttonSecondScreen setTitle:T(@"%default.buttonPrevious") forState:UIControlStateNormal];
    
}
-(void)setUpFirstScreen
{
    self.thirdScreen.hidden=YES;
    self.secondScreen.hidden=YES;
    self.firstScreen.hidden = NO;
    self.messageLabel.text=T(@"%defaultscreen.weight1");
    self.secondMessageLabel.text=T(@"%defaultscreen.weight2");
    self.secondMessageLabel.font=[UIFont systemFontOfSize:9];
    
}

-(void)setUpSecondScreen
{
    self.firstScreen.hidden=YES;
    self.thirdScreen.hidden=YES;
    self.secondScreen.hidden = NO;
    self.messageSecondScreen.text=T(@"%defaultscreen.weight3");
    self.messageSecondScreen.font=[UIFont systemFontOfSize:11];
    self.buttonSecondScreen.titleLabel.text=T(@"%default.buttonPrevious");
    [self.buttonSecondScreen setTitle:T(@"%default.buttonPrevious") forState:UIControlStateNormal];
}

-(void)setUpThirdScreen:(NSArray*)weights
{
    self.firstScreen.hidden=YES;
    self.secondScreen.hidden=YES;
    self.thirdScreen.hidden = NO;
    NSString *format = @"%.2f kg";
#ifdef BABY_NES_US
    format = @"%.2f lb";
#endif// BABY_NES_US
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 55, 55)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"balance.png"];
    [self.thirdScreen addSubview:imageView];
    
    UIColor *color = [UIColor colorWithRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha: 1];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, 160, 40)];
    timeLabel.textColor = color;
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.font = [UIFont fontWithName:@"Bariol-Regular" size:25.0];
    timeLabel.text = @"";
    timeLabel.text = [[NSString alloc] initWithFormat:format, ((Weight*)[weights objectAtIndex:0]).weight];
    [self.thirdScreen addSubview:timeLabel];
    
    //get date for latest weight
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:T(@"%general.dateFormat2")];
    
    NSString *date = [[NSString alloc] initWithFormat:@"%@", [dateFormatter stringFromDate:((Weight*)[weights objectAtIndex:0]).startDate]];
    //
    
    UILabel * labelTitleUp=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 20 )];
    labelTitleUp.text = [NSString stringWithFormat:T(@"%weightdataWidget.weightFrom"), date];
    
    labelTitleUp.font=[UIFont systemFontOfSize:12];
    [self.thirdScreen addSubview:labelTitleUp];
    
    UILabel * labelTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 70, 100, 20)];
    labelTitle.text=T(@"%weightdataWidget.prior");
    labelTitle.font=[UIFont systemFontOfSize:10];
    if ([weights count] > 1)
    [self.thirdScreen addSubview:labelTitle];
    
    int x=10;
    int y=90;
    int limit = ([weights count]-1) > 5 ? 5 : [weights count] -1;
    for (int i=0; i<limit; i++) {
        CGRect rect=CGRectMake(x, y, 60, 20);
        UILabel * labelDescription=[[UILabel alloc ]initWithFrame:rect];
        labelDescription.text=[[NSString alloc] initWithFormat:format, ((Weight*)[weights objectAtIndex:i+1]).weight];
        labelDescription.font=[UIFont systemFontOfSize:10];
        x+=60;
        [self.thirdScreen addSubview:labelDescription];
    }
    
    y+=15;
    x=10;
    for (int i=0; i<limit; i++) {
        CGRect rect=CGRectMake(x, y, 40, 20);
        UILabel * labelDescription=[[UILabel alloc ]initWithFrame:rect];
        NSString *date = [[NSString alloc] initWithFormat:@"%@", [dateFormatter stringFromDate:((Weight*)[weights objectAtIndex:i+1]).startDate]];
        labelDescription.text=date;
        labelDescription.font=[UIFont systemFontOfSize:10];
        x+=60;
        [self.thirdScreen addSubview:labelDescription];
    }
}

- (IBAction)goToPreviousFeed:(id)sender
{
    
}

@end
