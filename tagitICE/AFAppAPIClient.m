//
//  AFAppAPIClient.h
//  tagitICE
//
//  Created by suhas on 15/06/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "AFAppAPIClient.h"
#import "Constant.h"
#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"



@implementation AFAppAPIClient


+ (AFHTTPRequestOperationManager *)sharedClient {
    static AFHTTPRequestOperationManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [AFHTTPRequestOperationManager manager];
        
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        _sharedClient.requestSerializer = requestSerializer;
    });
    return _sharedClient;
}

+ (instancetype)WSsharedClient{
    static AFAppAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppAPIClient alloc] init];
    });
    return _sharedClient;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
   NSLog(@"URL:%@",URLString);
    NSLog(@"Input:%@",parameters);

    return  [[AFAppAPIClient sharedClient] POST:URLString parameters:[self getIncludeSessionValues:parameters]  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *dict_array=(NSArray *)responseObject;
        
        NSDictionary *dict_res=[dict_array objectAtIndex:0];
       NSLog(@"Output:%@",dict_res);
        if (success) {
            success(operation,dict_res);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
    
}


-(AFHTTPRequestOperation *)PUT:(NSString *)URLString
                    parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSLog(@"URL:%@",URLString);
    NSLog(@"Input:%@",parameters);
    
    return  [[AFAppAPIClient sharedClient] PUT:URLString parameters:[self getIncludeSessionValues:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *dict_array=(NSArray *)responseObject;
        
        NSDictionary *dict_res=[dict_array objectAtIndex:0];
        NSLog(@"Output:%@",dict_res);
        if (success) {
            success(operation,dict_res);
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(operation, error);
        }

        
    }];

}


-(AFHTTPRequestOperation *) GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSLog(@"URL:%@",URLString);
    NSLog(@"Input:%@",parameters);
    
    return [[AFAppAPIClient sharedClient]GET:URLString parameters:[self getIncludeSessionValues:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        
        NSArray *dict_array=(NSArray *)responseObject;
        
        NSDictionary *dict_res=[dict_array objectAtIndex:0];
        
        NSLog(@"Output:%@",dict_res);
        if (success)
        {
            success(operation,dict_res);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure)
        {
            failure(operation, error);
        }
        
    }];
}


-(AFHTTPRequestOperation *) GETForgot:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSLog(@"URL:%@",URLString);
    NSLog(@"Input:%@",parameters);
    
    return [[AFAppAPIClient sharedClient]GETForgot:URLString parameters:[self getIncludeSessionValues:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        
        if (success)
        {
            success(operation,responseObject);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure)
        {
            failure(operation, error);
        }
        
    }];

}

-(AFHTTPRequestOperation *) GETRegister:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSLog(@"URL:%@",URLString);
    NSLog(@"Input:%@",parameters);
    
    return [[AFAppAPIClient sharedClient]GETRegister:URLString parameters:[self getIncludeSessionValues:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        
        if (success)
        {
            success(operation,responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure)
        {
            failure(operation, error);
        }
        
    }];
    
}


-(NSDictionary *) getIncludeSessionValues:(NSDictionary *)dict {
    @try {
         NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        dictionary=[dict mutableCopy];
        NSDictionary *userDict=[utilees getUser];
        if(userDict){
        NSString *session=[userDict objectForKey:@"SessionID"];
       
        dictionary=[dict mutableCopy];
        if(session.length>0){
            [dictionary setObject:session forKey:@"SessionID"];
        }
        }
            NSLog(@"Input Dict:%@",[dictionary JSONRepresentation]);
        return dictionary;
    }
    @catch (NSException *exception) {
        
    }
}

@end

