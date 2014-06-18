//
//  TimelineAddEntryViewController.m
//  Flatland
//
//  Created by Bogdan Chitu on 11/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineAddEntryViewController.h"
#import "CalendarView.h"
#import "FlatButton.h"
#import "WaitIndicator.h"

#import "TimelineEntryJournal.h"
#import "TimelineEntryMood.h"
#import "TimelineEntryPhoto.h"

#import "TimelineService.h"

#import "User.h"

#import "TimelineHomeViewController.h" //added for entries.TODO remove

@interface TimelineAddEntryViewController ()
{
    NSArray* postEditorViews;
    UIImage* originalPhotoImage;
}

@property (weak, nonatomic) IBOutlet CalendarView *calendarView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollViewContainer;
@property (weak, nonatomic) IBOutlet RadioButtonGroup *entryTypeRadioButtonGroup;
@property (weak, nonatomic) IBOutlet UIButton *radioButtonMood;
@property (weak, nonatomic) IBOutlet UIButton *radioButtonPhotos;
@property (weak, nonatomic) IBOutlet UIButton *radioButtonJournal;

@property (weak, nonatomic) IBOutlet UIView *moodContainer;
@property (weak, nonatomic) IBOutlet RadioButtonGroup *moodRadioButton;


@property (weak, nonatomic) IBOutlet UILabel *moodTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *moodDescriptionTextField;


@property (weak, nonatomic) IBOutlet UIView *photoContainer;
@property (weak, nonatomic) IBOutlet UITextField *photoTitleTextFeild;
@property (weak, nonatomic) IBOutlet UITextView *photoDescriptionTextField;
@property (weak, nonatomic) IBOutlet FlatButton *photoAddPhotoButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoEntryImageView;

@property (weak, nonatomic) IBOutlet UIView *journalContainer;
@property (weak, nonatomic) IBOutlet UITextField *journalTitleTextField;

@property (weak, nonatomic) IBOutlet UITextView *journalDescriptionTextView;

@end

@implementation TimelineAddEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _selectedIndex = -1;
    }
    return self;
}

- (void) awakeFromNib
{
    _selectedIndex = -1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        postEditorViews = [NSArray arrayWithObjects:self.moodContainer,self.photoContainer,self.journalContainer, nil];
    
    self.navigationItem.rightBarButtonItem = MakeImageBarButton(@"barbutton-close", self, @selector(goBack));
    
    [self.entryTypeRadioButtonGroup setDelegate:self];
    [self.photoTitleTextFeild setDelegate:self];
    [self.photoDescriptionTextField setDelegate:self];
    
    
    self.scrollView.contentSize = self.scrollViewContainer.frame.size;
    [self.photoAddPhotoButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.photoDescriptionTextField.cornerRadius = self.photoTitleTextFeild.cornerRadius = 4;
    self.journalDescriptionTextView.cornerRadius = self.journalTitleTextField.cornerRadius = 4;
    self.moodDescriptionTextField.cornerRadius = 4;
    self.photoEntryImageView.cornerRadius = 8;
    self.photoEntryImageView.layer.masksToBounds = YES;
    
    if (self.selectedIndex != -1)
    {
        [self.entryTypeRadioButtonGroup setSelectedButtonWithTag:self.selectedIndex];
    }
    else
    {
        [self.entryTypeRadioButtonGroup setSelectedButton:self.radioButtonPhotos];
    }
    
    [self.moodRadioButton setSelectedButtonWithTag:(int) MOOD_HUNGRY];
    
    UITapGestureRecognizer *r = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scrollViewContainer addGestureRecognizer:r];
    
    self.moodTitleLabel.text = [NSString stringWithFormat:T(@"%timeline.mood.title"),[[[User activeUser] favouriteBaby] name]];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shrinkFormScrollView:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(growFormScrollView:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shrinkFormScrollView:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    
    CGSize size = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, size.height, 0);
    
    self.scrollView.contentInset = insets;
    self.scrollView.scrollIndicatorInsets = insets;
    
    // make sure that the active text field / text view is visible
    
    
    UIView *firstResponder = [UIView enumerateAllSubviewsOf:self.scrollView UsingBlock:^BOOL(UIView *view)
    {
        return [view isFirstResponder];
    }];
    
    if(firstResponder != nil)
    {
        CGRect viewFrame = [firstResponder.superview convertRect:firstResponder.frame toView:self.scrollView];
        [self.scrollView scrollRectToVisible:CGRectInset(viewFrame, -5, -5) animated:YES];
    }
}

