//
//  CategoryTagListViewController.m
//  tagitICE
//
//  Created by RAC on 23/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "CategoryTagListViewController.h"

@interface CategoryTagListViewController ()

@end

@implementation CategoryTagListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    
    _categoryListArray=[[NSMutableArray alloc]init];
    
    if ([_GetFunction isEqualToString:@"FOUND"])
    {
        for (int i=0; i<[_T_FoundArray count]; i++)
        {
            NSMutableDictionary * tempDict=[_T_FoundArray objectAtIndex:i];
            
            [_categoryListArray addObject:[tempDict valueForKey:@"category"]];
            
            _arrayF=[_categoryListArray copy];
            
            NSSet *mySet = [NSSet setWithArray:_arrayF];
            
            _arrayF = [mySet allObjects];

        }
    }
    else if ([_GetFunction isEqualToString:@"MISSING"])
    {
        for (int i=0; i<[_T_MissingArray count]; i++)
        {
            NSMutableDictionary * tempDict=[_T_MissingArray objectAtIndex:i];
            [_categoryListArray addObject:[tempDict valueForKey:@"category"]];
            
            _arrayM=[_categoryListArray copy];
            
            NSSet *mySet = [NSSet setWithArray:_arrayM];
            
            _arrayM = [mySet allObjects];

        }
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark UItableViewDelegate and datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    if ([_GetFunction isEqualToString:@"FOUND"])
    {
        count=[_arrayF count];
    }
    else
    {
        count=[_arrayM count];
    }
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" ] ;
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if ([_GetFunction isEqualToString:@"FOUND"])
    {
        cell.textLabel.text=[_arrayF objectAtIndex:indexPath.row];
    }
    else if ([_GetFunction isEqualToString:@"MISSING"])
    {
        cell.textLabel.text=[_arrayM objectAtIndex:indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryWiseTagListViewController *cwtlvc=[[CategoryWiseTagListViewController  alloc]init];
    
    NSString * str=[[NSString alloc]init];
    if ([_GetFunction isEqualToString:@"FOUND"])
    {
        str=[_arrayF objectAtIndex:indexPath.row];
        cwtlvc.CL_tagArray=_T_FoundArray;
        cwtlvc.CL_categoryName=str;
        
    }
    else if ([_GetFunction isEqualToString:@"MISSING"])
    {
        str=[_arrayM objectAtIndex:indexPath.row];
        cwtlvc.CL_tagArray=_T_MissingArray;
        cwtlvc.CL_categoryName=str;
    }
    [self.navigationController pushViewController:cwtlvc animated:YES];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
@end
