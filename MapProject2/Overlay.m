//
//  Overlay.m
//  MapProject2
//
//  Created by Khue TD on 4/10/13.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import "Overlay.h"

@implementation Overlay

- (id)initWithMapType:(MKMapType)mapType
{
    if (self = [super init]) {
        _mapType = mapType;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMidX(MKMapRectWorld), MKMapRectGetMidY(MKMapRectWorld)));
}

- (MKMapRect)boundingMapRect {
    return MKMapRectWorld;
}

- (NSURL *)imageURLWithTilePath:(NSString *)path {
    u_int32_t random = arc4random_uniform(2);
    NSString *s = nil;
    switch (_mapType) {
        case MKMapTypeStandard:
            s = [NSString stringWithFormat:@"http://mt%d.google.com/vt/%@", random, path];
            break;
            
        case MKMapTypeSatellite:
            s = [NSString stringWithFormat:@"http://khm%d.google.com/kh/v=117&%@", random, path];
            break;
            
        case MKMapTypeHybrid:
            s = [NSString stringWithFormat:@"http://mt%d.google.com/vt/lyrs=y&%@", random, path];
            break;
            
        default:
            break;
    }
    
    return [NSURL URLWithString:s];
}

@end
