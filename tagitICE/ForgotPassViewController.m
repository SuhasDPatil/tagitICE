//
//  ForgotPassViewController.m
//  tagitICE
//
//  Created by suhas on 20/06/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "ForgotPassViewController.h"

@interface ForgotPassViewController ()

@end

@implementation ForgotPassViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
  
    self.title=@"Forgot Password";
      [self setNavBar];
    [[self.viewBorder1 layer] setBorderWidth:5.0f];
    [[self.viewBorder1 layer] setBorderColor:[UIColor clearColor].CGColor];
    [[self.viewBorder1 layer]setCornerRadius:4.5f];
    
    [[self.viewBorder2 layer] setBorderWidth:5.0f];
    [[self.viewBorder2 layer] setBorderColor:[UIColor clearColor].CGColor];
    [[self.viewBorder2 layer]setCornerRadius:4.5f];

    [[self.btnSend layer] setBorderWidth:5.0f];
    [[self.btnSend layer] setBorderColor:[UIColor clearColor].CGColor];
    [[self.btnSend layer]setCornerRadius:4.5f];
    
    [[self.btnCancel layer] setBorderWidth:5.0f];
    [[self.btnCancel layer] setBorderColor:[UIColor clearColor].CGColor];
    [[self.btnCancel layer]setCornerRadius:4.5f];

    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    UIApplication *app = [UIApplication sharedApplication];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -app.statusBarFrame.size.height, self.view.bounds.size.width, app.statusBarFrame.size.height)];
    statusBarView.backgroundColor = [UIColor blackColor];

    self.navigationController.navigationBarHidden=NO;
    
    if([UIScreen mainScreen].bounds.size.width>=700)
    {
        _lblforgtPassTitl.font = [UIFont systemFontOfSize:25];
        _lblnote.font=[UIFont systemFontOfSize:20];
        [_txtUsername setFont:[UIFont systemFontOfSize:25]];
        [_txtEmail setFont:[UIFont systemFontOfSize:25]];
       _btnSend.titleLabel.font = [UIFont boldSystemFontOfSize:30];
       _btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,90)];

        }
    else
    {
        
        _lblforgtPassTitl.font = [UIFont systemFontOfSize:20];
        _lblnote.font=[UIFont systemFontOfSize:12];
        [_txtUsername setFont:[UIFont systemFontOfSize:16]];
        [_txtEmail setFont:[UIFont systemFontOfSize:16]];
        _btnSend.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:18];
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

- (IBAction)cancelClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)sendClicked:(id)sender
{
    [_txtEmail resignFirstResponder];
    [_txtUsername resignFirstResponder];
    
    NSArray * allFields;
    
    if (_txtUsername.text.length==0 && _txtEmail.text.length==0 )
    {
        allFields = @[self.txtEmail, self.txtUsername];
        self.viewShaker = [[AFViewShaker alloc] initWithViewsArray:allFields];
        [self.viewShaker shake];
    }
    else if (_txtUsername.text.length==0)
    {
        allFields=@[self.txtUsername];
        self.viewShaker =[[AFViewShaker alloc]initWithViewsArray:allFields];
        [self.viewShaker shake];
    }
    else if (_txtEmail.text.length==0)
    {
        allFields=@[self.txtEmail];
        self.viewShaker=[[AFViewShaker alloc]initWithViewsArray:allFields];
        [self.viewShaker shake];
    }
    else if (![utilees validEmail:_txtEmail.text])
    {
        allFields=@[_txtEmail];
        self.viewShaker=[[AFViewShaker alloc]initWithViewsArray:allFields];
        [self.viewShaker shake];
    }
    else
    {
        [self ForgotPasswordWebService];
    }
}


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
//    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 0, 0);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark Web-service

-(void)ForgotPasswordWebService
{
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";

    NSString *Stringdict=[NSString stringWithFormat:@"{\"User_Name\":\"%@\",\"Email\":\"%@\"}",_txtUsername.text,_txtEmail.text];
    
    
    NSString * urlStr=[NSString stringWithFormat:@"%@%@",API_FORGOT_PASSWORD,Stringdict];
    
    NSLog(@"%@",urlStr);
    
    NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [[AFAppAPIClient WSsharedClient]GETForgot:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [hud hide:YES];
        
        NSNumber *val = responseObject;
        BOOL dict = [val boolValue];
        
        NSLog(@"Resp %d",dict);
        
        if (dict==0)
        {
            
            alert = [[AMSmoothAlertView alloc]initFadeAlertWithTitle:APP_NAME andText:@"Username or email doesn’t exist" andCancelButton:NO forAlertType:AlertFailure];
            [alert.defaultButton setTitle:@"Ok" forState:UIControlStateNormal];
            alert.cornerRadius = 3.0f;
            [alert show];

        }
        else if (dict==1)
        {
            
            
            
            alert = [[AMSmoothAlertView alloc]initDropAlertWithTitle:APP_NAME andText:@"Forgot Password! Password reset link sent to the mail !" andCancelButton:NO forAlertType:AlertSuccess];
            [alert.defaultButton setTitle:@"Ok" forState:UIControlStateNormal];
            alert.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button) {
                if(button == alertObj.defaultButton)
                {
                    [self back];
                    
                } else {
                    NSLog(@"Others");
                }
            };
            
            alert.cornerRadius = 3.0f;
            [alert show];

        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [hud hide:YES];
        NSLog(@"%@",[error localizedDescription]);
        
    }];
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
