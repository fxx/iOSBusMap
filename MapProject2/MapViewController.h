//
//  MapViewController.h
//  MapProject2
//
//  Created by Khue TD on 3/27/13.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Overlay.h"


@interface MapViewController : UIViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startingPoint;

@property (assign, nonatomic) MKMapType mapType;
@property (assign, nonatomic) MapSource mapSource;

@property (strong, nonatomic) Overlay *overlay;

@property (nonatomic, assign) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *dimView;

@property (retain, nonatomic) IBOutlet UIToolbar *topToolBar;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;

@property (retain, nonatomic) IBOutlet UISearchBar *searchBarItem;

- (IBAction)dimmingViewTapped:(id)sender;
@end
