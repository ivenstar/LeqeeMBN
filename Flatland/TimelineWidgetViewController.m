//
//  TimelineWidgetViewController.m
//  Flatland
//
//  Created by Bogdan Chitu on 30/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineWidgetViewController.h"
#import "TimelineService.h"

#import "TimelineEntryBirthDay.h"
#import "TimelineEntryFeeding.h"
#import "TimelineEntryJournal.h"
#import "TimelineEntryMood.h"
#import "TimelineEntryPhoto.h"
#import "TimelineEntryWeight.h"

#import "TimelineAddEntryViewController.h"

#import "DynamicSizeContainer.h"

@interface TimelineWidgetViewController ()
{
    TimelineEntry* _entry;
}
@property (weak, nonatomic) IBOutlet UIView *entryView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@end

@implementation TimelineWidgetViewController

@synthesize baby = _baby;
@synthesize date = _date;
@synthesize dateIndex = _dateIndex;


- (void)setBaby:(Baby *)baby {
    _baby = baby;
    [self updateDataFromServer];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.captionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.captionLabel.numberOfLines = 0;
    
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWidget) name:@"UpdateWidgetNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWidget) name:@"UpdateTimelineWidgetNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (NSString*) widgetIdentifier
{
    return @"TimelineWidget";
}

- (void)updateWidget {
    [self updateDataFromServer];
}

- (void) updateDataFromServer
{
    if (self.baby == nil || self.date == nil)
    {
        return;
    }
    
    [self showLoadingOverlay];
    [self.entryView setHidden:YES];

    [TimelineService getEntriesForBaby:self.baby withDate:[NSDate date] andEntriesPerPage:1 completion:^(NSArray * entries,NSTimeInterval lastTimeStamp)
    {
        if(entries != nil && [entries count]>0)
        {
            _entry = [entries objectAtIndex:0];
            [self.entryView setHidden:NO];
        }
        
        [self setUpEntryView];
        [self hideLoadingOverlay];
    }];
    
}

- (void) setUpEntryView
{
    //cleanup
    self.titleLabel.text = nil;
    self.dateLabel.text = nil;
    self.captionLabel.text = nil;
    self.photoImageView.image = nil;
    
    
    if (_entry != nil)
    {
        //configure the view
        self.titleLabel.text = _entry.title;
        self.dateLabel.text = FormattedDateForTimeline(_entry.date);
        
        UIImage * photoImage = nil;
        
        if ([_entry isKindOfClass:[TimelineEntryPhoto class]])
        {
            self.iconImageView.image = [UIImage imageNamed:@"timeline_icon_photo"];
            self.captionLabel.text = [(TimelineEntryPhoto*)_entry comment];
            photoImage = [[(TimelineEntryPhoto*)_entry image] copy];
            
        }
        else if ([_entry isKindOfClass:[TimelineEntryMood class]])
        {
            self.iconImageView.image = [UIImage imageNamed:@"timeline_icon_mood"];
            self.captionLabel.text = [(TimelineEntryMood*)_entry comment];
        }
        else if ([_entry isKindOfClass:[TimelineEntryJournal class]])
        {
            self.iconImageView.image = [UIImage imageNamed:@"timeline_icon_journal"];
            self.captionLabel.text = [(TimelineEntryJournal*)_entry comment];
        }
        else if ([_entry isKindOfClass:[TimelineEntryWeight class]])
        {
            self.iconImageView.image = [UIImage imageNamed:@"timeline_icon_birthday"]; //TODO propper image
        }
        else if ([_entry isKindOfClass:[TimelineEntryFeeding class]])
        {
            self.iconImageView.image = [UIImage imageNamed:@"timeline_icon_birthday"]; //TODO propper image
        }
        else if ([_entry isKindOfClass:[TimelineEntryBirthDay class]])
        {
            self.iconImageView.image = [UIImage imageNamed:@"timeline_icon_birthday"];
        }


        //Title Label Frame
        CGRect titleLabelFrame = self.titleLabel.frame;
        titleLabelFrame.size = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.frame.size.width, CGFLOAT_MAX)];
        self.titleLabel.frame = titleLabelFrame;
        
        //Date label
        CGRect dateLabelFrame = self.dateLabel.frame;
        dateLabelFrame.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 3;
        self.dateLabel.frame = dateLabelFrame;
        
        //ImageView Frame
        CGSize imageSize = photoImage.size;
        CGFloat photoImageMaxWidth = self.entryView.frame.size.width - self.dateLabel.frame.origin.x - 5;
        
        float newScale = imageSize.width == 0 ? 0 : photoImageMaxWidth/imageSize.width;
        
        if (newScale < 1)
        {
            imageSize.width = imageSize.width * newScale;
            imageSize.height = imageSize.height * newScale;
        }
        
        CGRect imageFrame = self.photoImageView.frame;
        imageFrame.size = imageSize;
        imageFrame.origin.x = self.dateLabel.frame.origin.x;
        imageFrame.origin.y = self.dateLabel.frame.origin.y + self.dateLabel.frame.size.height + (imageFrame.size.height > 0 ? 5:0);
        
        self.photoImageView.frame = imageFrame;
        self.photoImageView.image = photoImage;
        
        
        //Caption Label Frame
        CGRect captionLabelFrame = self.captionLabel.frame;
        captionLabelFrame.size = [self.captionLabel sizeThatFits:CGSizeMake(self.captionLabel.frame.size.width, CGFLOAT_MAX)];
        captionLabelFrame.origin.y = self.photoImageView.frame.origin.y + self.photoImageView.frame.size.height + (captionLabelFrame.size.height > 0 ? 5:0);
        self.captionLabel.frame = captionLabelFrame;
        
        //Entry View Frame
        CGRect entryViewFrame = self.entryView.frame;
        entryViewFrame.size.height = self.captionLabel.frame.origin.y + self.captionLabel.frame.size.height;
        self.entryView.frame = entryViewFrame;
        
        //Widget Frame
        self.widgetView.frame = CGRectMake(self.widgetView.frame.origin.x, self.widgetView.frame.origin.y, self.widgetView.frame.size.width, self.entryView.frame.origin.y + self.entryView.frame.size.height + 10);
        
        //Widget container frame
        DynamicSizeContainer* widgetContainer = (DynamicSizeContainer*)[self.widgetView superview];
        CGFloat widgetContainerHeight = widgetContainer.frame.size.height;
        [widgetContainer sizeToFit];
        
        //ScrollView Frame and content offset
        UIScrollView* scrollView = (UIScrollView*)[widgetContainer superview];
        CGPoint scrollViewContentOffset = scrollView.contentOffset;
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.width + widgetContainerHeight - widgetContainer.frame.size.height);
        if (scrollViewContentOffset.y > scrollView.contentSize.height)
        {
            scrollViewContentOffset.y = scrollView.contentSize.height;
        }
        scrollView.contentOffset = scrollViewContentOffset;
    }
}

- (IBAction) addEntry:(id)sender
{   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Timeline" bundle:nil];
    TimelineAddEntryViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TimelineAddEntry"];
    [self.originNavigationController pushViewController:vc animated:YES];
}



@end
