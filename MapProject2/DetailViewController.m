//
//  DetailViewController.m
//  MapProject2
//
//  Created by Khue TD on 4/18/13.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString(@"Info", nil);
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    _headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _titleLabel.text = [NSString stringWithFormat:@"<%g/%g>", _placemark.coordinate.latitude, _placemark.coordinate.longitude];
    _addressTitleLabel.text = NSLocalizedString(@"Address", nil);
    NSArray *addressLines = [_placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
    if (addressLines) {
        _addressLabel.text = [addressLines componentsJoinedByString:@", "];
    }
    else {
        _addressLabel.text = ABCreateStringWithAddressDictionary(_placemark.addressDictionary, YES);
    }
    
    _removePinLabel.text = NSLocalizedString(@"Remove Pin", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setHeaderView:nil];
    [self setTitleLabel:nil];
    [self setAddressLabel:nil];
    [self setAddressTitleLabel:nil];
    [self setRemovePinLabel:nil];
    [super viewDidUnload];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [_mapView removeAnnotation:_placemark];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
