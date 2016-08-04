//
//  LoginViewController.m
//  tagitICE
//
//  Created by suhas on 20/06/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _txtMac_Address=[utilees GetDeviceID];
    
    NSLog(@"%@",_txtMac_Address);
    
    UIApplication *app = [UIApplication sharedApplication];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -app.statusBarFrame.size.height, self.view.bounds.size.width, app.statusBarFrame.size.height)];
    statusBarView.backgroundColor = [UIColor blackColor];

//    _txtMac_Address= [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
//    NSLog(@"UDID:: %@", _txtMac_Address);
    
    [[self.viewBorder1 layer] setBorderWidth:5.0f];
    [[self.viewBorder1 layer] setBorderColor:[UIColor clearColor].CGColor];
    [[self.viewBorder1 layer]setCornerRadius:4.5f];

    [[self.viewBorder2 layer] setBorderWidth:5.0f];
    [[self.viewBorder2 layer] setBorderColor:[UIColor clearColor].CGColor];
    [[self.viewBorder2 layer]setCornerRadius:4.5f];

    [[self.btnSignUp layer] setBorderWidth:5.0f];
    [[self.btnSignUp layer] setBorderColor:[UIColor clearColor].CGColor];
    [[self.btnSignUp layer]setCornerRadius:4.5f];

    [[self.btnSignIn layer] setBorderWidth:5.0f];
    [[self.btnSignIn layer] setBorderColor:[UIColor clearColor].CGColor];
    [[self.btnSignIn layer]setCornerRadius:4.5f];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    UIApplication *app = [UIApplication sharedApplication];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -app.statusBarFrame.size.height, self.view.bounds.size.width, app.statusBarFrame.size.height)];
    statusBarView.backgroundColor = [UIColor blackColor];

