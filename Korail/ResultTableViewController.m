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
        [t setTrainStatus:data[@"train_status"]];
        [t setTrainDelayStatus:data[@"train_delay_status"]];
            
        [trainList addObject:t];
    }
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"    열차            출발       도착       위치            지연";
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
    [cell.trainLocation setText:t.trainStatus];
    [cell.trainDelayTime setText:t.trainDelayStatus];
    
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
    
    Train *t = [trainList objectAtIndex:indexPath.row];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [alertView firstOtherButtonIndex])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
