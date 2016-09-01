//
//  CategoryTagListViewController.h
//  tagitICE
//
//  Created by RAC on 23/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CategoryWiseTagListViewController.h"

@interface CategoryTagListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,weak)IBOutlet UITableView *tableView;


@property(nonatomic,strong)NSMutableArray * T_FoundArray;
@property(nonatomic,strong)NSMutableArray * T_MissingArray;

@property(nonatomic,strong)NSString * GetFunction;


@property(nonatomic,strong)NSMutableArray * categoryListArray;

@property (strong, nonatomic) NSArray * arrayF;
@property (strong, nonatomic) NSArray * arrayM;


@end
