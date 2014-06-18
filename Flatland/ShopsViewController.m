//
//  ShopsViewController.m
//  Flatland
//
//  Created by Stefan Aust on 15.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "ShopsViewController.h"
#import "RESTService.h"
#import "ShopAnnotation.h"
#import "ShopsTableViewController.h"
#import "ShopsDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FlatCheckbox.h"
#import "AlertView.h"

@interface ShopsViewController () <UITextFieldDelegate, CLLocationManagerDelegate>
    {
        CLLocationManager *locationManager;
    }
    @property (nonatomic, weak) IBOutlet MKMapView *mapView;
    @property (nonatomic, weak) IBOutlet UIView *overlayView;
    @property (nonatomic, weak) IBOutlet UITextField *textField;
    @property (nonatomic, weak) IBOutlet UIButton *optionsButton;
    @property (nonatomic, strong) CLLocation *currentLocation;
    @property (nonatomic, copy) NSArray *stores;
    @property (strong, nonatomic) IBOutlet FlatCheckbox *maschineOption;
    @property (strong, nonatomic) IBOutlet FlatCheckbox *capsuleOption;
    @property (strong, nonatomic) IBOutlet FlatCheckbox *demonstrationOption;
@property (weak, nonatomic) IBOutlet UIView *checkContainer;

    @property (nonatomic) BOOL isOptionMenuOpen;
    @property (nonatomic) BOOL isSearchBarOpen;
    @property (nonatomic) MKAnnotationView *annotationView;
@end

@implementation ShopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

#ifdef BABY_NES_US
    self.maschineOption.hidden = NO;
    self.capsuleOption.hidden = YES;
    self.demonstrationOption.hidden = NO;
#endif//BABY_NES_US
    
#ifdef BABY_NES_CH
    self.maschineOption.hidden = NO;
    self.capsuleOption.hidden = NO;
    self.demonstrationOption.hidden = YES;
#endif //BABY_NES_CH
    
#ifdef BABY_NES_FR
    self.maschineOption.hidden = YES;
    self.capsuleOption.hidden = YES;
    self.demonstrationOption.hidden = YES;
    self.optionsButton.hidden = YES;
#endif //BABY_NES_FR
    
    
    //hide associated labels
    for(UIView* check in self.checkContainer.subviews)
    {
        if ([check class] == [FlatCheckbox class] && check.hidden)
        {
            for(UIView* label in self.checkContainer.subviews)
            {
                if (([label class] == [UILabel class]) && (label.tag == check.tag))
                {
                    label.hidden = YES;
                    break;
                }
            }
        }
    }
    
    
    if ([kValidCountryCodes isEqual:@"fr"]) {
        NSString *message = T(@"storeLocator.alert");
        [[AlertView alertViewFromString:message buttonClicked:nil] show];
    }
    
    [self icnhLocalizeView];
    
    int dy = [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 ? -64 : 0;
    
    self.overlayView.frame = CGRectMake(20, 84 + dy , 80, 40);
    self.overlayView.layer.shadowOffset = CGSizeMake(0, 2);
    self.overlayView.layer.shadowOpacity = .5;
    
    UITapGestureRecognizer *r = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.mapView addGestureRecognizer:r];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [locationManager startUpdatingLocation];
    
    _mapView.delegate = self;
    [_mapView setShowsUserLocation:YES];
}

- (void)findLocation
{
    [locationManager startUpdatingLocation];
}

