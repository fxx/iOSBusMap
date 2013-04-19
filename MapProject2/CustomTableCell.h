//
//  CustomTableCell.h
//  MapProject2
//
//  Created by Khanhcoc on 01/04/2013.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableCell : UITableViewCell
{
    UILabel *lBusNumber;
    UILabel *lBusName;
    UILabel *lBusCompany;
}

@property (nonatomic, retain) IBOutlet UILabel *lBusNumber, *lBusName, *lBusCompany;

@end
