//
//  MapBusViewController.m
//  MapProject2
//
//  Created by Khue TD on 4/11/13.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import "MapBusViewController.h"
#import "BusLocation.h"
#import "ConfigMapViewController.h"
#import "OverlayView.h"

@interface MapBusViewController ()< MKMapViewDelegate,ConfigurationViewControllerDelegate>

@end

@implementation MapBusViewController
@synthesize _mapView, idMapBus;

sqlite3 *DB;
sqlite3_stmt *statement;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapView.delegate = self;
	
    self.mapSource = MapSourceStandard;
    
    [self plotPositions];
}

- (void)viewDidUnload
{
    [self set_mapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Ensure that we can view our own location in the map view.
    [self._mapView setShowsUserLocation:YES];
    
    //Instantiate a location object.
    locationManager = [[CLLocationManager alloc] init];
    
    //Make this controller the delegate for the location manager.
    [locationManager setDelegate:self];
    
    //Set some paramater for the location object.
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    // 1ΩΩ
    /*CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 20.999913;
    zoomLocation.longitude= 105.84535;
    
    // 2
    MKCoordinateSpan span = {.latitudeDelta = 0.02, .longitudeDelta = 0.02};
    
    // 3
    //MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    
    MKCoordinateRegion adjustedRegion = {zoomLocation, span};
	[_mapView setRegion:adjustedRegion animated:YES];
    
    // 4
    [_mapView setRegion:adjustedRegion animated:YES];*/
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)plotPositions
{
    
    for (id<MKAnnotation> annotation in _mapView.annotations)
    {
        [_mapView removeAnnotation:annotation];
    }
    
    // Doc DB va khoi tao
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hn" ofType:@"sqlite"];
    
    if (sqlite3_open_v2([path UTF8String], &DB, SQLITE_OPEN_READWRITE, NULL) == 0){
        
        NSString* firstName = [NSString stringWithFormat: @"SELECT * FROM location WHERE description = %@", idMapBus];
        
        const char *sqlStatement = [firstName UTF8String];
        
        if (sqlite3_prepare_v2(DB, sqlStatement, -1, &statement, NULL) == SQLITE_OK){
            NSInteger index = 0;
            while (sqlite3_step(statement) == SQLITE_ROW){
                NSNumber * latitude = [NSNumber numberWithDouble:sqlite3_column_double(statement, 1)];
                NSNumber * longitude = [NSNumber numberWithDouble:sqlite3_column_double(statement, 2)];
                
                NSString * crimeDescription =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                NSString * address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = latitude.doubleValue;
                coordinate.longitude = longitude.doubleValue;
                
                if (index == 5) {
                    //[_mapView setCenterCoordinate:coordinate animated:NO];
                    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 1500, 1500);
                    [_mapView setRegion:viewRegion animated:YES];
                }
                
                BusLocation *annotation = [[BusLocation alloc] initWithName:crimeDescription address:address coordinate:coordinate] ;
                [_mapView addAnnotation:annotation];
                index++;
            }
        }
    }

    sqlite3_finalize(statement);
    
}

-(IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"BusLocation";
    if ([annotation isKindOfClass:[BusLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image=[UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
            
        } else {
            annotationView.image=[UIImage imageNamed:@"arrest.png"];
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    OverlayView *view = [[OverlayView alloc] initWithOverlay:overlay];
    return view;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Config"]) {
        ConfigMapViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.mapSource = _mapSource;
        controller.mapType = _mapType;
        controller.hidden = YES;
    } 
}

- (void)configurationViewController:(ConfigMapViewController *)controller mapSourceChanged:(MapSource)mapSource
{
    self.mapSource = mapSource;
}

- (void)configurationViewController:(ConfigMapViewController *)controller mapTypeChanged:(MKMapType)mapType
{
    self.mapType = mapType;
}

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

@end
