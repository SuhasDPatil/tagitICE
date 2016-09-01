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
#import "Constant.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SearchViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,TSLInventoryCommandTransponderReceivedDelegate>
{
    NSArray * spliStringArray;
    NSMutableArray *AddTagArray;
    NSMutableArray * scanTagArray;
    NSMutableDictionary * SearTagDict;
    NSMutableArray * matchedTags;
    
    BOOL addItemClicked;
    BOOL isSoundPlayed;
    NSMutableDictionary * scanDict;
    
    NSMutableDictionary *dicttObject;


}

@property (strong, nonatomic) NSTimer *timer;


@property (strong, nonatomic) NSArray * arrayCopy;

@property (strong, nonatomic) IBOutlet ACFloatingTextField *txtSearch;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIButton *btnClear;

@property (strong, nonatomic) IBOutlet UIButton *btnAddItems;

@property (strong, nonatomic) IBOutlet UIImageView *imgClear;

@property (strong, nonatomic) IBOutlet UIButton *btntxtClear;


- (IBAction)textClearClicked:(id)sender;



- (IBAction)additemClicked:(id)sender;

- (IBAction)clearClicked:(id)sender;

@end
