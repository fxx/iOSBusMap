//
//  ConfigMapViewController.h
//  MapProject2
//
//  Created by Khue TD on 4/9/13.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Overlay.h"


@protocol ConfigurationViewControllerDelegate;

@interface ConfigMapViewController : UIViewController
{
    UIButton *dropPinButton;
    UIButton *printButton;
}

@property (strong, nonatomic) id<ConfigurationViewControllerDelegate> delegate;

@property (assign, nonatomic) MapSource mapSource;
@property (assign, nonatomic) MKMapType mapType;
@property (assign, nonatomic) int radius;

@property (assign, nonatomic) BOOL hidden;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (weak, nonatomic) IBOutlet UILabel *miscellaneousLabel1;
@property (weak, nonatomic) IBOutlet UILabel *miscellaneousLabel2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapSourceControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeControl;

@end

@protocol ConfigurationViewControllerDelegate <NSObject>

- (void)configurationViewController:(ConfigMapViewController *)controller mapSourceChanged:(MapSource)mapSource;
- (void)configurationViewController:(ConfigMapViewController *)controller mapTypeChanged:(MKMapType)mapType;

@optional

- (void)configurationViewControllerWillAddPin:(ConfigMapViewController *)controller;
- (void)configurationViewControllerWillPrintMap:(ConfigMapViewController *)controller;
- (void)configurationViewController:(ConfigMapViewController *)controller radiusChanged:(int)radius;

@end
