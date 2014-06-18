//
//  TimelineSharingView.m
//  Flatland
//
//  Created by Bogdan Chitu on 06/05/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineSharingView.h"

#import "TimelineEntryJournal.h"
#import "TimelineEntryMood.h"
#import "TimelineEntryPhoto.h"
#import "TimelineEntryBirthDay.h"
#import "TimelineEntryFeeding.h"
#import "TimelineEntryWeight.h"

#import "Baby.h"
#import "User.h"

#import "Specific.h"

#import <Social/Social.h>

@implementation TimelineSharingView

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL returnVal = [super pointInside:point withEvent:event];
    
    if (!returnVal)
    {
        [self removeFromSuperview];
    }
        
    return returnVal;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return [super hitTest:point withEvent:event];
    
}

//- (void)didMoveToSuperview
//{
//    //remove gr from old super views
//    for(UIGestureRecognizer *r in self.recognizers)
//    {
//        [r.view removeGestureRecognizer:r];
//    }
//    
//    //add grs to new ones
//    UIView *view = self.superview;
//    while (view != nil)
//    {
//        UITapGestureRecognizer *r = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
//        [view addGestureRecognizer:r];
//        [self.recognizers addObject:r];
//    }
//    
//    [super didMoveToSuperview];
//}

- (IBAction)doShareFacebook:(id)sender
{
    if (self.timelineEntry == nil)
    {
        NSLog(@"Not posting -> no entry");
        [self removeFromSuperview];
        return;
    }
    
    NSString* initialText = nil;
    UIImage* imageForPost = nil;
    
    if ([self.timelineEntry isKindOfClass:[TimelineEntryPhoto class]])
    {
        if (self.timelineEntry.title != nil)
        {
            initialText = self.timelineEntry.title;
        }
        else
        {
          initialText = @"";
        };
        
        initialText = [NSString stringWithFormat:@"%@\n%@",initialText,[((TimelineEntryPhoto*) self.timelineEntry) comment]];
        imageForPost = [((TimelineEntryPhoto*) self.timelineEntry) image];
    }
    if ([self.timelineEntry isKindOfClass:[TimelineEntryJournal class]])
    {
        if (self.timelineEntry.title != nil)
        {
            initialText = self.timelineEntry.title;
        }
        else
        {
            initialText = @"";
        };
        
        initialText = [NSString stringWithFormat:@"%@\n%@",initialText,[((TimelineEntryJournal*) self.timelineEntry) comment]];
    }
    else if ([self.timelineEntry isKindOfClass:[TimelineEntryJournal class]])
    {
        initialText = [((TimelineEntryJournal*) self.timelineEntry) comment];
    }
    else
    {
        initialText = (self.timelineEntry.title);
    }
    
    if (imageForPost == nil)
    {
        imageForPost = [[[User activeUser] favouriteBaby] cachedImage];
        if (imageForPost == nil)
        {
            imageForPost = [[[User activeUser] favouriteBaby] picture];
        }
        //if still nill..use the default image
        if (imageForPost == nil)
        {
            imageForPost = [UIImage imageNamed:@"picture-baby-default"];
        }
    }
    
    SLComposeViewController *slVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [slVC setInitialText:initialText];
    [slVC addImage:imageForPost];
    [slVC addURL:[NSURL URLWithString:kFacebookTwitterLink]];
    
    //completion handling
    [slVC setCompletionHandler:^(SLComposeViewControllerResult result) {
        
        switch (result)
        {
            case SLComposeViewControllerResultDone:
            {
                [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                
            }
                break;
                
            default:
                break;
        }
    }];
    
    [self.window.rootViewController presentViewController:slVC animated:YES completion:nil];
    [self removeFromSuperview];

}

- (IBAction)doShareTwitter:(id)sender
{
    if (self.timelineEntry == nil)
    {
        NSLog(@"Not posting -> no entry");
        [self removeFromSuperview];
        return;
    }
    
    NSString* initialText = nil;
    UIImage* imageForPost = nil;
    
    if ([self.timelineEntry isKindOfClass:[TimelineEntryPhoto class]])
    {
        initialText = [((TimelineEntryPhoto*) self.timelineEntry) comment];
        imageForPost = [((TimelineEntryPhoto*) self.timelineEntry) image];
    }
    else if ([self.timelineEntry isKindOfClass:[TimelineEntryJournal class]])
    {
        initialText = [((TimelineEntryJournal*) self.timelineEntry) comment];
    }
    else
    {
        initialText = (self.timelineEntry.title);
    }
    
    if (imageForPost == nil)
    {
        imageForPost = [[[User activeUser] favouriteBaby] cachedImage];
        if (imageForPost == nil)
        {
            imageForPost = [[[User activeUser] favouriteBaby] picture];
        }
        //if still nill..use the default image
        if (imageForPost == nil)
        {
            imageForPost = [UIImage imageNamed:@"picture-baby-default"];
        }
    }
    
    SLComposeViewController *slVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [slVC setInitialText:initialText];
    [slVC addImage:imageForPost];
    [slVC addURL:[NSURL URLWithString:kFacebookTwitterLink]];
    
    //completion handling
    [slVC setCompletionHandler:^(SLComposeViewControllerResult result) {
        
        switch (result)
        {
            case SLComposeViewControllerResultDone:
            {
                [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                
            }
                break;
                
            default:
                break;
        }
    }];
    
    [self.window.rootViewController presentViewController:slVC animated:YES completion:nil];
    [self removeFromSuperview];
}

- (IBAction)doShareEmail:(id)sender
{
    
}

- (void) didMoveToSuperview
{
    //move to wondow in order for hit test to work propperly
    UIWindow *window = self.window;
    
    if (self.superview != window)
    {
        self.frame= [window convertRect:self.frame fromView:self.superview];
        [self removeFromSuperview];
            
        [window addSubview:self];
    }
}


@end
