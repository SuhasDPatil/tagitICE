//
//  BluetoothScanViewController.h
//  tagitICE
//
//  Created by suhas on 20/06/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanViewCell.h"
#import "Constant.h"
#import "MainVC.h"
#import "LoadStockViewController.h"
#import "ConsignmentViewController.h"

#import "MBProgressHUD.h"

#import <ExternalAccessory/ExternalAccessory.h>
#import <ExternalAccessory/EAAccessoryManager.h>
#import <TSLAsciiCommands/TSLAsciiCommands.h>


#import "AMSmoothAlertView.h"
#import "TSLSelectReaderProtocol.h"


@interface BluetoothScanViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    AMSmoothAlertView * alert;
    MBProgressHUD *hud;

}


@property (strong) NSMutableArray *devices;

// The delegate to be informed of reader selections
@property (nonatomic, readwrite) id<TSLSelectReaderProtocol> delegate;

// Returns the identifier for the Select Reader segue



@property (strong,nonatomic) NSMutableArray * foundArray;

@property (strong, nonatomic) IBOutlet UIView *viewBorder1;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIButton *btnScan;


- (IBAction)scanClicked:(id)sender;

@end
