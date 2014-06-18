//
//  BabyNesCapsulePicker.m
//  Flatland
//
//  Created by Bogdan Chitu on 18/02/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "BabyNesCapsulePicker.h"
#import "BabyNesCapsulePickerCell.h"
#import "Globals.h"

@interface BabyNesCapsulePicker() <UITableViewDelegate,UITableViewDataSource,BabyNesCapsulePickerCellDelegate>
{
    UIView *pickerHeader;
    UIButton *cancelButton;
    UILabel *titleLabel;
    
    UITableView *capsulePicker;
}

@end


@implementation BabyNesCapsulePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self awakeFromNib];
    }
    return self;
}

- (void) setUpView
{
    
    //setup header and picker
    if (nil == pickerHeader)
    {
        pickerHeader = [[UIView alloc] init];
        [pickerHeader setBackgroundColor:[UIColor BabyNesLightPurpleColor]];
        
        UIImage* cancelImage = [UIImage imageNamed:@"barbutton-cancel"];
        cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 34, 34)];
        [cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        
        titleLabel = [[UILabel alloc] init];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:T(@"%bottlefeeding.capsulePickerTitle")];
        
        [pickerHeader addSubview:titleLabel];
        [pickerHeader addSubview:cancelButton];
        
        [self addSubview:pickerHeader];
    }
    
    
    if (nil == capsulePicker)
    {
        capsulePicker = [[UITableView alloc] init];
        capsulePicker.dataSource = self;
        capsulePicker.delegate = self;
        [capsulePicker reloadData];
        
        [self addSubview:capsulePicker];
    }
    
    
    //setup frames
    [pickerHeader setFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    [titleLabel setFrame:CGRectMake(40, 0, pickerHeader.frame.size.width - 80, 44)];
 
    [capsulePicker setFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height-44)];
}

- (void) hide
{
    [self setHidden:YES];
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setUpView];
}

- (void)awakeFromNib
{
    [self setUpView];
}

- (void) setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (NO == hidden)
    {
        [self.superview bringSubviewToFront:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark

#pragma mark UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[Capsule capsules] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BabyNesCapsulePickerCell *capsuleCell = [[[NSBundle mainBundle] loadNibNamed:@"BabyNesCapsulePickerCell" owner:self options:nil] objectAtIndex:0];
    [capsuleCell configureForCapsule:[[Capsule capsules] objectAtIndex:[indexPath row]]];
    [capsuleCell setCellDelegate:self];
    
    return capsuleCell;
}

#pragma mark


#pragma mark

#pragma mark BabyNesCapsulePickerCellDelegate methods
- (void) capsuleSelected:(Capsule*) capsule withSize:(int) capsuleSize
{
    if (self.capsulePickerDelegate)
    {
        [self.capsulePickerDelegate picker:self didSelectCapsule:capsule capsuleSize:capsuleSize];
    }
    
    [self setHidden:YES];
}

@end
