//
//  RegisterViewController.m
//  tagitICE
//
//  Created by suhas on 20/06/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _macAddress = [utilees GetDeviceID];
    
    self.title=@"SIGN UP";
    
    [[self.viewBorder1 layer] setBorderWidth:5.0f];
    [[self.viewBorder1 layer] setBorderColor:[UIColor clearColor].CGColor];
    [[self.viewBorder1 layer]setCornerRadius:4.5f];
    
    [[self.viewBorder2 layer] setBorderWidth:5.0f];
    [[self.viewBorder2 layer] setBorderColor:[UIColor clearColor].CGColor];
    [[self.viewBorder2 layer]setCornerRadius:4.5f];
    
    [[self.btnRegister layer] setBorderWidth:5.0f];
    [[self.btnRegister layer] setBorderColor:[UIColor clearColor].CGColor];
    [[self.btnRegister layer]setCornerRadius:4.5f];
    

    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    }





-(void)viewWillAppear:(BOOL)animated
{
     [self setNavBar];
    self.navigationController.navigationBarHidden=NO;
    
    
    if([UIScreen mainScreen].bounds.size.width>=700)
    {
        
          [_txtUserName setFont:[UIFont systemFontOfSize:25]];
          [_txtPassword setFont:[UIFont systemFontOfSize:25]];
          [_txtClientName setFont:[UIFont systemFontOfSize:25]];
          [_txtContactNo setFont:[UIFont systemFontOfSize:25]];
          [_txxEmail setFont:[UIFont systemFontOfSize:25]];
         _lblContNo.font = [UIFont systemFontOfSize:25];
         _btnRegister.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,90)];

        
    }
    else
    {
        
        [_txtUserName setFont:[UIFont systemFontOfSize:16]];
        [_txtPassword setFont:[UIFont systemFontOfSize:16]];
        [_txtClientName setFont:[UIFont systemFontOfSize:16]];
        [_txtContactNo setFont:[UIFont systemFontOfSize:16]];
        [_txxEmail setFont:[UIFont systemFontOfSize:16]];
        _lblContNo.font = [UIFont systemFontOfSize:16];
         _btnRegister.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark User Defined


-(void)setNavBar
{
    
    
    if([UIScreen mainScreen].bounds.size.width>=700)
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:203.0f/255.0f green:32.0f/255.0f blue:45.0f/255.0f alpha:1.0];
        self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:30.0];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor =[UIColor whiteColor];
        label.text=self.title;
        self.navigationItem.titleView = label;

        
    }
    else
    {
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:203.0f/255.0f green:32.0f/255.0f blue:45.0f/255.0f alpha:1.0];
        self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationController.navigationBar.translucent = NO;
    }
    //Back Button
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 12, 20);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;

    
}


- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}







- (IBAction)registerClicked:(id)sender
{
    [_txtClientName resignFirstResponder];
    [_txtUserName resignFirstResponder];
    [_txxEmail resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtContactNo resignFirstResponder];
    
    NSArray * allFields;
    
    if (_txtUserName.text.length<=0 || _txtPassword.text.length<=0 || _txtClientName.text.length<=0 || _txtContactNo.text.length<=0 || _txxEmail.text.length<=0)
    {
        
        UIAlertController *alt=[UIAlertController alertControllerWithTitle:APP_NAME message:@"Please Enter Valid Data!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alt dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alt addAction:ok];
        [self presentViewController:alt animated:YES completion:nil];
    }
    else if (![utilees validEmail:_txxEmail.text])
    {
        allFields=@[self.txxEmail];
        self.viewShaker=[[AFViewShaker alloc]initWithViewsArray:allFields];
//        _txxEmail.textColor=[UIColor redColor];
        [self.viewShaker shake];
        
        UIAlertController *alt=[UIAlertController alertControllerWithTitle:APP_NAME message:@"Please Enter Valid Email!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alt dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alt addAction:ok];
        [self presentViewController:alt animated:YES completion:nil];

    }
    else if (_txtContactNo.text.length<=9)
    {
        allFields=@[self.txtContactNo];
        self.viewShaker=[[AFViewShaker alloc]initWithViewsArray:allFields];
        [self.viewShaker shake];
        
        UIAlertController *alt=[UIAlertController alertControllerWithTitle:APP_NAME message:@"Please Enter Valid Contact Number!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alt dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alt addAction:ok];
        [self presentViewController:alt animated:YES completion:nil];
    }
    else
    {
        [self checkValidUserWebservice];
    }
}

#pragma mark User Defined


#pragma mark web-service
-(void)checkValidUserWebservice
{
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";

    
    NSString * urlStr=[NSString stringWithFormat:@"%@%@",API_IS_VALID_USER,_txtUserName.text];
    
    NSLog(@"%@",urlStr);
    
    NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[AFAppAPIClient WSsharedClient]GETForgot:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [hud hide:YES];
        
        NSNumber *val = responseObject;
        BOOL dict = [val boolValue];

        
        if (dict==0)
        {
            [self RegisterWebservice];

        }
        else if (dict==1) //True
        {
            alert = [[AMSmoothAlertView alloc]initFadeAlertWithTitle:@"Sorry !" andText:@"Username already exists! Please change username " andCancelButton:NO forAlertType:AlertFailure];
            [alert.defaultButton setTitle:@"Okay" forState:UIControlStateNormal];
            alert.cornerRadius = 3.0f;
            [alert show];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [hud hide:YES];
        NSLog(@"%@",[error localizedDescription]);
        
    }];

}


-(void)RegisterWebservice
{
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";

    
    NSString *Stringdict=[NSString stringWithFormat:@"{\"Client_Name\":\"%@\",\"Email\":\"%@\",\"Mac_Address\":\"%@\",\"Mobile_No\":\"%@\",\"Password\":\"%@\",\"User_Name\":\"%@\"}",_txtClientName.text,_txxEmail.text,_macAddress,_txtContactNo.text,_txtPassword.text,_txtUserName.text];
    
    
    NSString * urlStr=[NSString stringWithFormat:@"%@%@",API_REGISTER,Stringdict];
    
    NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",encoded);
    
    
    [[AFAppAPIClient WSsharedClient]GETRegister:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [hud hide:YES];
        
        NSMutableDictionary * dict=responseObject;
        
        NSLog(@"Resp%@",dict);
        
        alert = [[AMSmoothAlertView alloc]initDropAlertWithTitle:APP_NAME andText:@"Successfully Registered !" andCancelButton:NO forAlertType:AlertSuccess];
        [alert.defaultButton setTitle:@"Okay" forState:UIControlStateNormal];
        alert.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button) {
            if(button == alertObj.defaultButton) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                NSLog(@"Others");
            }
        };
        
        alert.cornerRadius = 3.0f;
        [alert show];

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [hud hide:YES];
        
        NSLog(@"%@",[error localizedDescription]);
        
    }];
    
}

@end
