//
//  SearchTableViewController.m
//  Korail
//
//  Created by Jun-Young Lee on 2014. 5. 4..
//  Copyright (c) 2014년 Jun-Young Lee. All rights reserved.
//

#import "SearchTableViewController.h"
#import "Stations.h"
#import "ActionSheetPicker-3.0/Pickers/ActionSheetDatePicker.h"

@implementation SearchTableViewController

@synthesize train;
@synthesize date;
@synthesize time;
@synthesize departureStation;
@synthesize arrivalStation;

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
    Stations *stations = [[Stations alloc] init];
    [stations initCodeNameStations];
    [stations initNameCodeStations];
    
    self.selectedDate = [NSDate date];
    self.selectedTime = [NSDate date];
    
    [self setCurrentDateTime];

    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setCurrentDateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"a hh:mm"];
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
    
    date.text = currentDate;
    time.text = currentTime;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /////////////// delegate 설정. ///////////////
    if (indexPath.row == 0) {
        // actionsheet - 열차 종류
        UIAlertView *trainAlertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"전체", @"KTX", @"새마을호", @"무궁화호", @"통근열차", @"누리로", @"공항철도", @"ITX-새마을", @"ITX-청춘", nil];
        [trainAlertView show];
    }
    else if (indexPath.row == 1) {
        UILabel * sender = nil;
        
        AbstractActionSheetPicker* datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate target:self action:@selector(dateWasSelected:element:) origin:sender];
        datePicker.hideCancel = YES;
        [datePicker showActionSheetPicker];
    }
    else if (indexPath.row == 2) {
        UILabel * sender = nil;
        
        ActionSheetDatePicker *timePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeTime selectedDate:[NSDate date] target:self action:@selector(timeWasSelected:element:) origin:sender];
        timePicker.hideCancel = YES;
        timePicker.minuteInterval = 1;
        [timePicker showActionSheetPicker];

    }
    else if (indexPath.row == 3) {
        SearchDepartureStationTableViewController *searchDepartureStationView = [[SearchDepartureStationTableViewController alloc] init];
        [searchDepartureStationView setDelegate:self];
        [[self navigationController] pushViewController:searchDepartureStationView animated:YES];
    }
    else if (indexPath.row == 4) {
        SearchArrivalStationTableViewController *searchArrivalStationView = [[SearchArrivalStationTableViewController alloc] init];
        [searchArrivalStationView setDelegate:self];
        [[self navigationController] pushViewController:searchArrivalStationView animated:YES];
    }
}

// 취소가 0
- (void)alertView:(UIAlertView *)trainAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
        return;
    else if (buttonIndex == 1)
        train.text = @"전체";
    else if (buttonIndex == 2)
        train.text = @"KTX";
    else if (buttonIndex == 3)
        train.text = @"새마을호";
    else if (buttonIndex == 4)
        train.text = @"무궁화호";
    else if (buttonIndex == 5)
        train.text = @"통근열차";
    else if (buttonIndex == 6)
        train.text = @"누리로";
    else if (buttonIndex == 7)
        train.text = @"공항철도";
    else if (buttonIndex == 8)
        train.text = @"ITX-새마을";
    else if (buttonIndex == 9)
        train.text = @"ITX-청춘";
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.selectedDate = selectedDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    self.date.text = [dateFormatter stringFromDate:selectedDate];
}

-(void)timeWasSelected:(NSDate *)selectedTime element:(id)element {
    self.selectedTime = selectedTime;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"a hh:mm"];
    self.time.text = [dateFormatter stringFromDate:selectedTime];
}

- (void)selectedDepartureStation:(NSString *)station
{
    departureStation.text = station;
}

- (void)selectedArrivalStation:(NSString *)station
{
    arrivalStation.text = station;
}

