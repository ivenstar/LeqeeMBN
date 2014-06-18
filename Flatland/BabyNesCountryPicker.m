//
//  BabyNesCountryPicker.m
//  Flatland
//
//  Created by Bogdan Chitu on 13/02/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "BabyNesCountryPicker.h"
#import <UIKit/UIPickerView.h>
#import "Country.h"


@interface BabyNesCountryPicker() <UIPickerViewDataSource,UIPickerViewDelegate>
{
    int _pos;
}

@property (nonatomic,strong) UIPickerView *picker;

@end

@implementation BabyNesCountryPicker

- (void)setSelectedCountry:(Country *)selectedCountry
{
    if (![[_selectedCountry code] isEqualToString:[selectedCountry code]])
    {
        NSArray* countries = CountriesJSON();
        for(int i=0;i<[countries count];i++)
        {
            Country *country = [countries objectAtIndex:i];
            if ([[country code] isEqualToString:[selectedCountry code]])
            {
                [_picker selectRow:i inComponent:0 animated:NO];
                _pos = i;
                _selectedCountry = [countries objectAtIndex:i];
                self.text = [_selectedCountry name];
                if (nil != self.delegate)
                {
                    [self.delegate picker:self changedCountry:self.selectedCountry];
                }
                break;
            }
            
        }
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addPicker];
}

- (void) addPicker
{
    if (self.picker == nil)
    {
        self.picker = [[UIPickerView alloc] init];
        
        UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        accessoryView.barStyle = UIBarStyleBlackTranslucent;
        accessoryView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDonePressed)];
        UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        accessoryView.items = [NSArray arrayWithObjects:flexibleSpace, doneButton, nil];
        
        [self.picker setDelegate:self];
        [self.picker setShowsSelectionIndicator:YES];
        
        [self setInputView:self.picker];
        [self setInputAccessoryView:accessoryView];
        
        NSArray *countries = CountriesJSON();
        _selectedCountry = [countries objectAtIndex:0];
        self.text = [_selectedCountry name];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addPicker];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark -
#pragma mark PickerView DataSource
- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray* countries = CountriesJSON();
    return [countries count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *countries = CountriesJSON();
    Country *country = [countries objectAtIndex:row];
    return [country name];
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _pos = row;
}

- (void)pickerDonePressed
{
    NSArray *countries = CountriesJSON();
    if (_selectedCountry != [countries objectAtIndex:_pos])
    {
        _selectedCountry = [countries objectAtIndex:_pos];
        self.text = [_selectedCountry name];
        if (nil != self.delegate)
        {
            [self.delegate picker:self changedCountry:self.selectedCountry];
        }
    }
    
    [self resignFirstResponder];
    
}

@end
