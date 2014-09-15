//
//  CustomTableViewCell.h
//  Korail
//
//  Created by Jun-Young Lee on 2014. 5. 15..
//  Copyright (c) 2014년 Jun-Young Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *trainType;
@property (weak, nonatomic) IBOutlet UILabel *trainNumber;
@property (weak, nonatomic) IBOutlet UILabel *departureStation;
@property (weak, nonatomic) IBOutlet UILabel *departureTime;
@property (weak, nonatomic) IBOutlet UILabel *arrivalStation;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTime;
@property (weak, nonatomic) IBOutlet UILabel *trainLocation;
@property (weak, nonatomic) IBOutlet UILabel *trainDelayTime;

@end
