//
//  SearchArrivalStationTableViewController.m
//  Korail
//
//  Created by Jun-Young Lee on 2014. 5. 14..
//  Copyright (c) 2014년 Jun-Young Lee. All rights reserved.
//

#import "SearchArrivalStationTableViewController.h"

BOOL isSearching;
NSMutableArray *searchResults;

@implementation SearchArrivalStationTableViewController

@synthesize delegate;
@synthesize searchBar;
@synthesize searchController;

extern NSMutableDictionary *nameCodeStations;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = @"도착역 검색";
    
    searchBar = [[UISearchBar alloc] init];
    searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
    searchController.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    
    isSearching = NO;
    searchResults = [[NSMutableArray alloc] init];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)filterContentForSearchText:(NSString *)searchText
{
    [searchResults removeAllObjects];
    
    NSArray *keys = [[nameCodeStations allKeys] sortedArrayUsingSelector:@selector(localizedCompare:)];
    
    for(NSString *result in keys) {
        NSRange nameRange = [result rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if(nameRange.location != NSNotFound)
            [searchResults addObject:result];
    }
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)searchController
{
    isSearching = YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)searchController
{
    isSearching = NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching)
        return [searchResults count];
    else
        return [nameCodeStations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    NSString *stationName;
    if (isSearching && [searchResults count])
        stationName = [searchResults objectAtIndex:indexPath.row];
    else {
        NSArray *keys = [[nameCodeStations allKeys] sortedArrayUsingSelector:@selector(localizedCompare:)];
        stationName = [keys objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = stationName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *stationName;
    if (isSearching && [searchResults count])
        stationName = [searchResults objectAtIndex:indexPath.row];
    else
        stationName = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    [self.delegate selectedArrivalStation:stationName];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
