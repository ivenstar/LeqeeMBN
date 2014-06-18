//
//  TimelineAddEntryViewController.h
//  Flatland
//
//  Created by Bogdan Chitu on 11/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatViewController.h"
#import "RadioButtonGroup.h"
#import "CalendarView.h"

@interface TimelineAddEntryViewController : FlatViewController<RadioButtonGroupDelegate,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
}

@property (nonatomic,readwrite) int selectedIndex;


@end
