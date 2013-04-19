//
//  BusViewController.h
//  MapProject2
//
//  Created by Khanhcoc on 18/04/2013.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface BusViewController : UIViewController<UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UITableView *busTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *busSearchBar;
@property (strong) NSArray * aBusMap;
@end
