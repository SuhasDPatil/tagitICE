//
//  SearchViewController.h
//  tagitICE
//
//  Created by rac on 28/07/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SelectReaderInfo.h"
#import "CommoninventoryCommand.h"

#import "SearchTagViewCell.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <TSLAsciiCommands/TSLAsciiCommands.h>
#import <TSLAsciiCommands/TSLAsciiCommandBase.h>
#import <TSLAsciiCommands/TSLBinaryEncoding.h>
#import "ACFloatingTextField.h"

@interface SearchViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,TSLInventoryCommandTransponderReceivedDelegate>
{
    NSArray *AddTagArray;
    NSMutableArray * searchTagArray;
    NSMutableDictionary * tagDict;

}


@property (strong, nonatomic) NSArray * arrayCopy;

@property (strong, nonatomic) IBOutlet ACFloatingTextField *txtSearch;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIButton *btnClear;

@property (strong, nonatomic) IBOutlet UIButton *btnAddItems;


- (IBAction)additemClicked:(id)sender;

- (IBAction)clearClicked:(id)sender;

@end
