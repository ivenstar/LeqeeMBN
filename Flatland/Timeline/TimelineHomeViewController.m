//
//  TimelineHomeViewController.m
//  Flatland
//
//  Created by Bogdan Chitu on 11/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineHomeViewController.h"
#import "TimelineAddEntryViewController.h"
#import "TimelineEntry.h"
#import "TimelineEntryPhoto.h"
#import "TimelineEntryMood.h"
#import "TimelineEntryJournal.h"

#import "TimelinePhotoCell.h"
#import "TimelineMoodCell.h"
#import "TimelineJournalCell.h"
#import "TimelineAddEntryCell.h"

#import "TimelineService.h"

#import "User.h"

#import "WaitIndicator.h"


@interface TimelineHomeViewController ()
{
    BOOL friendsPopupVisibilityChangeHandled;
    BOOL friendsPopUpShown;
    
    double contentOffsetYMax;
    double contentOffsetYMin;
}

@property (weak, nonatomic) IBOutlet UIView *friendsFolowingPopUpView;
@property (weak, nonatomic) IBOutlet UILabel *friendsFolowingLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsFolowingModifyLabel;

@property (weak, nonatomic) IBOutlet UITableView* newsFeedTableView;

@property(nonatomic, strong) NSMutableArray* entries;
@property(nonatomic, readwrite) NSTimeInterval lastTimeStamp;

@property(nonatomic, readwrite) bool loading;

@end

@implementation TimelineHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setLoading:(bool)loading
{
    _loading = loading;
    [self.newsFeedTableView reloadData];
}


