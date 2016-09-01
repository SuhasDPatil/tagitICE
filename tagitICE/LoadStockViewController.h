//
//  LoadStockViewController.h
//  tagitICE
//
//  Created by RAC on 25/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainVC.h"

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"

#import "GoogleDriveFileListController.h"



@interface LoadStockViewController : UIViewController
{
    NSMutableArray *stockFileArray;
    NSUserDefaults *def;
}

@property BOOL isAuthorized;

@property (weak, nonatomic) IBOutlet UIButton *btnLoadCloud;

@property (weak, nonatomic) IBOutlet UIButton *btnLoadFDevice;

@property (weak, nonatomic) IBOutlet UIButton *btnSkip;


- (IBAction)cloudClicked:(id)sender;

- (IBAction)deviceStorageClicked:(id)sender;

- (IBAction)skipClicked:(id)sender;


@property (nonatomic, strong) GTLServiceDrive *service;
@property (nonatomic, strong) UITextView *output;


@end
