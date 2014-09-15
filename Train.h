//
//  Train.h
//  Korail
//
//  Created by Jun-Young Lee on 2014. 5. 15..
//  Copyright (c) 2014년 Jun-Young Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NSMutableArray *trainList;

@interface Train : NSObject
{
    NSString *trainType;
    NSString *trainNumber;
    NSString *depCode;
    NSString *depDate;
    NSString *depTime;
    NSString *arrCode;
    NSString *arrDate;
    NSString *arrTime;
    NSString *trainStatus;
    NSString *trainDelayStatus;
}

@property (getter=getTrainType) NSString *trainType;
@property NSString *trainNumber;
@property (getter=getDepCode) NSString *depCode;
@property NSString *depDate;
@property (getter=getDepTime) NSString *depTime;
@property (getter=getArrCode) NSString *arrCode;
@property NSString *arrDate;
@property (getter=getArrTime) NSString *arrTime;
@property NSString *trainStatus;
@property NSString *trainDelayStatus;

@end
