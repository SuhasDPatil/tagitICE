//
//  GoogleDriveFileListController.h
//  tagitICE
//
//  Created by RAC on 26/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoogleDriveFileListController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)IBOutlet UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * P_fileArray;

@property(nonatomic,strong)NSMutableArray * fileListArray;

@end