- (void) requestEntries:(int) nbEntries forDate:(NSDate*)date withCompletion:(void (^)(BOOL ok))completion
{
    if (!self.loading && self.lastTimeStamp != -1)
    {
        self.loading = YES;
        [TimelineService getEntriesForBaby:[[User activeUser] favouriteBaby] withDate:date andEntriesPerPage:nbEntries completion:^(NSArray *timelineEntries, NSTimeInterval lastTimeStamp)
        {
            if(timelineEntries)
            {
                //Add to entries array;
                for(TimelineEntry *entry in timelineEntries)
                {
                    [self.entries addObject:entry];
                }
                //save last timestamp
                self.lastTimeStamp = lastTimeStamp;
                
                self.loading = NO;
                completion(YES);
                return;
            }
            
            self.loading = NO;
            completion(NO);
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = MakeImageBarButton(@"barbutton-plus", self, @selector(doAddEntry:));
    
    [self configureFriendsView];
    
    self.newsFeedTableView.dataSource = self;
    self.newsFeedTableView.delegate = self;
    
    ((UIScrollView*)self.newsFeedTableView).delegate = self;
    
    [self.friendsFolowingPopUpView setHidden:YES];
    friendsPopUpShown = NO;

}

- (void) loadFirstEntries
{
    self.entries = [[NSMutableArray alloc] init];
    [self.newsFeedTableView setHidden:YES];
    
    [WaitIndicator waitOnView:self.view];
    
    self.lastTimeStamp = 0;
    
    [self requestEntries:TIMELINE_FIRST_LOAD_ENTRIES_PER_PAGE forDate:[NSDate date] withCompletion:^(BOOL ok)
     {
         [self.newsFeedTableView setHidden:NO];
         
         if (!friendsPopUpShown)
         {
             friendsPopUpShown = YES;
             [self.friendsFolowingPopUpView setHidden:NO];
             [self performSelector:@selector(closeFriendsFollowing:) withObject:nil afterDelay:TIMELINE_INTERVAL_TO_HIDE_FRIENDS_POPUP];
         }
         
         //hide the friends popup after x seconds
         [[WaitIndicator waitIndicator] stopWaiting];
     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadFirstEntries];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) doAddEntry: (id) sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Timeline" bundle:nil];
    TimelineAddEntryViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TimelineAddEntry"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) configureFriendsView
{
    if (!friendsPopupVisibilityChangeHandled)
    {
        //setup friends following
        if (!self.friendsFolowingPopUpView.hidden)
        {
            int tempNbFriends = 5;//TODO get from server
            self.friendsFolowingLabel.text = [NSString stringWithFormat:T(@"%timeline.friends.folowing"),tempNbFriends];
            
            [self.friendsFolowingLabel sizeToFit];
            [self.friendsFolowingModifyLabel sizeToFit];
            
            CGRect friendsFolowingFrame = self.friendsFolowingLabel.frame;
            friendsFolowingFrame.origin.y = (self.friendsFolowingLabel.superview.frame.size.height - friendsFolowingFrame.size.height)/2 + 1;
            self.friendsFolowingLabel.frame = friendsFolowingFrame;
            
            CGRect modifyFrame = self.friendsFolowingModifyLabel.frame;
            modifyFrame.origin.x = friendsFolowingFrame.origin.x + friendsFolowingFrame.size.width+ 4;
            modifyFrame.origin.y = friendsFolowingFrame.origin.y-1;
            self.friendsFolowingModifyLabel.frame = modifyFrame;
        }
        else //move the scrollview up
        {
            CGRect newsFeedFrame = self.newsFeedTableView.frame;
            newsFeedFrame.origin.y = self.friendsFolowingPopUpView.frame.origin.y;
            newsFeedFrame.size.height += self.friendsFolowingPopUpView.frame.size.height;
            self.newsFeedTableView.frame = newsFeedFrame;
        }
        
        friendsPopupVisibilityChangeHandled = YES;
    }
}

- (IBAction)closeFriendsFollowing:(id)sender
{
#ifdef TIMELINE_SAVE_SEEN_FRIENDS_HEADER
    [[User activeUser] setShouldHideFriendsHeader:YES];
#endif
    if (!self.friendsFolowingPopUpView.hidden)
    {
        [self.friendsFolowingPopUpView setHidden:YES];
        friendsPopupVisibilityChangeHandled = NO;
        [self configureFriendsView];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.entries count] + (self.loading ? 1 : 0) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    
    bool shouldReturnAddEntryCell = false;
    
    if (indexPath.row < [self.entries count])
    {
        TimelineEntry *entry = [self.entries objectAtIndex:indexPath.row];
        TimelineEntryCell *entryCell = [entry cellForEntry];
        if (entryCell)
        {
            [entryCell.bottomLine setHidden:NO];
            [entryCell.topLine setHidden:NO];
            if (indexPath.row == self.entries.count - 1)
            {
                [entryCell.bottomLine setHidden:YES];
            }
        }
        
        cell = entryCell;
    }
    else if (indexPath.row == self.entries.count)
    {
        if (self.loading)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TimelineLoadingCell" owner:self options:nil] objectAtIndex:0];
        }
        else
        {
           shouldReturnAddEntryCell = true;
        }
    }
    else
    {
        shouldReturnAddEntryCell = true;
    }
    
    if (shouldReturnAddEntryCell)
    {
        TimelineAddEntryCell* addEntryCell = [[[NSBundle mainBundle] loadNibNamed:@"TimelineAddEntryCell" owner:self options:nil] objectAtIndex:0];
        addEntryCell.navController = self.navigationController;
        [addEntryCell setUpCell];
        cell = addEntryCell;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.entries count])
    {
        TimelineEntry* entry = [self.entries objectAtIndex:indexPath.row];
        return [entry cellHeightForEntry];
    }
    else if (indexPath.row == self.entries.count)
    {
        if (self.loading)
        {
            return 51;
        }
        else
        {
            return 187; //add entry cell;
        }
    }
    else
    {
        return 187; //add entry cell;
    }
    
    return 0;
}


#pragma mark - UIScrollViewDelegate

#define CONTENT_OFFSET_Y_FOR_REFRESH 80

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(!self.loading)
    {
        if (contentOffsetYMin + CONTENT_OFFSET_Y_FOR_REFRESH < 0)
        {
            //TODO remova all data and load page 0
        }
        else if (contentOffsetYMax + self.newsFeedTableView.frame.size.height> self.newsFeedTableView.contentSize.height + CONTENT_OFFSET_Y_FOR_REFRESH - 187)//187 is add entry cell h
        {
            NSDate* lastEntryDate = [NSDate date];
            
            if ([self.entries count] > 0)
            {
//                lastEntryDate = [NSDate dateWithTimeIntervalSince1970:self.lastTimeStamp];
                
                lastEntryDate = [[self.entries objectAtIndex:[self.entries count]-1] date];
                NSTimeZone *zone = [NSTimeZone systemTimeZone];
                NSInteger interval = [zone secondsFromGMTForDate:lastEntryDate];
                lastEntryDate = [lastEntryDate dateByAddingTimeInterval:-interval]; //remove time zone
            }
            
            [self requestEntries:TIMELINE_ENTRIES_PER_PAGE forDate:lastEntryDate withCompletion:^(BOOL ok)
             {
             }];
        }
        
        contentOffsetYMax = contentOffsetYMin = 0;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!self.loading)
    {
        double contentOffsetY = self.newsFeedTableView.contentOffset.y;
        if (contentOffsetY < contentOffsetYMin)
        {
            contentOffsetYMin = contentOffsetY;
        }
        else if (contentOffsetY > contentOffsetYMax)
        {
            contentOffsetYMax = contentOffsetY;
        }
    }

}

@end
