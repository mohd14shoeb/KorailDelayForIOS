//
//  Train.m
//  Korail
//
//  Created by Jun-Young Lee on 2014. 5. 15..
//  Copyright (c) 2014년 Jun-Young Lee. All rights reserved.
//

#import "Train.h"

@implementation Train

@synthesize trainType;
@synthesize trainNumber;
@synthesize depCode;
@synthesize depDate;
@synthesize depTime;
@synthesize arrCode;
@synthesize arrDate;
@synthesize arrTime;
@synthesize trainLocation;
@synthesize trainDelayTime;

extern NSMutableDictionary *codeNameStations;

- (NSString *) getTrainType
{
    NSString *result = nil;
    
    if([trainType isEqualToString:@"00"] || [trainType isEqualToString:@"07"])
        result = @"KTX";
    else if([trainType isEqualToString:@"01"])
        result = @"새마을호";
    else if([trainType isEqualToString:@"02"])
        result = @"무궁화호";
    else if([trainType isEqualToString:@"03"])
        result = @"통근열차";
    else if([trainType isEqualToString:@"04"])
        result = @"누리로";
    else if([trainType isEqualToString:@"06"])
        result = @"공항철도";
    else if([trainType isEqualToString:@"08"])
        result = @"ITX-새마을";
    else if([trainType isEqualToString:@"09"])
        result = @"ITX-청춘";
    
    return result;
}

- (NSString *) getDepCode
{
    NSString *result = [codeNameStations objectForKey:depCode];
    
    return result;
}

- (NSString *) getDepTime
{
    NSString *result = [depTime substringToIndex:[depTime length]-2];
    
    NSString *hour = [result substringToIndex:[result length]-2];
    NSString *minute = [result substringFromIndex:2];
    
    result = [NSString stringWithFormat:@"%@%@%@", hour, @":", minute];
    
    return result;
}

- (NSString *) getArrCode
{
    NSString *result = [codeNameStations objectForKey:arrCode];
    
    return result;
}

- (NSString *) getArrTime
{
    NSString *result = [arrTime substringToIndex:[arrTime length]-2];
    
    NSString *hour = [result substringToIndex:[result length]-2];
    NSString *minute = [result substringFromIndex:2];
    
    result = [NSString stringWithFormat:@"%@%@%@", hour, @":", minute];
    
    return result;
}

@end
