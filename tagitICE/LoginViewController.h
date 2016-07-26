//
//  LoginViewController.h
//  tagitICE
//
//  Created by suhas on 20/06/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"
#import "ForgotPassViewController.h"
#import "BluetoothScanViewController.h"

#import "AMSmoothAlertConstants.h"
#import "AMSmoothAlertView.h"

#import "AFAppAPIClient.h"
#import "AFViewShaker.h"
#import "Constant.h"
#import "utilees.h"

#import "MBProgressHUD.h"

@interface LoginViewController : UIViewController
{
    AMSmoothAlertView * alert;

}
@property (strong, nonatomic) IBOutlet UIView *viewBorder1;

@property (strong, nonatomic) IBOutlet UIView *viewBorder2;

@property (strong, nonatomic) IBOutlet UITextField *txtUserName;

@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

@property (strong, nonatomic) IBOutlet UIButton *btnSignIn;

@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;

@property (strong, nonatomic) IBOutlet UIButton *btnForgotPassword;







@property (nonatomic, strong) AFViewShaker * viewShaker;



@property(nonatomic,strong)NSString * txtMac_Address;


//GetParsed Data
@property(nonatomic,strong)NSString *Client_Code;
@property(nonatomic,strong)NSString *Client_Id;
@property(nonatomic,strong)NSString *Client_Name;
@property(nonatomic,strong)NSString *Email;
@property(nonatomic,strong)NSString *Mac_Address;
@property(nonatomic,strong)NSString *Mobile_No;
@property(nonatomic,strong)NSString *Password;
@property(nonatomic,strong)NSString *User_Name;







- (IBAction)signInClicked:(id)sender;

- (IBAction)signUpClicked:(id)sender;

- (IBAction)forgotPassClicked:(id)sender;


@end
