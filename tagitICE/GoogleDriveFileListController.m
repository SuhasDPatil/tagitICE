//
//  GoogleDriveFileListController.m
//  tagitICE
//
//  Created by RAC on 26/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "GoogleDriveFileListController.h"

@interface GoogleDriveFileListController ()

@end

@implementation GoogleDriveFileListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _fileListArray =[[NSMutableArray alloc]init];
    
    _fileListArray=_P_fileArray;
    
//    [_tableView registerNib:nil forCellReuseIdentifier:@"cell"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_fileListArray count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" ] ;
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString * str=[_fileListArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text=str;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}






@end
