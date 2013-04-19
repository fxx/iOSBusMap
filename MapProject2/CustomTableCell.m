//
//  CustomTableCell.m
//  MapProject2
//
//  Created by Khanhcoc on 01/04/2013.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import "CustomTableCell.h"

@implementation CustomTableCell;
@synthesize lBusCompany,lBusName,lBusNumber;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
