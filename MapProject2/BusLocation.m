//
//  BusLocation.m
//  MapProject2
//
//  Created by Khue TD on 4/11/13.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import "BusLocation.h"
#import <AddressBook/AddressBook.h>

@implementation BusLocation

@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        if ([name isKindOfClass:[NSString class]]) {
            _name = [name copy];
        } else {
            _name = @"Unknown charge";
        }
 
        _address = [address copy];
        _coordinate = coordinate;
    }
    return self;
}


- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return _name;
}

- (NSString *)subtitle {
    return _address;
}

- (CLLocationCoordinate2D)coordinate {
    return _coordinate;
}

//- (MKMapItem*)mapItem {
//    
//    
//    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
//
//    
//    MKPlacemark *placemark = [[MKPlacemark alloc]
//                              initWithCoordinate:self.coordinate
//                              addressDictionary:addressDict];
//    
//    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
//    mapItem.name = self.title;
//    return mapItem;
//}

@end
