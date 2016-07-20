//
//  ConsignmentViewController.h
//  tagitICE
//
//  Created by suhas on 06/07/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagListViewController.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <TSLAsciiCommands/TSLAsciiCommands.h>
#import <TSLAsciiCommands/TSLAsciiCommandBase.h>
#import <MessageUI/MessageUI.h>

#import "AFHTTPRequestOperationManager.h"
#import "AFURLRequestSerialization.h"
#import "MBProgressHUD.h"

#import "TSLSelectReaderProtocol.h"

#import "Tags.h"

@interface ConsignmentViewController : UIViewController<TSLInventoryCommandTransponderReceivedDelegate, TSLBarcodeCommandBarcodeReceivedDelegate, TSLSelectReaderProtocol>


@property (strong) NSManagedObject *existingTag;

@property(strong,nonatomic) TSLAsciiCommander * commander;



@property (strong, nonatomic) IBOutlet UIButton *btnClear;

@property (strong, nonatomic) IBOutlet UIButton *btnProcess;

@property (strong, nonatomic) IBOutlet UIButton *btnSend;

@property (strong, nonatomic) IBOutlet UIButton *btnTagCount;


- (IBAction)clearClicked:(id)sender;

- (IBAction)processClicked:(id)sender;

- (IBAction)sendClicked:(id)sender;

- (IBAction)tagCountClicked:(id)sender;


@end
