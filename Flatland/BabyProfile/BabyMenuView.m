//
//  BabyMenuView.m
//  Flatland
//
//  Created by Sergiu Gaina on 18/02/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "BabyMenuView.h"
#import "User.h"
#import "BabyMenuViewController.h"
#import "WaitIndicator.h"



@implementation BabyMenuView


- (void) setBabyProfileViews:(NSMutableArray *)babyProfileViews
{
    
    if (self.babyProfileViews != babyProfileViews)//TODO check the arrys for difs
    {
     
        _babyProfileViews = babyProfileViews;
        self.pageControl.numberOfPages = [self numberOfItemsInSwipeView:self.swipeView];
        
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self awakeFromNib];
        
    }
    
     return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    
    _isLoading = NO;
    
    self.pageControl.hidesForSinglePage = YES;
}

-(void) resetPageControl
{
    self.pageControl.currentPage = 0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - Actions



- (void)showLoadingOverlay
{
    if (_isLoading)
        return;
    
    self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 190)];
    self.overlay.backgroundColor = [UIColor colorWithRed:(255.0 / 255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha: 0.4];;
    UIActivityIndicatorView *_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    CGPoint center = self.overlay.center;
    center.x -=20;
    _activityView.center = center;
    
    [_activityView startAnimating];
    [self.overlay addSubview:_activityView];
    [self addSubview:self.overlay];
    _isLoading = YES;
}

- (void)hideLoadingOverlay
{
    if (self.overlay)
    {
        [self.overlay removeFromSuperview];
    }
    
    _isLoading = NO;
}


#pragma mark - SwipeViewDataSource
-(UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    _index = index;

    if ( nil != self.babyProfileViews && 0 != [self.babyProfileViews count] && index <= [self.babyProfileViews count]/2)
    {
        
        UIView *babyContainerView = [[UIView alloc] initWithFrame:self.swipeView.frame];
        
        
        BabyMenuViewController * firstBabyViewController = (BabyMenuViewController *)[self.babyProfileViews objectAtIndex:index*2];
        
        BabyMenuViewContainer *firstbabyview = (BabyMenuViewContainer*)firstBabyViewController.view;
        
        CGRect frame = firstbabyview.frame;
        
        //Move the button to the left
        CGRect btnFrame = firstbabyview.editButton.frame;
        btnFrame.origin.x = 0;
        firstbabyview.editButton.frame = btnFrame;
        [firstbabyview.editButton setBackgroundImage:[UIImage imageNamed:@"button-edit-left.png"]  forState:UIControlStateNormal];
        
        //Move the text view to the right
        CGRect txtFrame = firstbabyview.textView.frame;
        txtFrame.origin.x = frame.size.width - txtFrame.size.width;
        firstbabyview.textView.frame = txtFrame;
        
        //Move the image to the right
        CGRect imageFrame = firstbabyview.imageView.frame;
        imageFrame.origin.x = frame.size.width - imageFrame.size.width;
        firstbabyview.imageView.frame = imageFrame;

        
        
        
        CGRect firstbabyframe = firstbabyview.frame;
        firstbabyframe.origin.x = 10;
        firstbabyframe.origin.y = 15;
        firstbabyview.frame = firstbabyframe;
        [babyContainerView addSubview:firstbabyview];
        
        
        if ((index)*2 +1 < [self.babyProfileViews count])
        {
            BabyMenuViewController * secondBabyViewController = (BabyMenuViewController *)[self.babyProfileViews objectAtIndex:index*2 +1];
            
            BabyMenuViewContainer *secondbabyview = (BabyMenuViewContainer *) secondBabyViewController.view;
        
            
            CGRect frame = firstbabyview.frame;
            
            //Move the button to the right
            CGRect btnFrame = secondbabyview.editButton.frame;
            btnFrame.origin.x = frame.size.width - btnFrame.size.width;
            secondbabyview.editButton.frame = btnFrame;
            [secondbabyview.editButton setBackgroundImage:[UIImage imageNamed:@"button-edit-right.png"]  forState:UIControlStateNormal];
            
            //Move the text view to the left
            CGRect txtFrame = secondbabyview.textView.frame;
            txtFrame.origin.x = 0;
            secondbabyview.textView.frame = txtFrame;

            //Move the image to the left
            CGRect imageFrame = secondbabyview.imageView.frame;
            imageFrame.origin.x = 0;
            secondbabyview.imageView.frame = imageFrame;

            
            
            
            CGRect secondbabyframe = secondbabyview.frame;
            secondbabyframe.origin.x = 135;
            secondbabyframe.origin.y = 15;
            secondbabyview.frame = secondbabyframe;
            [babyContainerView addSubview:secondbabyview];
        }
        
    
        return babyContainerView;
    }
    
    return nil;
}

-(NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    
    self.pageControl.numberOfPages = [self.babyProfileViews count]/2 + [self.babyProfileViews count] %2;
 
    
    return ([self.babyProfileViews count]/2 + [self.babyProfileViews count] %2);
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
        self.pageControl.currentPage = _index;
}



@end






























