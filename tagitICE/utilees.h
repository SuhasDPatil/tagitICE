//
//  utilees.h
//  tagitICE
//
//  Created by suhas on 21/06/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface utilees : NSObject

+(void)showAlert:(NSString *)title Message:(NSString *)msg;
+ (NSString *) md5:(NSString *) input;
+(NSDictionary *) getUser;
+(NSString *)getUserDataForKey:(NSString *)key;
+(NSMutableArray *)SortArray:(NSMutableArray *) inputArray Key:(NSString  *) key;
+ (BOOL) validEmail:(NSString*) emailString;
- (NSTimeInterval) timeStamp;
+(NSString * )getCurrentTime;

@end
