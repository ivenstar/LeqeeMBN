//
//  ScaleDisk.m
//  Flatland
//
//  Created by Jochen Block on 26.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "ScaleDisk.h"
#import <QuartzCore/QuartzCore.h>
#import "Section.h"

@interface ScaleDisk()
- (void) drawScale;
- (float) calculateDistanceFromCenter:(CGPoint)point;
- (void) buildSectionsEven;
- (void) buildSectionsOdd;
- (UIImageView *) getSectionByValue:(int)value;
- (NSString *) getSection:(int)position;
@end

static float deltaAngle;
static float minAlphavalue = 0.6;
static float maxAlphavalue = 1.0;
static float radianDegreeValue = 0.0174532925;

@implementation ScaleDisk

@synthesize delegate, container, numberOfSections, startTransform, sections, currentValue, scale;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber {
    
    if ((self = [super initWithFrame:frame])) {
        [self icnhLocalizeView];
        self.currentValue = 0;
        self.numberOfSections = sectionsNumber;
        self.delegate = del;
		[self drawScale];
        
	}
    return self;
}

- (void) drawScale {
    
    container = [[UIView alloc] initWithFrame:self.frame];
    
    CGFloat angleSize = 2*M_PI/numberOfSections;
    
    for (int i = 0; i < numberOfSections; i++) {
        
        UIImageView *im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segment.png"]];
        
        im.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        im.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x,
                                        container.bounds.size.height/2.0-container.frame.origin.y);
        im.transform = CGAffineTransformMakeRotation(angleSize*i);
        im.alpha = minAlphavalue;
        im.tag = i;
        
        if (i == 0) {
            im.alpha = maxAlphavalue;
        }
        
        [container addSubview:im];
        
    }
    
    container.userInteractionEnabled = NO;
    [self addSubview:container];
    
    sections = [NSMutableArray arrayWithCapacity:numberOfSections];
    
    scale = [[UIImageView alloc] initWithFrame:CGRectMake(0, 350, 707, 707)];
    scale.image =[UIImage imageNamed:@"babynes_poids.png"] ;
    scale.center = self.center;
    scale.center = CGPointMake(scale.center.x, scale.center.y+3);
    [self addSubview:scale];
    
    if (numberOfSections % 2 == 0) {
        
        [self buildSectionsEven];
        
    } else {
        
        [self buildSectionsOdd];
        
    }
    
    [self.delegate scaleDidChangeValue:[self getSection:currentValue]];
    
}

- (void)moveScaleToWeight:(float)weight {
    
    int value = (int)(weight * 10 + 0.5);
	double newWeight = (double)(value)/10;
    
        float trans = ( (newWeight) *2  *9) * radianDegreeValue;
        int section = (newWeight*20+20);
        [self.delegate scaleDidChangeValue:[self getSection:(section/2)-10]];
        startTransform = scale.transform;
        scale.transform = CGAffineTransformRotate(startTransform, -trans);
}

- (UIImageView *) getSectionByValue:(int)value {
    
    UIImageView *res;
    
    NSArray *views = [container subviews];
    
    for (UIImageView *im in views) {
        
        if (im.tag == value)
            res = im;
        
    }
    
    return res;
    
}

- (void) buildSectionsEven {
    
    CGFloat circleWidth = M_PI*2/numberOfSections;
    CGFloat mid = 0;
    
    for (int i = 0; i < numberOfSections; i++) {
        
        Section *section = [[Section alloc] init];
        section.midValue = mid;
        section.minValue = mid - (circleWidth/2);
        section.maxValue = mid + (circleWidth/2);
        section.value = i;
        
        
        if (section.maxValue-circleWidth < - M_PI) {
            
            mid = M_PI;
            section.midValue = mid;
            section.minValue = fabsf(section.maxValue);
            
        }
        
        mid -= circleWidth;
        
        [sections addObject:section];
    }
}

- (void) buildSectionsOdd {
    
    CGFloat circleWidth = M_PI*2/numberOfSections;
    CGFloat mid = 0;
    
    for (int i = 0; i < numberOfSections; i++) {
        
        Section *section = [[Section alloc] init];
        section.midValue = mid;
        section.minValue = mid - (circleWidth/2);
        section.maxValue = mid + (circleWidth/2);
        section.value = i;
        
        mid -= circleWidth;
        
        if (section.minValue < - M_PI) {
            
            mid = -mid;
            mid -= circleWidth;
            
        }
        
        
        [sections addObject:section];
    }
}

- (float) calculateDistanceFromCenter:(CGPoint)point {
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
	float dx = point.x - center.x;
	float dy = point.y - center.y;
	return sqrt(dx*dx + dy*dy);
    
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:self];
    float dist = [self calculateDistanceFromCenter:touchPoint];
    
    if (dist < 40 || dist > 200)
    {
        return NO;
    }
    
	float dx = touchPoint.x - scale.center.x;
	float dy = touchPoint.y - scale.center.y;
	deltaAngle = atan2(dy,dx);
    
    startTransform = scale.transform;
    
    UIImageView *im = [self getSectionByValue:currentValue];
    im.alpha = minAlphavalue;
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    
	CGPoint pt = [touch locationInView:self];
    
    float dist = [self calculateDistanceFromCenter:pt];
    
    if (dist < 40 || dist > 100)
    {
        //NSLog(@"drag path too close to the center (%f,%f)", pt.x, pt.y);
    }
    
    
    CGFloat radians = atan2f(scale.transform.b, scale.transform.a);
    
    for (Section *c in sections) {
        
        
        
        if (c.minValue > 0 && c.maxValue < 0) {
            if (c.maxValue > radians || c.minValue < radians) {
                currentValue = c.value;
            }
        }
        
        else if (radians > c.minValue && radians < c.maxValue) {
            currentValue = c.value;
        }
        
    }
    
    [self.delegate scaleDidChangeValue:[self getSection:currentValue]];
    
    float dx = pt.x  - container.center.x;
    float dy = pt.y  - container.center.y;
    float ang = atan2(dy,dx);
    float angleDifference = deltaAngle - ang;
    scale.transform = CGAffineTransformRotate(startTransform, -angleDifference);

    return YES;
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    CGFloat radians = atan2f(scale.transform.b, scale.transform.a);
    
    CGFloat newVal = 0.0;
    
    for (Section *c in sections) {
        
        if (c.minValue > 0 && c.maxValue < 0) {
            
            if (c.maxValue > radians || c.minValue < radians) {
                
                if (radians > 0) {
                    
                    newVal = radians - M_PI;
                    
                } else {
                    
                    newVal = M_PI + radians;
                    
                }
                currentValue = c.value;
                
            }
            
        }
        
        else if (radians > c.minValue && radians < c.maxValue) {
            
            newVal = radians - c.midValue;
            currentValue = c.value;
            
        }
        
    }
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    //-0.00576192
    CGAffineTransform t = CGAffineTransformRotate(scale.transform, -newVal);
    self.scale.transform = t;
    
    
    [UIView commitAnimations];
    
    [self.delegate scaleDidChangeValue:[self getSection:currentValue]];
    
    UIImageView *im = [self getSectionByValue:currentValue];
    im.alpha = maxAlphavalue;
}

- (NSString *) getSection:(int)position {
    
    int initWeight = 0;
    int result = 0;
    int offset = 100;
    
    result = initWeight + (offset * position);
    
    NSString *res = [[NSString alloc] initWithFormat:@"%d", result];
    
    return res;
}

@end