// 파싱 후 전역변수에 주소담고 결과 받아오고 파싱.
- (NSString *)setQuery
{
    NSString *trainForResult = self.train.text;
    NSString *dateForResult = self.date.text;
    NSString *timeForResult = self.time.text;
    NSString *departureStationResult = self.departureStation.text;
    NSString *arrivalStationResult = self.arrivalStation.text;
    
    NSString *trainResult = [self getTrain:trainForResult];
    NSString *dateResult = [self getDate:dateForResult];
    NSString *timeResult = [self getTime:timeForResult];
    
    // "http://221.166.154.113:8080/searchTrain/?train=" + train + "&date=" + date + "&time=" + time + "&dep=" + dep + "&arr=" + arr;
    query = nil;
    query = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@", @"http://221.166.154.113:8080/searchTrain/?train=", trainResult, @"&date=", dateResult, @"&time=", timeResult, @"&dep=", departureStationResult, @"&arr=", arrivalStationResult];
    
    NSString *encodedQuery = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return encodedQuery;
}

- (NSString *)getTrain:(NSString *)trainForResult
{
    NSString *trainResult = nil;
    
    if([trainForResult isEqualToString:@"전체"])
        trainResult = @"05";
    else if([trainForResult isEqualToString:@"KTX"])
        trainResult = @"00";
    else if([trainForResult isEqualToString:@"새마을호"])
        trainResult = @"01";
    else if([trainForResult isEqualToString:@"무궁화호"])
        trainResult = @"02";
    else if([trainForResult isEqualToString:@"통근열차"])
        trainResult = @"03";
    else if([trainForResult isEqualToString:@"누리로"])
        trainResult = @"04";
    else if([trainForResult isEqualToString:@"공항철도"])
        trainResult = @"06";
    else if([trainForResult isEqualToString:@"ITX-새마을"])
        trainResult = @"08";
    else if([trainForResult isEqualToString:@"ITX-청춘"])
        trainResult = @"09";

    return trainResult;
}

- (NSString *)getDate:(NSString *)dateForResult
{
    NSArray *dateArray = [dateForResult componentsSeparatedByString:@"/"];
    NSString *year = [dateArray objectAtIndex:0];
    NSString *month = [dateArray objectAtIndex:1];
    NSString *day = [dateArray objectAtIndex:2];
    
    NSString *dateResult = [NSString stringWithFormat:@"%@%@%@", year, month, day];
    
    return dateResult;
}

// time : 10:29 PM
- (NSString *)getTime:(NSString *)timeForResult
{
    NSString *resultHour = nil;
    NSString *resultMinute = nil;
    
    NSArray *resultArray = [timeForResult componentsSeparatedByString:@" "];
    NSString *ampm = [resultArray objectAtIndex:0];
    NSString *tempTime = [resultArray objectAtIndex:1];
    
    NSArray *timeResultArray = [tempTime componentsSeparatedByString:@":"];
    NSString *hour = [timeResultArray objectAtIndex:0];
    NSString *minute = [timeResultArray objectAtIndex:1];
    int iHour = [hour intValue];
    int iMinute = [minute intValue];
    
    if ([ampm isEqualToString:@"AM"]) {
        if (iHour == 12)
            iHour = 0;
    }
    else {
        iHour = iHour + 12;
        if (iHour == 24)
            iHour = iHour - 12;
    }
    
    if (iHour < 10)
        resultHour = [NSString stringWithFormat:@"%@%d", @"0", iHour];
    else
        resultHour = [NSString stringWithFormat:@"%d", iHour];
    
    if (iMinute < 10)
        resultMinute = [NSString stringWithFormat:@"%@%d", @"0", iMinute];
    else
        resultMinute = [NSString stringWithFormat:@"%d", iMinute];
    
    NSString *resultTime = [NSString stringWithFormat:@"%@%@%@", resultHour, resultMinute, @"00"];
    
    return resultTime;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"resultSegue"]) {
        ResultTableViewController *controller = segue.destinationViewController;
        controller.query = [self setQuery];
    }
}

@end
