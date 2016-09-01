//
//  StockCheckViewController.h
//  tagitICE
//
//  Created by suhas on 08/07/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "CustomIOSAlertView.h"
#import "AMSmoothAlertView.h"

#import <MessageUI/MessageUI.h>

#import <ExternalAccessory/ExternalAccessory.h>
#import <TSLAsciiCommands/TSLAsciiCommands.h>
#import <TSLAsciiCommands/TSLAsciiCommandBase.h>
#import <TSLAsciiCommands/TSLBinaryEncoding.h>

#import "MBProgressHUD.h"
#import "MBCircularProgressBarView.h"

#import "SelectReaderInfo.h"
#import "CommoninventoryCommand.h"
#import "UIView+Toast.h"

#import "TagViewController.h"

#import "TagListViewController.h"//Consignment Tag View for Exra Tag listing

#import "TagsSC.h"

#import "StockFile.h"


@interface StockCheckViewController : UIViewController<CustomIOSAlertViewDelegate,MFMailComposeViewControllerDelegate,TSLInventoryCommandTransponderReceivedDelegate>
{
    AMSmoothAlertView * alert;
    CustomIOSAlertView *alertview ;
    BOOL ProcessClicked;
    BOOL isMultiple;
    BOOL isProcessed;

    NSMutableDictionary * tagDict;
    NSMutableArray * TagcountArray;

    NSMutableArray *stockFileArray;

    NSUserDefaults *def;
}

#pragma mark

@property (strong, nonatomic) NSArray * array;

@property (nonatomic,assign, getter=isProcessed) BOOL *process;
#pragma mark 
@property (strong,nonatomic) NSMutableArray *scannedtags;
@property (strong,nonatomic) NSMutableArray *stockFiletags;

@property (strong,nonatomic) NSMutableArray *extraTagArray;
@property (strong,nonatomic) NSMutableArray *missingTaggArray;
@property (strong,nonatomic) NSMutableArray *foundTagArray;

@property (strong,nonatomic) NSMutableArray * PassedFoundArray;
@property (strong,nonatomic) NSMutableArray * PassedMissingArray;
@property (strong,nonatomic) NSMutableArray * PassedExtraArray;

#pragma mark IBoutlets

@property (weak, nonatomic) IBOutlet UIButton *btnBluetooth;

@property (weak, nonatomic) IBOutlet UIButton *btnFileSync;
@property (weak, nonatomic) IBOutlet UIButton *btnClear;
@property (weak, nonatomic) IBOutlet UIButton *btnProcess;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIButton *btnFoundCount;
@property (weak, nonatomic) IBOutlet UIButton *btnMissingCount;
@property (weak, nonatomic) IBOutlet UIButton *btnExtraCount;
@property (weak, nonatomic) IBOutlet UIButton *btnTagCount;
@property (weak, nonatomic) IBOutlet UIImageView *imgCircleE;
@property (weak, nonatomic) IBOutlet UIImageView *imgCircleM;
@property (weak, nonatomic) IBOutlet UIImageView *imgCircleF;
@property (weak, nonatomic) IBOutlet UIImageView *imgBluetooth;
@property (weak, nonatomic) IBOutlet UIImageView *imgSyncFiles;

@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *circularProgress;
@property (weak, nonatomic) IBOutlet UILabel *lblStockFileCount;

#pragma mark IBActions


- (IBAction)tagCountBtnClicked:(id)sender;
- (IBAction)foundBtnClicked:(id)sender;
- (IBAction)missingBtnClicked:(id)sender;
- (IBAction)extraBtnClicked:(id)sender;
- (IBAction)bluetoothBtnClicked:(id)sender;
- (IBAction)syncFileBtnClicked:(id)sender;
- (IBAction)clearBtnClicked:(id)sender;
- (IBAction)processBtnClicked:(id)sender;
- (IBAction)sendBtnClicked:(id)sender;


@end
