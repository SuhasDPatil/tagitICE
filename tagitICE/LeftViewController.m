//
//  LeftViewController.m
//  tagitICE
//
//  Created by suhas on 05/07/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftMenuViewCell.h"



@interface LeftViewController ()

@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    
    
    self.tabledata = [@[@"STOCK CHECK",@"CONSIGNMENT",@"SEARCH",@"QUOTATION",@"SETTINGS"] mutableCopy];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftMenuViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

-(void)viewWillAppear:(BOOL)animated{
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tabledata count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftMenuViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:156.0f/255.f green:23.f/255.f blue:23.f/255.f alpha:1.0f]];
    bgColorView.layer.cornerRadius = 32;
    [cell setSelectedBackgroundView:bgColorView];
    
    

    cell.lblMenuName.text=self.tabledata[indexPath.row];
    cell.lblMenuName.textColor=[UIColor whiteColor];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 130.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logof.png"]];
}

- (NSIndexPath *)initialIndexPathForLeftMenu
{
    return [NSIndexPath indexPathForRow:1 inSection:0];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *nvc;
    UIViewController *rootVC;
    
    switch (indexPath.row)
    {
        case 0:
        {
            NSLog(@"Stock Check Controller");
            rootVC=[[StockCheckViewController alloc]initWithNibName:@"StockCheckViewController" bundle:nil];
            rootVC.title=@"Stock Check";

        }
            break;

        case 1:
        {
            NSLog(@"Consignment View Controller");
            rootVC=[[ConsignmentViewController alloc]initWithNibName:@"ConsignmentViewController" bundle:nil];
            
        }
            break;
            
        case 2:
        {
            NSLog(@"Search View Controller");
            rootVC=[[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
        }
            break;
            
        case 3:
        {
            NSLog(@"Quotation");
            rootVC=[[QuotationHomeViewController alloc]initWithNibName:@"QuotationHomeViewController" bundle:nil];
            rootVC.title=@"Quotation";

        }
            break;
        case 4:
        {
            NSLog(@"Settings View Controller");
            rootVC=[[QuotationHomeViewController alloc]initWithNibName:@"QuotationHomeViewController" bundle:nil];
            rootVC.title=@"Settings";

        }
            break;

        default:
            break;
            
    }
    nvc=[[UINavigationController alloc]initWithRootViewController:rootVC];
    
    [self openContentNavigationController:nvc];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 64.0f;
}
@end
