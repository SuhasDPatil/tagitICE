//
//  Constant.h
//  tagitICE
//
//  Created by suhas on 15/06/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//


#import "utilees.h"


#define APP_NAME @"Tagit ICE"
#define ERROR @"Tagit ICE Error"
#define RESULT @"Result"
#define DATA @"Data"


// from live server

#define API_BASE_URL @"http://www.tagitcounter.com/AndroidTestWebApp1/Service1.svc/"



// Login
#define API_VALIDATE_CLIENT_LOGIN (API_BASE_URL @"ValidateClient?str=")

// Forgot Password
#define API_FORGOT_PASSWORD (API_BASE_URL @"VerifyEmail?str=")


// Register 
#define API_IS_VALID_USER (API_BASE_URL @"IsUserRegisteredAlready?str=")

#define API_REGISTER (API_BASE_URL @"InsertClientNew?str=")





#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)



#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

