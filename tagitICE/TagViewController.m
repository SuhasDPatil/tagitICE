//
//  TagViewController.m
//  tagitICE
//
//  Created by RAC on 23/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "TagViewController.h"

@interface TagViewController ()

@end

@implementation TagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBar];
    self.title=_titleText;
        
    AllTagListViewController *controller1 = [[AllTagListViewController alloc]initWithNibName:@"AllTagListViewController" bundle:nil];
    controller1.title = @"ALL";
    controller1.GetFunction=_titleText;
    controller1.T_FoundArray=_S_FoundArray;
    controller1.T_MissingArray=_S_MissingArray;
    
    
    CategoryTagListViewController *controller2 = [[CategoryTagListViewController alloc]initWithNibName:@"CategoryTagListViewController" bundle:nil];
    controller2.title = @"CATEGORY";
    controller2.GetFunction=_titleText;
    controller2.T_FoundArray=_S_FoundArray;
    controller2.T_MissingArray=_S_MissingArray;
    

    UINavigationController * nav1=[[UINavigationController alloc]initWithRootViewController:controller1];
    
    UINavigationController * nav2=[[UINavigationController alloc]initWithRootViewController:controller2];

    NSArray *controllerArray = @[nav1,nav2];
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor colorWithRed:255.0f/255.0f green:12.0f/255.0f blue:12.0f/255.0f alpha:1.0],
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor: [UIColor colorWithRed:255.0f/255.0f green:12.0f/255.0f blue:12.0f/255.0f alpha:1.0],
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor: [UIColor colorWithRed:255.0f/255.0f green:12.0f/255.0f blue:12.0f/255.0f alpha:1.0],
                                 CAPSPageMenuOptionMenuItemFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:15.0],
                                 CAPSPageMenuOptionMenuHeight: @(45.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(140.0),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES),
                                 CAPSPageMenuOptionMenuItemSeparatorWidth:@(1.0)
                                 
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    
    [self.view addSubview:_pageMenu.view];
    

    // Do any additional setup after loading the view from its nib.
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


@end
