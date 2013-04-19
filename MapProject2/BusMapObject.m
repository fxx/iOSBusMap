//
//  BusMapObject.m
//  MapProject2
//
//  Created by Khue TD on 3/24/13.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import "BusMapObject.h"

@implementation BusMapObject

@synthesize iID_Bus, sBusNumber, sName, sBusGoto, sBusReturn, sBusCompany, sBusBegin, sBusFinish, sBusType, sBusPrice;

-(id)initWithBus:(int)id_Bus
                :(NSString *)busNumber
                :(NSString *)busName
                :(NSString *)busGoto
                :(NSString *)busReturn
                :(NSString *)busCompany
                :(NSString *)busBegin
                :(NSString *)busFinish
                :(NSString *)busType
                :(NSString *)busPrice
{
    self = [super init];
    if (self)
    {
        self.iID_Bus    = id_Bus;
        self.sBusNumber = busNumber;
        self.sName      = busName;
        self.sBusGoto   = busGoto;
        self.sBusReturn = busReturn;
        self.sBusCompany= busCompany;
        self.sBusBegin = busBegin;
        self.sBusFinish = busFinish;
        self.sBusType   = busType;
        self.sBusPrice  = busPrice;
    }
    return self;
}

@end
