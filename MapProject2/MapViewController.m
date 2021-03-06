//
//  MapViewController.m
//  MapProject2
//
//  Created by Khue TD on 3/27/13.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import "MapViewController.h"
#import "ConfigMapViewController.h"
#import "DetailViewController.h"
#import "Overlay.h"
#import "OverlayView.h"
#import "AFNetworking.h"



@interface MapViewController () <ConfigurationViewControllerDelegate>

@end

@implementation MapViewController

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
    locationManager = [[CLLocationManager alloc] init];
    
    [locationManager setDelegate:self];
    
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //set layout
    self.navigationItem.title = NSLocalizedString(@"Map", nil);
    
    UIBarButtonItem *findBusStationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(find:)];
    
    UIBarButtonItem *userTrackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:_mapView];
    
    UIBarButtonItem *configurationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl target:self action:@selector(configure:)];
    
    //self.searchBarItem = [[UISearchBar alloc] initWithFrame:CGRectMake(50, 0, 220, 40) ];
    self.searchBarItem = [[UISearchBar alloc] initWithFrame:CGRectMake(60, 0, 195, 40) ];
    self.searchBarItem.placeholder = NSLocalizedString(@"Search or Address", nil);
    
    [self.searchBarItem setDelegate:self];
    
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.searchBarItem];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    _toolBar.items = @[userTrackingButton, findBusStationButton, searchBarButton, configurationButton];
    //_toolBar.items = @[userTrackingButton, searchBarButton, configurationButton];
    
     _mapView.delegate = self;
    
    self.mapSource = MapSourceGoogle;
    //self.mapType = MKMapTypeHybrid;
    self.radius = 200;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self restoreSessionState];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveSessionState];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _mapView.showsUserLocation = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -

- (void)refresh {
    [_mapView removeOverlay:_overlay];
    
    if (_mapSource == MapSourceGoogle) {
        self.overlay = [[Overlay alloc] initWithMapType:_mapType];
        [_mapView addOverlay:_overlay];
    }
}

-(void)setMapSource:(MapSource)mapSource{
    _mapSource = mapSource;
    [self refresh];

}

- (void)setMapType:(MKMapType)mapType {
    _mapType = mapType;
    _mapView.mapType = mapType;
    
    [self refresh];
}

#pragma mark -

- (void)configure:(id)sender {
    [self performSegueWithIdentifier:@"Config" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Config"]) {
        ConfigMapViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.radius = _radius;
        controller.mapSource = _mapSource;
        controller.mapType = _mapType;
        controller.hidden = NO;
    } else if ([segue.identifier isEqualToString:@"detail"]) {
        DetailViewController *controller = segue.destinationViewController;
        controller.mapView = _mapView;
        controller.placemark = [sender annotation];
    }
}

#pragma mark -

- (void)configurationViewController:(ConfigMapViewController *)controller radiusChanged:(int)radius
{
    self.radius = radius;
}

- (void)configurationViewController:(ConfigMapViewController *)controller mapSourceChanged:(MapSource)mapSource
{
    self.mapSource = mapSource;
}

- (void)configurationViewController:(ConfigMapViewController *)controller mapTypeChanged:(MKMapType)mapType
{
    self.mapType = mapType;
}

- (void)configurationViewControllerWillAddPin:(ConfigMapViewController *)controller
{
    NSArray *annotations = _mapView.annotations;
    for (id annotation in annotations)
    {
        if (annotation != _mapView.userLocation)
        {
            [_mapView removeAnnotation:annotation];
        }
    }
    
    //[_mapView removeAnnotation:droppedPin];
    
    CLLocationCoordinate2D centerCoordinate = _mapView.centerCoordinate;
    
    droppedPin = [[Placemark alloc] initWithCoordinate:centerCoordinate addressDictionary:nil];
    droppedPin.coordinate = centerCoordinate;
    droppedPin.title = NSLocalizedString(@"Dropped Pin", nil);
    [_mapView addAnnotation:droppedPin];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f%%2C%f&sensor=true", centerCoordinate.latitude, centerCoordinate.longitude]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *status = [JSON valueForKeyPath:@"status"];
        NSLog(@"JSON PinCenter: %@", JSON);
        if ([status isEqualToString:@"OK"]) {
            NSArray *results = [JSON valueForKeyPath:@"results"];
            if (results.count > 0) {
                NSDictionary *addressDictionary = [self addressDictionaryFromJSON:results[0]];
                NSArray *addressLines = [addressDictionary objectForKey:@"FormattedAddressLines"];
                if (addressLines) {
                    droppedPin.subtitle = [addressLines componentsJoinedByString:@", "];
                }
                else {
                    droppedPin.subtitle = ABCreateStringWithAddressDictionary (addressDictionary, NO);
                }
                droppedPin.addressDictionary = addressDictionary;
            }
        }
    } failure:nil];
    [operation start];
}

