//
//  ResultTableViewController.h
//  Korail
//
//  Created by Jun-Young Lee on 2014. 5. 7..
//  Copyright (c) 2014년 Jun-Young Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultTableViewController : UITableViewController <UIAlertViewDelegate>
{
    NSString *query;
}

@property NSString *query;

@end
