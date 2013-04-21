//
//  MapBusViewController.h
//  MapProject2
//
//  Created by Khue TD on 4/11/13.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <sqlite3.h>
#import <CoreLocation/CoreLocation.h>
#import "Overlay.h"


@interface MapBusViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    
    CLLocationCoordinate2D currentCentre;
    int currenDist;
    BOOL firstLaunch;
}
@property (assign, nonatomic) MKMapType mapType;
@property (assign, nonatomic) MapSource mapSource;

@property (strong, nonatomic) Overlay *overlay;

@property (assign, nonatomic) NSString *idMapBus;

-(IBAction)cancel:(id)sender;

@property (weak, nonatomic) IBOutlet MKMapView *_mapView;

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation;

@end
