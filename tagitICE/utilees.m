//
//  utilees.m
//  tagitICE
//
//  Created by suhas on 21/06/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "utilees.h"
#import <CommonCrypto/CommonDigest.h>

@implementation utilees





+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

- (NSTimeInterval) timeStamp
{
    return [[NSDate date] timeIntervalSince1970] * 1000;
}


+(NSString * )getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSTimeZone *gmt = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:gmt];
    NSDate *dt =[NSDate date];
    return [formatter stringFromDate:dt];
}

+(NSMutableArray *)SortArray:(NSMutableArray *) inputArray Key:(NSString  *) key
{
    
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:key
                                                                 ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    NSArray *sortedArray = [inputArray sortedArrayUsingDescriptors:sortDescriptors];
    return [sortedArray mutableCopy] ;
    
}


+(NSDictionary *) getUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *userArray=[userDefaults objectForKey:@"MyData"];
    if([userArray count]>0){
        NSDictionary *userDict=[userArray objectAtIndex:0];
        return userDict;
    }
    return nil;
}

+(NSString *)getUserDataForKey:(NSString *)key
{
    NSDictionary *userData=[self getUser];
    return [NSString stringWithFormat:@"%@",[userData objectForKey:key]];
}

+ (BOOL) validEmail:(NSString*) emailString
{
    
    if([emailString length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}



-(NSDictionary *) getEncodedNDDictionayValues:(NSDictionary *)dict
{
    @try
    {
        /*
         NSMutableDictionary * const m = [dict mutableCopy];
         NSString *value = @"";
         // id const nul = [NSNull null];
         NSArray * const keys = [m allKeys];
         for (NSUInteger idx = 0, count = [keys count]; idx < count; ++idx) {
         id const key = [keys objectAtIndex:idx];
         id const obj = [m objectForKey:key];
         if([obj isKindOfClass:[BOOL class]]){
         value=[obj stringByReplacingOccurrencesOfString:@"'" withString:@""];
         [m setObject:value forKey:key];
         }else{
         [m setObject:obj forKey:key];
         }
         }
         
         [m setObject:[CommonMethods getUTCFormateDate] forKey:@"tzZoneName"];
         
         NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
         [dictionary setObject:[m JSONRepresentation] forKey:@"request"];
         //NSLog(@"Input Dict:%@",m);
         return dictionary; */
        
    }
    @catch (NSException *exception)
    {
        
    }
}




@end
