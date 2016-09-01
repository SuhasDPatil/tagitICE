//
//  QuotationHomeViewController.h
//  tagitICE
//
//  Created by RAC on 30/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectReaderInfo.h"
#import "CommoninventoryCommand.h"
#import <MessageUI/MessageUI.h>

#import "UIView+Toast.h"
#import "Constant.h"


@interface QuotationHomeViewController : UIViewController<TSLInventoryCommandTransponderReceivedDelegate,MFMailComposeViewControllerDelegate>
{
    NSMutableArray * TagcountArray;
}



@property (strong, nonatomic) IBOutlet UIButton *btnClear;

@property (strong, nonatomic) IBOutlet UIButton *btnProcess;

@property (strong, nonatomic) IBOutlet UIButton *btnSend;

@property (strong, nonatomic) IBOutlet UIButton *btnTagCount;


- (IBAction)clearClicked:(id)sender;

- (IBAction)processClicked:(id)sender;

- (IBAction)sendClicked:(id)sender;

- (IBAction)tagCountClicked:(id)sender;





@end
