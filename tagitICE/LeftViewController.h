//
//  LeftViewController.h
//  tagitICE
//
//  Created by suhas on 05/07/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMSlideMenuLeftTableViewController.h"
#import "StockCheckViewController.h"
#import "ConsignmentViewController.h"
#import "Constant.h"

@interface LeftViewController :AMSlideMenuLeftTableViewController


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic)NSMutableArray *tabledata;
@property(strong,nonatomic)NSMutableArray *leftimages;
@end