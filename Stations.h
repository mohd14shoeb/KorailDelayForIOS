//
//  Stations.h
//  Korail
//
//  Created by Jun-Young Lee on 2014. 5. 7..
//  Copyright (c) 2014년 Jun-Young Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NSMutableDictionary *nameCodeStations;
NSMutableDictionary *codeNameStations;

@interface Stations : NSObject

-(void)initCodeNameStations;
-(void)initNameCodeStations;

@end
