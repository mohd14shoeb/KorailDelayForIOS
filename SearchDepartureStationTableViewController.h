//
//  SearchDepartureStationTableViewController.h
//  Korail
//
//  Created by Jun-Young Lee on 2014. 5. 7..
//  Copyright (c) 2014년 Jun-Young Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDepartureStation <NSObject>

-(void)selectedDepartureStation:(NSString *)station;

@end

@interface SearchDepartureStationTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;

@property id<SearchDepartureStation> delegate;

@end