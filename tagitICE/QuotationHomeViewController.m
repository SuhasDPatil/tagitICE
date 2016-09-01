//
//  QuotationHomeViewController.m
//  tagitICE
//
//  Created by RAC on 30/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "QuotationHomeViewController.h"

@interface QuotationHomeViewController ()

@end

@implementation QuotationHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
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

#pragma mark user defined
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
    
}

#pragma mark Button Click methods
- (IBAction)clearClicked:(id)sender
{
    UIAlertController *alt=[UIAlertController alertControllerWithTitle:APP_NAME message:@"Confirm Clear !" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* no = [UIAlertAction
                         actionWithTitle:@"No"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alt dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    UIAlertAction* yes = [UIAlertAction
                          actionWithTitle:@"Yes"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
//                              [self removeAllPreviousScannedTag];
//                              processing=NO;
                          }];
    
    [alt addAction:no];
    [alt addAction:yes];
    
    [self presentViewController:alt animated:YES completion:nil];

}

- (IBAction)processClicked:(id)sender
{
    
}

- (IBAction)sendClicked:(id)sender
{
    
}

- (IBAction)tagCountClicked:(id)sender
{
    
}

@end
