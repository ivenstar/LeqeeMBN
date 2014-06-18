//
//  BabyNesSlider.m
//  Flatland
//
//  Created by Bogdan Chitu on 06/02/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "BabyNesSlider.h"

#define BABYNES_SLIDER_DEFAULT_STEPS 4
#define BABYNES_SLIDER_MIN_VALUE 1.0f/BABYNES_SLIDER_DEFAULT_STEPS

@interface BabyNesSlider()
{
    int _nSteps;
    UIImageView* thumb;
}

@end

@implementation BabyNesSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setMultipleTouchEnabled:NO];
        [self setClipsToBounds:NO];
        
        _nSteps = BABYNES_SLIDER_DEFAULT_STEPS;
        _value = 1.0f/_nSteps;
        
        thumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addbtl_btl_updwn_btn"]];
        [self addSubview:thumb];
        
        [thumb setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height * (1 - _value))];
     
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

- (void) setValue:(float)newValue
{
    if (newValue < BABYNES_SLIDER_MIN_VALUE)
    {
        newValue = BABYNES_SLIDER_MIN_VALUE;
    }
    else
    {
        if (newValue > 1)
        {
            newValue = 1;
        }
    }
    
    if (newValue != _value)
    {
        _value = newValue;
        [thumb setCenter:CGPointMake(thumb.center.x, self.frame.size.height * (1 - _value))];
        
        if (nil != _delegate)
        {
            [_delegate sliderValueChanged:_value];
        }
    }
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint locationInView = [touch locationInView:self];
    
    [self calculateNewValueWithLocation:locationInView];
}

 - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint locationInView = [touch locationInView:self];
    
    [self calculateNewValueWithLocation:locationInView];
}

- (void) calculateNewValueWithLocation : (CGPoint) locationInView
{
    float _newConsideredPercent = 1 - (locationInView.y / self.frame.size.height);
    
    if (_newConsideredPercent > 1) //clamp the value
    {
        return;
    }
    
    float stepSize = 1.0f/_nSteps;
    int lowerStep = _newConsideredPercent/stepSize;
    float newValue;
    
    if (ABS(_newConsideredPercent - (lowerStep*stepSize)) <= stepSize/2)
    {
        newValue = lowerStep * stepSize;
    }
    else
    {
        newValue = (lowerStep + 1) * stepSize;
    }
    
    //try to set the new value
    self.value = newValue;

}

@end