- (void)foundLocation:(CLLocation *)loc
{
    CLLocationCoordinate2D coord = [loc coordinate];
    
    // Zoom the region to this location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 2000, 2000);
    [_mapView setRegion:region animated:YES];
    
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // How many seconds ago was this new location created?
    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
    
    // CLLocationManagers will return the last found location of the
    // device first, you don't want that data in this case.
    // If this location was made more than 3 minutes ago, ignore it.
    if (t < -180) {
        // This is cached data, you don't want it, keep looking
        return;
    }
    
    [self foundLocation:newLocation];
        [self showStoresForLongitude:newLocation.coordinate.longitude latitude:newLocation.coordinate.latitude];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{

}

- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)u
{
    CLLocationCoordinate2D loc = [u coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [_mapView setRegion:region animated:YES];
    [self showStoresForLongitude:loc.longitude latitude:loc.latitude];
}

- (void)dealloc
{
    // Tell the location manager to stop sending us messages
    [locationManager setDelegate:nil];
}

// display all stores on map, centering the map on the first store
- (void)updateMap {
    NSArray *firstStore = nil;
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    for (NSArray *store in self.stores) {
        if (!firstStore) {
            firstStore = store;
            
            CLLocationDegrees latitude = [[store valueForKey:@"latitude"] doubleValue];
            CLLocationDegrees longitude = [[store valueForKey:@"longitude"] doubleValue];
            [self foundLocation:[[CLLocation alloc] initWithLatitude:latitude longitude:longitude]];
        }
        [_mapView addAnnotation:[[ShopAnnotation alloc] initWithStore:store]];
    }
}

- (IBAction)toggleSearch:(id)sender {
    CGFloat alpha;
    CGRect frame = self.overlayView.frame;
    if (frame.size.width == 80) {
        alpha = 1;
        frame.size.width = self.view.frame.size.width - frame.origin.x * 2;
        _isSearchBarOpen = YES;
    } else {
        alpha = 0;
        frame.size.width = 80;
        frame.size.height = 40;
        _isSearchBarOpen = NO;
    }
    [UIView animateWithDuration:.5 animations:^{
        self.optionsButton.alpha = alpha;
        self.overlayView.frame = frame;
        if (alpha) {
            [self.textField becomeFirstResponder];
        } else {
            [self.textField resignFirstResponder];
        }
    }];
}

- (IBAction)toggleOptions:(id)sender
{
    CGRect frame = self.overlayView.frame;
    
    if (!self.isOptionMenuOpen)
    {
        frame.size.height = 40;
        
        float nextCheckYOrigin = 5;
        
        for (UIView *check in self.checkContainer.subviews)
        {
            if ([check class] == [FlatCheckbox class] && !check.hidden)
            {
                frame.size.height += check.frame.size.height + 5;
                
                //also,reposition it
                CGRect checkFrame = check.frame;
                checkFrame.origin.y = nextCheckYOrigin;
                nextCheckYOrigin += checkFrame.size.height + 5;
                
                check.frame = checkFrame;

                //find the associated label(must have the same tag
                UILabel *associatedLabel = nil;
                for(UIView* label in self.checkContainer.subviews)
                {
                    if ([label class] == [UILabel class] && label.tag == check.tag)
                    {
                        associatedLabel = (UILabel*)label;
                        break;
                    }
                }
                //and move it to same y as check box - 3;
                if (nil != associatedLabel)
                {
                    CGRect associatedLabelFrame = associatedLabel.frame;
                    associatedLabelFrame.origin.y = check.frame.origin.y - 3;
                    associatedLabel.frame = associatedLabelFrame;
                }
            }
        }
        frame.size.height += 5;
        
        self.isOptionMenuOpen = YES;
    }
    else
    {
        frame.size.height = 40;
        _isOptionMenuOpen = NO;
    }
    
    [UIView animateWithDuration:.5 animations:^{
        self.overlayView.frame = frame;
    }];
}

- (IBAction)toggleDisplay:(id)sender {

}

#pragma mark - Map view delegate


- (MKAnnotationView *)mapView:(MKMapView *)mapView_ viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKPinAnnotationColor pinColor;
    UIImage *pinImage;
    
    if([annotation isKindOfClass:[ShopAnnotation class]]){
        pinColor = MKPinAnnotationColorPurple;
        pinImage = [UIImage imageNamed:@"pin.png"];
    } else {
        pinColor = MKPinAnnotationColorRed;
        pinImage = nil;
    }
    
    MKPinAnnotationView *view = (MKPinAnnotationView *)[mapView_ dequeueReusableAnnotationViewWithIdentifier:@"Store"];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Store"];
    }else{
        view.annotation = annotation;
    }
    
    view.enabled = YES;
    view.canShowCallout = YES;
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    view.userInteractionEnabled = YES;
    
    view.pinColor = pinColor;
    view.image = pinImage;
    return view;
}

- (void) mapView:(MKMapView *)sender annotationView:(MKAnnotationView *)aView calloutAccessoryControlTapped:(UIControl *)control {
    if([aView.annotation isKindOfClass:[ShopAnnotation class]]){
        _annotationView = aView;
        [self performSegueWithIdentifier:@"showShopDetailsView" sender:self];
    }
}


#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField.text length]) {
        [self showStoresForCityOrZipCode:textField.text];
        [self hideKeyboard];
        
        if(_isOptionMenuOpen)
        {
            [self toggleOptions:_optionsButton];
        }
        
        if(_isSearchBarOpen)
        {
            [self toggleSearch:_overlayView];
        }
        
    }
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    return YES;
}

#pragma mark - Private methods

- (void)hideKeyboard {
    [self.textField resignFirstResponder];
}

- (void)showStoresForURL:(NSString *)URL {
    [[RESTService sharedService] queueRequest:[RESTRequest getURL:URL] completion:^(RESTResponse *response) {
        
        if (!response.error) {
            self.stores = response.object;
            [self updateMap];
        } else {
            NSString *message = [[response.error userInfo] objectForKey:NSLocalizedDescriptionKey];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            alertView = nil;
        }
    }];
    
}

- (void)showStoresForCityOrZipCode:(NSString *)cityOrZipCode {
    [self showStoresForURL:[NSString stringWithFormat:
                            WS_storesForCityOrZipCode,
                            [cityOrZipCode stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            [NSString stringWithString:(self.maschineOption.on || self.maschineOption.hidden ? @"YES" : @"")],
    [NSString stringWithString:(self.capsuleOption.on ||self.capsuleOption.hidden ? @"YES" : @"")],
    [NSString stringWithString:(self.demonstrationOption.on || self.demonstrationOption.hidden ? @"YES" : @"")]]];
}

- (void)showStoresForLongitude:(float)longitude latitude:(float)latitude {
    [self showStoresForURL:[NSString stringWithFormat:
                            WS_showStores,
                            longitude,
                            latitude,
    [NSString stringWithString:(self.maschineOption.on || self.maschineOption.hidden ? @"YES" : @"")],
    [NSString stringWithString:(self.capsuleOption.on || self.capsuleOption.hidden ? @"YES" : @"")],
    [NSString stringWithString:(self.demonstrationOption.on || self.demonstrationOption.hidden ? @"YES" : @"")]]];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"showShopTableView"] && _stores.count > 0){
        return YES;
    }else{
        if([identifier isEqualToString:@"showShopTableView"]){
            return NO;
        }
    }
    
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showShopTableView"]) {
        ShopsTableViewController *destViewController = segue.destinationViewController;
        destViewController.stores = _stores;
    }
    
    if ([segue.identifier isEqualToString:@"showShopDetailsView"]) {
        ShopsDetailsViewController *destViewController = segue.destinationViewController;
        destViewController.store = [(ShopAnnotation *) _annotationView.annotation store];
    }
}
@end
