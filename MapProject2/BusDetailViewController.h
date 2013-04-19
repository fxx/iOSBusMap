//
//  BusDetailViewController.h
//  MapProject2
//
//  Created by Khanhcoc on 18/04/2013.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusMapObject.h"

@interface BusDetailViewController : UIViewController{
    UILabel *lsBusNumber, *lBusNumber, *lsTimeBegin, *lTimeBegin, *lsTimeFinish, *lTimeFinish, *lsBusType, *lBusType, *lsBusPrice, *lBusPrice, *lsBusGoto, *lBusGoto, *lsBusReturn, *lBusReturn;
    
    UIImage *iBusNumber, *iTimeBegin, *iTimeFinish, *iBustype, *iBusPrice, *iBusGoto, *iBusReturn;
    
    UIImageView *ivBusNumber, *ivTimeBegin, *ivTimeFinish, *ivBustype, *ivBusPrice, *ivBusGoto, *ivBusReturn;
    
    UITextView *tBusGoto, *tBusReturn;
}
@property(strong) BusMapObject *busO;
@property (weak, nonatomic) IBOutlet UIScrollView *myScroll;

@end