- (void)configurationViewControllerWillPrintMap:(ConfigMapViewController *)configurationViewController
{
    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
    if(!controller){
        return;
    }
    
    UIPrintInteractionCompletionHandler completionHandler = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(completed && error) {
            return;
        }
    };
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputPhoto;
    
    controller.printInfo = printInfo;
    controller.printFormatter = [_mapView viewPrintFormatter];
    
    [controller presentAnimated:YES completionHandler:completionHandler];
}

#pragma mark -

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if (annotation == mapView.userLocation)
    {
		return nil;
	}
    
    if (annotation == droppedPin)
    {
        MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;

        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.annotation = annotation;
        [mapView selectAnnotation:annotation animated:YES];
        
        return annotationView;
    }
    else if ([annotation isKindOfClass:[BusLocation class]])
    {
        MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        
        annotationView.pinColor = MKPinAnnotationColorGreen;
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        
        return annotationView;
    }
	MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
    
    annotationView.pinColor = MKPinAnnotationColorRed;
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES;
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	annotationView.annotation = annotation;
    [mapView selectAnnotation:annotation animated:YES];
    
	return annotationView;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    OverlayView *view = [[OverlayView alloc] initWithOverlay:overlay];
    return view;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"detail" sender:view];
}

#pragma mark-

- (void)restoreSessionState {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *lastSession = [defaults objectForKey:@"LastSession"];
    
    if (lastSession) {
        NSNumber *latitude = [lastSession objectForKey:@"center.latitude"];
        NSNumber *longitude = [lastSession objectForKey:@"center.longitude"];
        NSNumber *latitudeDelta = [lastSession objectForKey:@"span.latitudeDelta"];
        NSNumber *longitudeDelta = [lastSession objectForKey:@"span.longitudeDelta"];
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
        MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta.doubleValue, longitudeDelta.doubleValue);
        
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        _mapView.region = region;
    }
}

- (void)saveSessionState {
    MKCoordinateRegion region = _mapView.region;
    CLLocationCoordinate2D center = region.center;
    MKCoordinateSpan span = region.span;
    
    NSMutableDictionary *lastSession = [NSMutableDictionary dictionary];
    [lastSession setObject:[NSNumber numberWithDouble:center.latitude] forKey:@"center.latitude"];
    [lastSession setObject:[NSNumber numberWithDouble:center.longitude] forKey:@"center.longitude"];
    [lastSession setObject:[NSNumber numberWithDouble:span.latitudeDelta] forKey:@"span.latitudeDelta"];
    [lastSession setObject:[NSNumber numberWithDouble:span.longitudeDelta] forKey:@"span.longitudeDelta"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:lastSession forKey:@"LastSession"];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [self saveSessionState];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    [self restoreSessionState];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [self saveSessionState];
}

#pragma mark-

- (NSDictionary *)addressDictionaryFromJSON:(id)JSON
{
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    addressDictionary[@"FormattedAddressLines"] = [((NSString *)[JSON valueForKey:@"formatted_address"]) componentsSeparatedByString:@", "];
    for (id component in [JSON valueForKey:@"address_components"]) {
        NSArray *types = [component valueForKey:@"types"];
        id longName = [component valueForKey:@"long_name"];
        id shortName = [component valueForKey:@"short_name"];
        for (NSString *type in types) {
            if ([type isEqualToString:@"postal_code"]) {
                addressDictionary[@"ZIP"] = longName;
            }
            else if ([type isEqualToString:@"country"]) {
                addressDictionary[@"Country"] = longName;
                addressDictionary[@"CountryCode"] = shortName;
            }
            else if ([type isEqualToString:@"administrative_area_level_1"]) {
                addressDictionary[@"State"] = longName;
            }
            else if ([type isEqualToString:@"administrative_area_level_2"]) {
                addressDictionary[@"SubAdministrativeArea"] = longName;
            }
            else if ([type isEqualToString:@"locality"]) {
                addressDictionary[@"City"] = longName;
            }
            else if ([type isEqualToString:@"sublocality"]) {
                addressDictionary[@"SubLocality"] = longName;
            }
            else if ([type isEqualToString:@"establishment"]) {
                addressDictionary[@"Name"] = longName;
            }
            else if ([type isEqualToString:@"route"]) {
                addressDictionary[@"Thoroughfare"] = longName;
            }
            else if ([type isEqualToString:@"street_number"]) {
                addressDictionary[@"SubThoroughfare"] = longName;
            }
        }
    }
    return addressDictionary;
}

