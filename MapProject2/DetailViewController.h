//
//  DetailViewController.h
//  MapProject2
//
//  Created by Khue TD on 4/18/13.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <iAd/iAd.h>

@interface DetailViewController : UITableViewController

@property (weak, nonatomic) MKMapView *mapView;
@property (weak, nonatomic) MKPlacemark *placemark;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *removePinLabel;

@end
