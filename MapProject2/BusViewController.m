//
//  BusViewController.m
//  MapProject2
//
//  Created by Khanhcoc on 18/04/2013.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import "BusViewController.h"
#import "CustomTableCell.h"
#import "BusDetailViewController.h"
#import "BusMapObject.h"

@interface BusViewController ()
{
    NSMutableArray *busObj;
    NSMutableArray *busFilterObj;
    BOOL bFilter;
}

@end

@implementation BusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Doc DB va khoi tao table cell
    self.busSearchBar.delegate = self;
    self.busTableView.delegate = self;
    self.busTableView.dataSource = self;
    
    // [self.busSearchBar setShowsScopeBar:YES];
    sqlite3 *DB;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hn" ofType:@"sqlite"];
    busObj = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_open_v2([path UTF8String], &DB, SQLITE_OPEN_READWRITE, NULL) == 0)
    {
        
        if (sqlite3_prepare_v2(DB, "SELECT * FROM data", -1, &statement, NULL) == SQLITE_OK)
        {
            int ID = 1;
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                BusMapObject *bus = [[BusMapObject alloc]initWithBus
                                     :ID
                                     :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]
                                     :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]
                                     :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]
                                     :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]
                                     :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]
                                     :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]
                                     :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]
                                     :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]
                                     :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)]];
                [busObj addObject:bus];
                ID++;
            }
        }
    }
    sqlite3_finalize(statement);
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        bFilter = NO;
    }
    else
    {
        bFilter = YES;
        busFilterObj = [[NSMutableArray alloc] init];
        
        sqlite3 *DB;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"hn" ofType:@"sqlite"];
        busFilterObj = [[NSMutableArray alloc] init];
        
        sqlite3_stmt *statement;
        if (sqlite3_open_v2([path UTF8String], &DB, SQLITE_OPEN_READWRITE, NULL) == 0)
        {
            NSString *sSQL =[NSString stringWithFormat:@"SELECT * FROM data where _goto like '%@%@%@' or _return like '%@%@%@' or goto like '%@%@%@' or return like '%@%@%@'", @"\%", searchText, @"\%", @"\%", searchText, @"\%", @"\%", searchText, @"\%",@"\%", searchText, @"\%" ];
            //  sSQL%
            
            const char *sql1 = [sSQL UTF8String];
            int err = sqlite3_prepare_v2(DB, sql1, -1, &statement, NULL);
            
            if (err == SQLITE_OK)
            {
                int ID = 1;
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    BusMapObject *bus = [[BusMapObject alloc]initWithBus
                                         :ID
                                         :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]
                                         :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]
                                         :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]
                                         :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]
                                         :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]
                                         :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]
                                         :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]
                                         :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]
                                         :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)]];
                    [busFilterObj addObject:bus];
                    ID++;
                }
            }
        }
        sqlite3_finalize(statement);
    }
    [self.busTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    bFilter = NO;
    [self.busTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Search");
    [self.busSearchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (bFilter) {
        return [busFilterObj count];
    }
    
    return [busObj count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    CustomTableCell *cell = [self.busTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (bFilter)
    {
        BusMapObject*bus = [busFilterObj objectAtIndex:indexPath.row];
        cell.lBusNumber.text    = bus.sBusNumber;
        cell.lBusName.text      = bus.sName;
        cell.lBusCompany.text   = bus.sBusCompany;
        
    }
    else
    {
        BusMapObject*bus = [busObj objectAtIndex:indexPath.row];
        cell.lBusNumber.text    = bus.sBusNumber;
        cell.lBusName.text      = bus.sName;
        cell.lBusCompany.text   = bus.sBusCompany;
    }
    
    return cell;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 55;
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"abc"]) {
        BusDetailViewController * busdetail = (BusDetailViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = nil;
        
        if (bFilter) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            BusMapObject *bO = [busFilterObj objectAtIndex:indexPath.row];
            busdetail.busO = bO;
        }
        else
        {
            indexPath = [self.busTableView indexPathForSelectedRow];
            BusMapObject *bO = [busObj objectAtIndex:indexPath.row];
            busdetail.busO = bO;
        }
        
    }
}

@end
