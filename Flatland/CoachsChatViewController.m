//
//  CoachsChatViewController.m
//  Flatland
//
//  Created by Magdalena Kamrowska on 12.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CoachsChatViewController.h"
#import "ChatCell.h"
#import "User.h"
#import "RESTService.h"
#import "RESTRequest.h"
#import "Message.h"
#import "AlertView.h"
#import "WaitIndicator.h"
@interface CoachsChatViewController ()
@property (weak, nonatomic) IBOutlet UIView *chatWaiter;

@end

@implementation CoachsChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view changeSystemFontToApplicationFont];
    self.chatView.backgroundColor = [UIColor clearColor];
    self.chatView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatView.delegate = self;
    [self.chatView setDataSource:self];
    
    [self.chatInput setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    [_chatWaiter setHidden:NO];
    [_baby loadMessages:^(BOOL success) {
        [_chatWaiter setHidden:YES];
        [_chatView reloadData];
        [_chatView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([_chatView numberOfRowsInSection:0]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidAppear:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged:) name:UITextFieldTextDidChangeNotification object:_chatInput];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_chatView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([_chatView numberOfRowsInSection:0]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - tableView delegate and datasource methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 90;
    } else {
        NotificationMessage *msg = [[_baby messages] objectAtIndex:(indexPath.row - 1)];
        if(!msg.response) {
            ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"requestCell"];
            cell.message = msg;
            [cell configure];
            return cell.frame.size.height;
        } else {
            ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"responseCell"];
            cell.message = msg;
            [cell configure];
            return cell.frame.size.height;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return the number of messages with one extra cell for the welcome-message
    return [[_baby messages] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"welcomeCell"];
        cell.messageLabel.text = T(@"%coach.welcome");
        [cell roundCorners];
        return cell;
    } else {
        NotificationMessage *msg = [[_baby messages] objectAtIndex:(indexPath.row - 1)];
        if(!msg.response) {
            ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"requestCell"];
            cell.message = msg;
            [cell roundCorners];
            [cell configure];
            return cell;
        } else {
            ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"responseCell"];
            cell.message = msg;
            [cell roundCorners];
            [cell configure];
            return cell;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    [self send:nil];
    return YES;
}

#pragma mark - keyboard notifications

- (void)keyboardDidAppear:(NSNotification*)notification {
    [self.chatView setFrame:CGRectMake(self.chatView.frame.origin.x, self.chatView.frame.origin.y, self.chatView.frame.size.width, (self.chatView.frame.size.height - 216.))];
    [self.chatControlsContainer setFrame:CGRectMake(self.chatControlsContainer.frame.origin.x, (self.chatControlsContainer.frame.origin.y - 216.), self.chatControlsContainer.frame.size.width, self.chatControlsContainer.frame.size.height)];
    [_chatView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([_chatView numberOfRowsInSection:0]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    [self.chatView setFrame:CGRectMake(self.chatView.frame.origin.x, self.chatView.frame.origin.y, self.chatView.frame.size.width, (self.chatView.frame.size.height + 216.))];
    [self.chatControlsContainer setFrame:CGRectMake(self.chatControlsContainer.frame.origin.x, (self.chatControlsContainer.frame.origin.y + 216.), self.chatControlsContainer.frame.size.width, self.chatControlsContainer.frame.size.height)];
    [_chatView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([_chatView numberOfRowsInSection:0]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - chatcontrol related stuff

- (void)textViewChanged:(NSNotification *)notification {
    if ([self.chatInput.text length] > 500 && self.sendButton.enabled) {
        [[AlertView alertViewFromString:T(@"%coach.alert.limitedLength")buttonClicked:nil] show];
    }
    [_sendButton setEnabled:([self.chatInput.text length] <= 500)];
}

- (IBAction)send:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if([_chatInput.text length] > 0) {
        id message = @{
                       @"authorId" : _baby.ID,
                       @"babyMessage" : _chatInput.text
                    };
        [_chatWaiter setHidden:NO];
        [[RESTService sharedService]
         queueRequest:[RESTRequest postURL:WS_babyMessageCreate object:message]
         completion:^(RESTResponse *request) {
             [_chatWaiter setHidden:YES];
             self.chatInput.text = @"";
             [_baby loadMessages:^(BOOL success) {
                 [_chatView reloadData];
                 [_chatView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([_chatView numberOfRowsInSection:0]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
             }];
         }];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
