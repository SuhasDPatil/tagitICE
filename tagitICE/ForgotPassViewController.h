//
//  ForgotPassViewController.h
//  tagitICE
//
//  Created by suhas on 20/06/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFAppAPIClient.h"
#import "Constant.h"
#import "AFViewShaker.h"
#import "utilees.h"

#import "AMSmoothAlertConstants.h"
#import "AMSmoothAlertView.h"

#import "MBProgressHUD.h"

@interface ForgotPassViewController : UIViewController
{
    AMSmoothAlertView * alert;
    
}

@property (strong, nonatomic) IBOutlet UIView *viewBorder1;

@property (strong, nonatomic) IBOutlet UIView *viewBorder2;

@property (strong, nonatomic) IBOutlet UITextField *txtUsername;

@property (strong, nonatomic) IBOutlet UITextField *txtEmail;

@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

@property (strong, nonatomic) IBOutlet UIButton *btnSend;


@property (weak, nonatomic) IBOutlet UILabel *lblforgtPassTitl;

@property (weak, nonatomic) IBOutlet UILabel *lblnote;


@property (nonatomic, strong) AFViewShaker * viewShaker;



- (IBAction)cancelClicked:(id)sender;

- (IBAction)sendClicked:(id)sender;


@end
