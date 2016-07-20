//
//  AFAppAPIClient.h
//  tagitICE
//
//  Created by suhas on 15/06/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "SBJson.h"
#import "utilees.h"


@interface AFAppAPIClient : AFHTTPRequestOperationManager

+ (AFHTTPRequestOperationManager *)sharedClient;
+ (instancetype)WSsharedClient;
@end
