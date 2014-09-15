//
//  SearchArrivalStationTableViewController.h
//  Korail
//
//  Created by Jun-Young Lee on 2014. 5. 14..
//  Copyright (c) 2014년 Jun-Young Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchArrivalStation <NSObject>

-(void)selectedArrivalStation:(NSString *)station;

@end

@interface SearchArrivalStationTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;

@property id<SearchArrivalStation> delegate;

@end
