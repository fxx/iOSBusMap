//
//  BusLocation.h
//  MapProject2
//
//  Created by Khue TD on 4/11/13.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BusLocation : NSObject<MKAnnotation> {
    NSString *_name;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

//- (MKMapItem*)mapItem;

@end
