//
//  ResultTableViewController.m
//  Korail
//
//  Created by Jun-Young Lee on 2014. 5. 7..
//  Copyright (c) 2014년 Jun-Young Lee. All rights reserved.
//

#import "ResultTableViewController.h"
#import "Train.h"
#import "CustomTableViewCell.h"

@implementation ResultTableViewController

@synthesize query;

extern NSMutableArray *trainList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = @"조회 결과";
    
    [self searchTrain];
    [self searchOtherInformation];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)searchTrain
{
    NSError *error;
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:query]];
    if (data == NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"조회 결과가 없습니다." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
        return;
    }
    NSMutableDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    trainList = [NSMutableArray arrayWithCapacity:30];
    
    for (NSDictionary *data in dataDictionary) {
        Train *t = [[Train alloc] init];
        [t setTrainType:data[@"train_type"]];
        [t setTrainNumber:data[@"train_number"]];
        [t setDepCode:data[@"dep_code"]];
        [t setDepDate:data[@"dep_date"]];
        [t setDepTime:data[@"dep_time"]];
        [t setArrCode:data[@"arr_code"]];
        [t setArrDate:data[@"arr_date"]];
        [t setArrTime:data[@"arr_time"]];
        
        [trainList addObject:t];
    }
}

//[t setTrainStatus:data[@"train_status"]];
//[t setTrainDelayStatus:data[@"train_delay_status"]];
- (void)searchOtherInformation
{
    NSString *query2 = nil;
    
    NSString *depDate = [trainList[0] depDate];
    query2 = [NSString stringWithFormat:@"%@%@", @"http://221.166.154.113:8080/searchDelay/?date=", depDate];
    
    for (Train *t in trainList) {
       query2 = [NSString stringWithFormat:@"%@%@%@", query2, @"&train_number=", t.trainNumber];
    }
    
    NSError *error;
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:query2]];
    if (data == NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"조회 결과가 없습니다." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
        return;
    }
    NSMutableDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    for (NSDictionary *data in dataDictionary) {
        NSString *train_number = data[@"train_number"];
        NSString *train_location = data[@"train_location"];
        NSString *train_delay_time = data[@"train_delay_time"];
        
        for (Train * t in trainList) {
            if ([t.trainNumber isEqualToString:train_number]) {
                [t setTrainLocation:train_location];
                [t setTrainDelayTime:train_delay_time];
            }
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"   열차       출발     도착     위치        지연";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    Train *t = [trainList objectAtIndex:indexPath.row];
    
    [cell.trainType setText:t.getTrainType];
    [cell.trainNumber setText:t.trainNumber];
    [cell.departureStation setText:t.getDepCode];
    [cell.departureTime setText:t.depTime];
    [cell.arrivalStation setText:t.arrCode];
    [cell.arrivalTime setText:t.arrTime];
    [cell.trainLocation setText:t.trainLocation];
    [cell.trainDelayTime setText:t.trainDelayTime];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [trainList count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 파일입출력 ? DB ?
    // 열차 정보 저장하기.
}

@end
