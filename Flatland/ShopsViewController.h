//
//  ShopsViewController.h
//  Flatland
//
//  Created by Stefan Aust on 15.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"
#import <MapKit/MapKit.h>

@interface ShopsViewController : FlatViewController <CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate,UIGestureRecognizerDelegate>
- (void)showStoresForCityOrZipCode:(NSString *)cityOrZipCode;
- (void)showStoresForLongitude:(float)longitude latitude:(float)latitude;
@end
