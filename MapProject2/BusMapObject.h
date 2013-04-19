//
//  BusMapObject.h
//  MapProject2
//
//  Created by Khue TD on 3/24/13.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusMapObject : NSObject{
    
}

@property int iID_Bus;
@property(strong)NSString *sBusNumber;
@property(strong)NSString *sName;
@property(strong)NSString *sBusCompany;
@property NSString *sBusGoto, *sBusReturn, *sBusBegin, *sBusFinish, *sBusType, *sBusPrice;


-(id)initWithBus:(int)id_Bus
                :(NSString *)busNumber
                :(NSString *)busName
                :(NSString *)busGoto
                :(NSString *)busReturn
                :(NSString *)busCompany
                :(NSString *)busBegin
                :(NSString *)busFinish
                :(NSString *)busType
                :(NSString *)busPrice;

@end
