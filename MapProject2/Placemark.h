//
//  Placemark.h
//  MapProject2
//
//  Created by Khue TD on 4/14/13.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface Placemark : MKPlacemark

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readwrite, copy) NSDictionary *addressDictionary;

@end