- (CLLocationDistance)getDistanceFrom:(CLLocationCoordinate2D)start to:(CLLocationCoordinate2D)end
{
	CLLocation *startLoccation = [[CLLocation alloc] initWithLatitude:start.latitude longitude:start.longitude];
	CLLocation *endLoccation = [[CLLocation alloc] initWithLatitude:end.latitude longitude:end.longitude];
    
	return [startLoccation distanceFromLocation:endLoccation];
}

- (CLLocationCoordinate2D)coordinateFromJSON:(id)JSON
{
    NSDictionary *location = [[JSON valueForKey:@"geometry"] valueForKey:@"location"];
    NSNumber *lat = [location valueForKey:@"lat"];
    NSNumber *lng = [location valueForKey:@"lng"];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
    return coord;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         _dimView.alpha = 0.7f;
     } completion:nil];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSArray *annotations = _mapView.annotations;
    for (id annotation in annotations) {
        if (annotation != _mapView.userLocation) {
            [_mapView removeAnnotation:annotation];
        }
    }
    
    NSString *searchString = [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", searchString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *status = [JSON valueForKeyPath:@"status"];
        NSLog(@"JSON Search: %@", JSON);
        if ([status isEqualToString:@"OK"]) {
            NSArray *results = [JSON valueForKeyPath:@"results"];
            NSInteger index = 0;
            for (id result in results) {
                CLLocationCoordinate2D coord = [self coordinateFromJSON:result];
                NSDictionary *addressDictionary = [self addressDictionaryFromJSON:result];
                if (index == 0) {
                    [_mapView setCenterCoordinate:coord animated:NO];
                }
                MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coord addressDictionary:addressDictionary];
                [_mapView addAnnotation:placemark];
                index++;
            }
        }
    } failure:nil];
    [operation start];
    
    [self finishSearch];
}

- (void)finishSearch
{
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         self.dimView.alpha = 0.0f;
     } completion:nil];
    
    [self.searchBarItem resignFirstResponder];
}


- (IBAction)dimmingViewTapped:(id)sender
{
    [self finishSearch];
}

#pragma mark-

- (void)find:(id)sender
{
    [self queryGooglePlaces:@"bus_station"];
}

-(void) queryGooglePlaces: (NSString *) googleType
{
    CLLocationCoordinate2D centerCoordinate = _mapView.centerCoordinate;
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%d&types=%@&sensor=true&key=%@", centerCoordinate.latitude, centerCoordinate.longitude, self.radius, googleType, kGOOGLE_API_KEY];
    
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* places = [json objectForKey:@"results"];
    
    NSLog(@"Google Data: %@", places);

    [self plotPositions:places];
}

- (void)plotPositions:(NSArray *)data
{
    /*for (id<MKAnnotation> annotation in self.mapView.annotations)
    {
        if ([annotation isKindOfClass:[BusLocation class]])
        {
            [self.mapView removeAnnotation:annotation];
        }
    }*/
    
    NSArray *annotations = _mapView.annotations;
    for (id annotation in annotations) {
        if (annotation != _mapView.userLocation) {
            [_mapView removeAnnotation:annotation];
        }
    }
    
    for (int i=0; i<[data count]; i++)
    {
        NSDictionary* place = [data objectAtIndex:i];
        
        NSDictionary *geo = [place objectForKey:@"geometry"];
        
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        NSDictionary *loc = [geo objectForKey:@"location"];
        
        CLLocationCoordinate2D placeCoord;
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        BusLocation *placeObject = [[BusLocation alloc] initWithName:name address:vicinity coordinate:placeCoord];
        
        [self.mapView addAnnotation:placeObject];
    }
}

@end