- (void)growFormScrollView:(NSNotification *)notification
{
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - methods

- (IBAction)generalAddEntry:(id)sender {
    [self hideKeyboard];
    
    TimelineEntry *newEntry;
    
    switch (self.entryTypeRadioButtonGroup.selectedIndex)
    {
        case 0: //Mood
        {
            //check required field
            if (![self.moodDescriptionTextField.text length]>0)
            {
                [[[UIAlertView alloc] initWithTitle:nil
                                      message:T(@"%timeline.alert.comment.required")
                                      delegate:nil
                                      cancelButtonTitle:T(@"%general.ok")
                                      otherButtonTitles:nil] show];
                return;
            }
            
            TimelineEntryMood *newMoodEntry = [[TimelineEntryMood alloc] init];
            newMoodEntry.mood = (Mood) self.moodRadioButton.selectedIndex;
            newMoodEntry.comment = self.moodDescriptionTextField.text;
            
            newEntry = newMoodEntry;
        }
            break;
        case 1: //Photo
        {
            //check required field
            if (![self.photoDescriptionTextField.text length]>0)
            {
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:T(@"%timeline.alert.caption.required")
                                           delegate:nil
                                  cancelButtonTitle:T(@"%general.ok")
                                  otherButtonTitles:nil] show];
                return;
            }
            
            TimelineEntryPhoto *newPhotoEntry = [[TimelineEntryPhoto alloc] init];
            newPhotoEntry.title = self.photoTitleTextFeild.text;
            newPhotoEntry.comment = self.photoDescriptionTextField.text;
            newPhotoEntry.image = originalPhotoImage;
            
            newEntry = newPhotoEntry;
        }
            break;
        case 2: //Journal
        {
            //check required field
            if (![self.journalDescriptionTextView.text length]>0)
            {
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:T(@"%timeline.alert.description.required")
                                           delegate:nil
                                  cancelButtonTitle:T(@"%general.ok")
                                  otherButtonTitles:nil] show];
                return;
            }
            
            TimelineEntryJournal *newJournalEntry = [[TimelineEntryJournal alloc] init];
            newJournalEntry.title = self.journalTitleTextField.text;
            newJournalEntry.comment = self.journalDescriptionTextView.text;

            newEntry = newJournalEntry;
        }
            break;
            
        default:
            break;
    }
    
    
    //Check calendar view selected date.If it's today,date for entry will be [nsdate date] with -1 interval(-1 for listing in main screen)
    NSDateComponents *calendarVIewDateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.calendarView.selectedDate];
    NSDateComponents *todayDateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    if (calendarVIewDateComponents.year == todayDateComponents.year && calendarVIewDateComponents.month == todayDateComponents.month && calendarVIewDateComponents.day == todayDateComponents.day)
    {
        newEntry.date = [[NSDate date] dateByAddingTimeInterval:-1];
    }
    else
    {
        newEntry.date = self.calendarView.selectedDate;
    }
    
    //todo refactor this
     [WaitIndicator waitOnView:self.view];
    if ([newEntry isKindOfClass:[TimelineEntryPhoto class]])
    {
        [TimelineService savePhotoEntry:(TimelineEntryPhoto*) newEntry forBaby:[[User activeUser] favouriteBaby] withCompletion:^(BOOL success)
        {
            [self.view stopWaiting];
            [self goBack];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTimelineWidgetNotification" object:nil];
        }];
    }
    else
    {
        [TimelineService saveEntry:newEntry forBaby:[[User activeUser] favouriteBaby] completion:
        ^(BOOL success, NSArray *errors) {
            [self.view stopWaiting];
            [self goBack];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTimelineWidgetNotification" object:nil];
        }];
    }
    
    
    
}

- (void) setSelectedIndex:(int)selectedIndex
{
    _selectedIndex = selectedIndex;
    [self.entryTypeRadioButtonGroup setSelectedButtonWithTag:selectedIndex];
}

- (void)takePictureWithCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return;
    }
    
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    if (![mediaTypes containsObject:@"public.image"])
    {
        return;
    }
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.mediaTypes = mediaTypes;
    controller.allowsEditing = YES;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)pickPictureFromDevice {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.allowsEditing = YES;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - photo related methods

- (IBAction)AddPicture:(id)sender
{
    [self hideKeyboard];
    
    //show the actionsheet
    [[[UIActionSheet alloc] initWithTitle:@""
                                 delegate:self
                        cancelButtonTitle:T(@"%general.cancel")
                   destructiveButtonTitle:nil
                        otherButtonTitles:T(@"%babyProfile.takePhoto"), T(@"%babyProfile.pickPhoto"), nil]
     showFromToolbar:self.navigationController.toolbar];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: // take new picture with Camera
            [self takePictureWithCamera];
            break;
        case 1: // pick a picture from device
            [self pickPictureFromDevice];
            break;
        default: // cancel
            break;
    }
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    originalPhotoImage = [[info objectForKey:UIImagePickerControllerOriginalImage] rotatedImage];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (nil == image)
    {
        image = originalPhotoImage;
    }
    self.photoEntryImageView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RadioButtonGroupDelegate methods
- (void)radioButtonGroup:(RadioButtonGroup *)group buttonPressed:(UIControl *)button
{
    [self hideKeyboard];
    
    UIView *containerToRemainVisible = nil;
    switch (button.tag)
    {
        case 0:
            containerToRemainVisible = self.moodContainer;
            break;
        case 1:
            containerToRemainVisible = self.photoContainer;
            break;
        case 2:
            containerToRemainVisible = self.journalContainer;
            break;
            
        default:
            break;
    }
    
    if (nil != containerToRemainVisible)
    {
        for (UIView* container in postEditorViews)
        {
            container.hidden = containerToRemainVisible != container;
        }
    }
}

#pragma mark - UITextfieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate methods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

@end
