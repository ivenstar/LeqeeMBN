//
//  TipsViewController.m
//  Flatland
//
//  Created by Magdalena Kamrowska on 29.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "TipsViewController.h"
#import "Tips.h"
#import "TipsCell.h"
#import "TipsDetailsViewController.h"
#import "GradientView.h"
#import "User.h"
#import "AlertView.h"

@interface TipsViewController ()

@end

@implementation TipsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    GradientView *view = [GradientView new];
    view.bounds = self.tableView.backgroundView.bounds;
    self.tableView.backgroundView = view;
    if(_favorites) {
        self.navigationItem.rightBarButtonItem = MakeImageBarButton(@"barbutton-delete", self, @selector(removeTips));
        _isEdited = NO;
    } else {
        self.navigationItem.rightBarButtonItem = MakeImageBarButton(@"barbutton-favorite", self, @selector(showFavorites));
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_favorites) {
        return [[[User activeUser] favoriteTips] count];
    } else {
        return [[Tips sharedTips] count];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return _favorites;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TipsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"tipsCell"];
    [cell setTip:[[Tips sharedTips] tipAtIndex:indexPath.row]];
    [cell configure];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TipsDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TipsDetails"];
    if(_favorites) {
        [vc setTip:[[Tips sharedTips] tipForWeek:[[[User activeUser] favoriteTips] objectAtIndex:indexPath.row]]];
    } else {
        [vc setTip:[[Tips sharedTips] tipAtIndex:indexPath.row]];
    }
    
    vc.baby = _baby;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [[User activeUser] removeTip:[[[User activeUser] favoriteTips] objectAtIndex:indexPath.row]];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];

    }
}

- (void)showFavorites {
    TipsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Tips"];
    [vc setFavorites:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)removeTips {
    if (_isEdited) {
        [self.tableView setEditing:NO animated:YES];
        _isEdited = NO;
    } else {
        [self.tableView setEditing:YES animated:YES];
        _isEdited = YES;
    }
}

@end
