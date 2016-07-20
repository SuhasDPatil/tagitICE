//
//  StockCheckViewController.m
//  tagitICE
//
//  Created by suhas on 08/07/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "StockCheckViewController.h"

@interface StockCheckViewController ()

@end

@implementation StockCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:203.0f/255.0f green:32.0f/255.0f blue:45.0f/255.0f alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.title=@"Stock Check";

    
//    UIAlertController *alt=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@\nStock Check",APP_NAME] message:@"Coming Soon..." preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault                          handler:^(UIAlertAction * action)
//                         {
//                             [alt dismissViewControllerAnimated:YES completion:nil];
//                             
//                         }];
//    [alt addAction:ok];
//    [self presentViewController:alt animated:YES completion:nil];

    // Do any additional setup after loading the view from its nib.
}

- (void)setStatusBarBackgroundColor:(UIColor *)color
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)])
    {
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

@end
