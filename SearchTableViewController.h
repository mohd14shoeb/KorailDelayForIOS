//
//  SearchTableViewController.h
//  Korail
//
//  Created by Jun-Young Lee on 2014. 5. 4..
//  Copyright (c) 2014년 Jun-Young Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearchDepartureStationTableViewController.h"
#import "SearchArrivalStationTableViewController.h"
#import "ResultTableViewController.h"

NSString *query;

@interface SearchTableViewController : UITableViewController<SearchDepartureStation>

@property (weak, nonatomic) IBOutlet UILabel *train;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *departureStation;
@property (weak, nonatomic) IBOutlet UILabel *arrivalStation;

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDate *selectedTime;

-(void)selectedDepartureStation:(NSString *)station;
-(void)selectedArrivalStation:(NSString *)station;

@end
