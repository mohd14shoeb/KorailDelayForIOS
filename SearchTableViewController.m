//
//  SearchTableViewController.m
//  Korail
//
//  Created by Jun-Young Lee on 2014. 5. 4..
//  Copyright (c) 2014년 Jun-Young Lee. All rights reserved.
//

#import "SearchTableViewController.h"
#import "Stations.h"

UIDatePicker *datePicker;

@implementation SearchTableViewController

@synthesize train;
@synthesize dateTime;
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
    [self setCurrentDateTime];
//    UIBarButtonItem *displayResultItem = [[UIBarButtonItem alloc] initWithTitle:@"검색" style:UIBarButtonItemStylePlain target:self action:@selector(displayResult:)];
//    self.navigationItem.rightBarButtonItem = displayResultItem;
    [super viewDidLoad];
}

- (void)selectedDepartureStation:(NSString *)station
{
    departureStation.text = station;
}

- (void)selectedArrivalStation:(NSString *)station
{
    arrivalStation.text = station;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
        // actionsheet - 날짜 & 시간
        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
        UIActionSheet *dateTimeActionSheet;
        dateTimeActionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"", @"")] delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"선택", nil];
        [dateTimeActionSheet showInView:self.view];
        datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [dateTimeActionSheet addSubview:datePicker];
    }
    else if (indexPath.row == 2) {
        SearchDepartureStationTableViewController *searchDepartureStationView = [[SearchDepartureStationTableViewController alloc] init];
        [searchDepartureStationView setDelegate:self];
        [[self navigationController] pushViewController:searchDepartureStationView animated:YES];
    }
    else if (indexPath.row == 3) {
        SearchArrivalStationTableViewController *searchArrivalStationView = [[SearchArrivalStationTableViewController alloc] init];
        [searchArrivalStationView setDelegate:self];
        [[self navigationController] pushViewController:searchArrivalStationView animated:YES];
    }
    /////////////////////////////////////////////
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

// 확인이 0
- (void)actionSheet:(UIActionSheet *)trainActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        NSDate *date = datePicker.date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd a hh:mm"];
        NSString* dateString = [dateFormatter stringFromDate:date];
        dateTime.text = dateString;
    }
}

- (void)setCurrentDateTime
{
    NSDateFormatter *today = [[NSDateFormatter alloc] init];
    [today setDateFormat:@"yyyy/MM/dd a hh:mm"];
    NSString *currentDateTime = [today stringFromDate:[NSDate date]];
    dateTime.text = currentDateTime;
}

// 파싱 후 전역변수에 주소담고 결과 받아오고 파싱.
//- (IBAction)displayResult:(id)sender
- (NSString *)setQuery
{
    NSString *trainForResult = self.train.text;
    NSString *dateTimeForResult = self.dateTime.text;
    NSString *departureStationForResult = self.departureStation.text;
    NSString *arrivalStationForResult = self.arrivalStation.text;
    
    NSString *trainResult = [self getTrain:trainForResult];
    NSString *dateResult = [self getDate:dateTimeForResult];
    NSString *timeResult = [self getTime:dateTimeForResult];
    NSString *departureStationResult = [self getDepartureStation:departureStationForResult];
    NSString *arrivalStationResult = [self getArrivalStation:arrivalStationForResult];
    
    // "http://14.63.219.205:8000/searchTrain/?train=" + train + "&date=" + date + "&time=" + time + "&dep=" + dep + "&arr=" + arr;
    query = nil;
    query = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@", @"http://14.63.219.205:8000/searchTrain/?train=", trainResult,
             @"&date=", dateResult, @"&time=", timeResult, @"&dep=", departureStationResult, @"&arr=", arrivalStationResult];
    
    //ResultTableViewController *resultController = [[ResultTableViewController alloc] init];
    //[[self navigationController] pushViewController:resultController animated:YES];
    
    return query;
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

- (NSString *)getDate:(NSString *)dateTimeForResult
{
    NSArray *resultArray = [dateTimeForResult componentsSeparatedByString:@" "];
    NSString *date = [resultArray objectAtIndex:0];
    
    NSArray *dateArray = [date componentsSeparatedByString:@"/"];
    NSString *year = [dateArray objectAtIndex:0];
    NSString *month = [dateArray objectAtIndex:1];
    NSString *day = [dateArray objectAtIndex:2];
    
    NSString *dateResult = [NSString stringWithFormat:@"%@%@%@", year, month, day];
    
    return dateResult;
}

// time : 오전 12:10, 오후 07:10
- (NSString *)getTime:(NSString *)dateTimeForResult
{
    NSString *resultHour = nil;
    NSString *resultMinute = nil;
    NSArray *resultArray = [dateTimeForResult componentsSeparatedByString:@" "];
    NSString *ampm = [resultArray objectAtIndex:1];
    NSString *time = [resultArray objectAtIndex:2];
    NSArray *timeResultArray = [time componentsSeparatedByString:@":"];
    NSString *hour = [timeResultArray objectAtIndex:0];
    NSString *minute = [timeResultArray objectAtIndex:1];
    int iHour = [hour intValue];
    int iMinute = [minute intValue];
    
    if ([ampm isEqualToString:@"오전"]) {
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

- (NSString *)getDepartureStation:(NSString *)departureStationForResult
{
    NSString *departureStationResult = [nameCodeStations objectForKey:departureStationForResult];
    return departureStationResult;
}

- (NSString *)getArrivalStation:(NSString *)arrivalStationForResult
{
    NSString *arrivalStationResult = [nameCodeStations objectForKey:arrivalStationForResult];
    return arrivalStationResult;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"resultSegue"]) {
        ResultTableViewController *controller = segue.destinationViewController;
        controller.query = [self setQuery];
    }
}

@end
