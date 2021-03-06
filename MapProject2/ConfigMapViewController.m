//
//  ConfigMapViewController.m
//  MapProject2
//
//  Created by Khue TD on 4/9/13.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import "ConfigMapViewController.h"
#import "MapViewController.h"

@interface ConfigMapViewController ()

@end

@implementation ConfigMapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //CGFloat y = _mapSourceControl.frame.origin.y - 18.0f - 46.0f;
    if (self.hidden == NO)
    {
        dropPinButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        dropPinButton.frame = CGRectMake(20.0f, 270, 136.0f, 46.0f);
        dropPinButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [dropPinButton setTitle:NSLocalizedString(@"Drop Pin", nil) forState:UIControlStateNormal];
        [dropPinButton addTarget:self action:@selector(dropPin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:dropPinButton];
        
        printButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        printButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        printButton.frame = CGRectMake(164.0f, 270, 136.0f, 46.0f);
        [printButton setTitle:NSLocalizedString(@"Print", nil) forState:UIControlStateNormal];
        [printButton addTarget:self action:@selector(print:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:printButton];
        
        UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
        if (!controller) {
            printButton.enabled = NO;
        }
        
        self.radiusSlider.value = self.radius;
        self.radiusLabel.text = [NSString stringWithFormat:@"%d", self.radius];
    }
    else
    {
        self.radiusSlider.hidden = YES;
        self.radiusLabel.hidden = YES;
        self.miscellaneousLabel1.hidden = YES;
        self.miscellaneousLabel2.hidden = YES;
    }
        
    [_mapSourceControl setTitle:NSLocalizedString(@"Standard", nil) forSegmentAtIndex:0];
    [_mapSourceControl setTitle:NSLocalizedString(@"Classic", nil) forSegmentAtIndex:1];
    _mapSourceControl.selectedSegmentIndex = _mapSource;
    
    [_mapTypeControl setTitle:NSLocalizedString(@"Map", nil) forSegmentAtIndex:0];
    [_mapTypeControl setTitle:NSLocalizedString(@"Satellite", nil) forSegmentAtIndex:1];
    [_mapTypeControl setTitle:NSLocalizedString(@"Hybrid", nil) forSegmentAtIndex:2];
    _mapTypeControl.selectedSegmentIndex = _mapType;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    dropPinButton = nil;
    printButton = nil;
    self.mapSourceControl = nil;
    self.mapTypeControl = nil;
    [super viewDidUnload];
}

- (IBAction)radiusChange:(id)sender
{
    self.radiusLabel.text = [NSString stringWithFormat:@"%d", (int) self.radiusSlider.value];
}

- (IBAction)radiusDidChange:(id)sender
{
    if ([_delegate respondsToSelector:@selector(configurationViewController:radiusChanged:)])
    {
        [_delegate configurationViewController:self radiusChanged:(int)self.radiusSlider.value];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropPin:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         if ([_delegate respondsToSelector:@selector(configurationViewControllerWillAddPin:)]) {
             [_delegate configurationViewControllerWillAddPin:self];
         }
     }];
}

- (void)print:(id)sender
{
    if ([_delegate respondsToSelector:@selector(configurationViewControllerWillPrintMap:)]) {
        [_delegate configurationViewControllerWillPrintMap:self];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)mapSourceChanged:(id)sender
{
    if ([_delegate respondsToSelector:@selector(configurationViewController:mapSourceChanged:)]) {
        [_delegate configurationViewController:self mapSourceChanged:_mapSourceControl.selectedSegmentIndex];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)mapTypeChanged:(id)sender
{
    if ([_delegate respondsToSelector:@selector(configurationViewController:mapTypeChanged:)]) {
        [_delegate configurationViewController:self mapTypeChanged:_mapTypeControl.selectedSegmentIndex];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