//    [self LoginWebService];

    self.navigationController.navigationBarHidden=YES;
    
    
       if([UIScreen mainScreen].bounds.size.width>=700)
        {
  
            [_txtUserName setFont:[UIFont systemFontOfSize:25]];
            [_txtPassword setFont:[UIFont systemFontOfSize:25]];
            
           // _btnForgotPassword.titleLabel.font = [UIFont systemFontOfSize: 30];
            _btnSignIn.titleLabel.font = [UIFont boldSystemFontOfSize:30];
            _btnSignUp.titleLabel.font = [UIFont boldSystemFontOfSize:30];
            _btnForgotPassword.titleLabel.font = [UIFont italicSystemFontOfSize:35 ];
        }
        else
        {
            
            [_txtUserName setFont:[UIFont systemFontOfSize:16]];
            [_txtPassword setFont:[UIFont systemFontOfSize:16]];
            _btnSignIn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            _btnSignUp.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            _btnForgotPassword.titleLabel.font = [UIFont italicSystemFontOfSize:16 ];

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

- (IBAction)signInClicked:(id)sender
{

    [_txtUserName resignFirstResponder];
    [_txtPassword resignFirstResponder];
    
    NSArray * allFields;

    if (_txtUserName.text.length==0 && _txtPassword.text.length==0 )
    {
        allFields = @[self.txtPassword, self.txtUserName];
        self.viewShaker = [[AFViewShaker alloc] initWithViewsArray:allFields];
        [self.viewShaker shake];
    }
    else if (_txtUserName.text.length==0)
    {
        allFields=@[self.txtUserName];
        self.viewShaker =[[AFViewShaker alloc]initWithViewsArray:allFields];
        [self.viewShaker shake];
    }
    else if (_txtPassword.text.length==0)
    {
        allFields=@[self.txtPassword];
        self.viewShaker=[[AFViewShaker alloc]initWithViewsArray:allFields];
        [self.viewShaker shake];
    }
    else if (_txtPassword.text.length!=0 && _txtUserName.text.length==0)
    {
        allFields=@[self.txtUserName];
        self.viewShaker=[[AFViewShaker alloc]initWithViewsArray:allFields];
        [self.viewShaker shake];
    }
    else if (_txtPassword.text.length==0 && _txtUserName.text.length!=0)
    {
        allFields=@[self.Password];
        self.viewShaker=[[AFViewShaker alloc]initWithViewsArray:allFields];
        [self.viewShaker shake];
    }
    else
    {
        [self LoginWebService];
    }
}

- (IBAction)signUpClicked:(id)sender
{
    [_txtUserName resignFirstResponder];
    [_txtPassword resignFirstResponder];

    RegisterViewController *rvc=[[RegisterViewController alloc]init];
    [self.navigationController pushViewController:rvc animated:YES];
}

- (IBAction)forgotPassClicked:(id)sender
{
    [_txtUserName resignFirstResponder];
    [_txtPassword resignFirstResponder];

    ForgotPassViewController *fpvc=[[ForgotPassViewController alloc]init];
    [self.navigationController pushViewController:fpvc animated:YES];
}




#pragma mark Web-Service

-(void)LoginWebService
{
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    
    NSString * User_Name=@"User_Name";
    NSString * Password=@"Password";
    NSString * Mac_Address=@"Mac_Address";
    
    
    NSString *Stringdict=[NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\"}",User_Name,_txtUserName.text,Password,_txtPassword.text,Mac_Address,_txtMac_Address];
    NSString * urlStr=[NSString stringWithFormat:@"%@%@",API_VALIDATE_CLIENT_LOGIN,Stringdict];
    NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    [[AFAppAPIClient WSsharedClient]GET:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [hud hide:YES];

        NSMutableDictionary * dict=responseObject;
        
        NSLog(@"Resp%@",dict);
        _Client_Code=[dict valueForKey:@"Client_Code"];
        _Client_Id=[dict valueForKey:@"Client_Id"];
        _Client_Name=[dict valueForKey:@"Client_Name"];
        _Email=[dict valueForKey:@"Email"];
        _Mac_Address=[dict valueForKey:@"Mac_Address"];
        _Mobile_No=[dict valueForKey:@"Mobile_No"];
        _Password=[dict valueForKey:@"Password"];
        _User_Name=[dict valueForKey:@"User_Name"];
        
        if ([_Client_Code isEqualToString:@"NO_KEY"])
        {
            
            UIAlertController *alt=[UIAlertController alertControllerWithTitle:APP_NAME message:@"Please wait for the confirmation mail to Login" preferredStyle:UIAlertControllerStyleAlert];
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
        else if (_User_Name==(id)[NSNull null] || _User_Name==(id)[NSNull null] || _User_Name==(id)[NSNull null])
        {
            UIAlertController *alt=[UIAlertController alertControllerWithTitle:APP_NAME message:@"You are not currently Registered! Please Sign Up" preferredStyle:UIAlertControllerStyleAlert];
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
//        else if (_txtUserName.text==_User_Name && _txtPassword.text!=_Password)
//        {
//            
//            UIAlertController *alt=[UIAlertController alertControllerWithTitle:APP_NAME message:@"Username and password doesn’t match" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction* ok = [UIAlertAction
//                                 actionWithTitle:@"OK"
//                                 style:UIAlertActionStyleDefault
//                                 handler:^(UIAlertAction * action)
//                                 {
//                                     _txtUserName.text=@"";
//                                     _txtPassword.text=@"";
//                                     [alt dismissViewControllerAnimated:YES completion:nil];
//                                     
//                                 }];
//            [alt addAction:ok];
//            [self presentViewController:alt animated:YES completion:nil];
//            
//            BluetoothScanViewController *bsvc=[[BluetoothScanViewController alloc]init];
//            [self.navigationController pushViewController:bsvc animated:YES];
//
//
//        }
        else if (_txtUserName.text==_User_Name && _txtPassword.text==_Password && _txtMac_Address!=_Mac_Address)
        {
            UIAlertController *alt=[UIAlertController alertControllerWithTitle:APP_NAME message:@"Device doesn’t match with username and password" preferredStyle:UIAlertControllerStyleAlert];
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
            
            BluetoothScanViewController *bsvc=[[BluetoothScanViewController alloc]init];
            [self.navigationController pushViewController:bsvc animated:YES];

            

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSLog(@"%@",[error localizedDescription]);

    }];
    

}


@end
