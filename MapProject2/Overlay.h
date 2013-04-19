//
//  Overlay.h
//  MapProject2
//
//  Created by Khue TD on 4/10/13.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

enum {
    MapSourceStandard = 0,
    MapSourceGoogle
};
typedef NSUInteger MapSource;

@interface Overlay : NSObject<MKOverlay>

@property (nonatomic, readonly) MKMapType mapType;

- (id)initWithMapType:(MKMapType)mapType;
- (NSURL *)imageURLWithTilePath:(NSString *)path;

@end
