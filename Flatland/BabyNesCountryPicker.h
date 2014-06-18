//
//  BabyNesCountryPicker.h
//  Flatland
//
//  Created by Bogdan Chitu on 13/02/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "FlatTextField.h"
#import "Country.h"

@protocol BabyNesCountryPickerDelegate;
@interface BabyNesCountryPicker : FlatTextField

@property (nonatomic, strong) Country* selectedCountry;
@property(nonatomic,assign) id<BabyNesCountryPickerDelegate> delegate;

@end

@protocol BabyNesCountryPickerDelegate

/*
 * Called when the picker's country changes
 * @param: picker - the picker that changet the value
 * @param: country - the new value
 */
- (void) picker:(BabyNesCountryPicker*) picker changedCountry: (Country*) country;


@end
