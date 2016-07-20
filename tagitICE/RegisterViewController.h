//
//  RegisterViewController.h
//  tagitICE
//
//  Created by suhas on 20/06/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "AFAppAPIClient.h"
#import "AFViewShaker.h"
#import "utilees.h"

#import "AMSmoothAlertConstants.h"
#import "AMSmoothAlertView.h"
#import "MBProgressHUD.h"

@interface RegisterViewController : UIViewController
{
    AMSmoothAlertView * alert;
    
}

@property (strong, nonatomic) IBOutlet UIView *viewBorder1;

@property (strong, nonatomic) IBOutlet UIView *viewBorder2;

@property (strong, nonatomic) IBOutlet UITextField *txtClientName;

@property (strong, nonatomic) IBOutlet UITextField *txtUserName;

@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

@property (strong, nonatomic) IBOutlet UITextField *txxEmail;

@property (strong, nonatomic) IBOutlet UITextField *txtContactNo;

@property (strong, nonatomic) IBOutlet UILabel *lblContNo;

@property (strong, nonatomic) IBOutlet UIButton *btnRegister;

@property (nonatomic, strong) AFViewShaker * viewShaker;


- (IBAction)registerClicked:(id)sender;


@end
