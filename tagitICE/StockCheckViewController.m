//
//  StockCheckViewController.m
//  tagitICE
//
//  Created by suhas on 08/07/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "StockCheckViewController.h"

@interface StockCheckViewController ()
{
    NSString *_partialResultMessage;
    BOOL processing;
    NSArray * _accessoryList;
    EAAccessory *_currentAccessory;
    
    CommoninventoryCommand *_inventoryResponder;
    //    TSLBarcodeCommand *_barcodeResponder;
    SelectReaderInfo * _commander;

}
@end

@implementation StockCheckViewController

#pragma mark CoreData Method for reuse
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self removeStockFileData];
//    [self loadStockFile];
    [self getPreviouslyScannedTags];
    processing=NO;
    isMultiple=NO;
    isProcessed=NO;
    
    def=[NSUserDefaults standardUserDefaults];
    
    NSString * str= [def valueForKey:@"LoadStockCount"];

    _lblStockFileCount.text=[NSString stringWithFormat:@"/%@",str];
    
    _circularProgress.maxValue=[str intValue];

    _btnMissingCount.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _btnFoundCount.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _btnExtraCount.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _btnMissingCount.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btnFoundCount.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btnExtraCount.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_btnFoundCount setTitle:[NSString stringWithFormat:@"0\nFound"] forState:UIControlStateNormal  ];
    [_btnExtraCount setTitle:[NSString stringWithFormat:@"0\nExtra"] forState:UIControlStateNormal  ];
    [_btnMissingCount setTitle:[NSString stringWithFormat:@"0\nMissing"] forState:UIControlStateNormal  ];

    _btnBluetooth.hidden=YES;
    _btnFileSync.hidden=YES;
    ProcessClicked=NO;
    
    _PassedExtraArray =[[NSMutableArray alloc]init];
    _PassedMissingArray =[[NSMutableArray alloc]init];
    
    
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    
    [[UIView appearance] setTintColor:[UIColor darkTextColor]];

    alertview = [[CustomIOSAlertView alloc] init];
    // Add some custom content to the alert view
    [alertview setContainerView:[self createAlertView]];
    // Modify the parameters
    [alertview setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel",  nil]];
    [alertview setDelegate:self];
    
    [alertview setUseMotionEffects:true];
    alertview.tag=100;

    [alertview setTintColor:[UIColor darkGrayColor]];
    [alertview show];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:203.0f/255.0f green:32.0f/255.0f blue:45.0f/255.0f alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    [[UIView appearance] setTintColor:[UIColor darkTextColor]];
    
    
    self.title=@"Stock Check";
    [self setNavBar];
    
    TagcountArray=[[NSMutableArray alloc]init];
    
    tagDict=[[NSMutableDictionary alloc]init];
    _commander=[SelectReaderInfo sharedInstance];
    
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    
    _inventoryResponder = [CommoninventoryCommand sharedInstance] ;    // Create a TSLInventoryCommand
    _inventoryResponder.transponderReceivedDelegate = self;    // Add self as the transponder delegate
    _inventoryResponder.captureNonLibraryResponses = YES;
    _inventoryResponder.includeTransponderRSSI=TSL_TriState_YES;
    
    _inventoryResponder.responseBeganBlock = ^
    {
        dispatch_async(dispatch_get_main_queue(),^
                       {
                           
                       });
    };
    _inventoryResponder.responseEndedBlock = ^
    {
        dispatch_async(dispatch_get_main_queue(),^
                       {
                           
                           NSManagedObjectContext *context = nil;
                           id delegate = [[UIApplication sharedApplication] delegate];
                           if ([delegate performSelector:@selector(managedObjectContext)])
                           {
                               context = [delegate managedObjectContext];
                           }

                           NSEntityDescription *entity = [NSEntityDescription entityForName:@"TagsSC"
                                                                     inManagedObjectContext:context];
                           
                           NSFetchRequest *request = [[NSFetchRequest alloc] init];
                           [request setEntity:entity];
                           
                           NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"srNumber"
                                                                                          ascending:NO];
                           NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                           
                           [request setSortDescriptors:sortDescriptors];
                           
                           NSError *Fetcherror;
                           NSMutableArray *mutableFetchResults = [[context
                                                                   executeFetchRequest:request error:&Fetcherror] mutableCopy];
                           
                           if (!mutableFetchResults) {
                               // error handling code.
                           }
                           
                           for (int i=0; i<[_array count]; i++)
                           {
                               NSDateFormatter *formatter;
                               NSString        *dateString;
                               formatter = [[NSDateFormatter alloc] init];
                               [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                               dateString = [formatter stringFromDate:[NSDate date]];

                               if ([[mutableFetchResults valueForKey:@"srNumber"]
                                    containsObject:[_array objectAtIndex:i]]) {
                                   NSLog(@"Duplicate Found");
                                   
                               }
                               else
                               {
                                   //write your code to add data
                                   TagsSC *newtag = [NSEntityDescription insertNewObjectForEntityForName:@"TagsSC" inManagedObjectContext:context];
                                   [newtag setValue:[_array objectAtIndex:i] forKey:@"srNumber"];
                                   [newtag setValue:@"1" forKey:@"quantity"];
                                   [newtag setValue:dateString forKey:@"scanDateTime"];

                               }
                           }
                           
                           NSError *error = nil;
                           // Save the object to persistent store
                           if (![context save:&error])
                           {
                               NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                           }
                           
                           [_btnTagCount setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[_array count]] forState:UIControlStateNormal];

                       });
    };
    [_commander addResponder:_inventoryResponder];    // Add the inventory responder to the commander's responder chain
}

-(void)getPreviouslyScannedTags
{
    // Fetch the Tags from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TagsSC"];
    NSMutableArray * PrevScanedTags = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [_btnTagCount setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[PrevScanedTags count]] forState:UIControlStateNormal];
    
}

-(void)loadStockFile
{
    //Get Data from Stock_File.txt
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Stock_File" ofType:@"txt"];
    
    NSLog(@"%@",filePath);
    
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
    
    stockFileArray=[NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    
    [self checkForDuplicates];
    
    
}

-(void)checkForDuplicates
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StockFile"
                                              inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"item_Code" ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    [request setSortDescriptors:sortDescriptors];
    
    NSError *Fetcherror;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&Fetcherror] mutableCopy];
    
    if (!mutableFetchResults) {
        // error handling code.
    }
    
    for (int i=0; i<[stockFileArray count]; i++)
    {
        NSMutableDictionary *dict=[stockFileArray objectAtIndex:i];
        
        if ([[mutableFetchResults valueForKey:@"item_Code"] containsObject:[dict objectForKey:@"Item_Code"]])
        {
            NSLog(@"Duplicate Found");
        }
        else
        {
            //write your code to add data
            StockFile *newStock = [NSEntityDescription insertNewObjectForEntityForName:@"StockFile" inManagedObjectContext:context];
            [newStock setValue:[dict valueForKey:@"Category"] forKey:@"category"];
            [newStock setValue:[dict valueForKey:@"Item_Code"] forKey:@"item_Code"];
            [newStock setValue:[dict valueForKey:@"Item_Description"] forKey:@"item_Description"];
            [newStock setValue:[dict valueForKey:@"Gross_Wt"] forKey:@"gross_Wt"];
            [newStock setValue:[dict valueForKey:@"Location_Name"] forKey:@"location_Name"];
            [newStock setValue:[dict valueForKey:@"Tag_Price"] forKey:@"tag_Price"];
            [newStock setValue:[dict valueForKey:@"Qty"] forKey:@"qty"];
            [newStock setValue:[dict valueForKey:@"Net_Wt"] forKey:@"net_Wt"];
            [newStock setValue:[dict valueForKey:@"Dia_Wt"] forKey:@"dia_Wt"];
            [newStock setValue:[dict valueForKey:@"St_Wt"] forKey:@"st_Wt"];
            [newStock setValue:[dict valueForKey:@"Gold_Oth_Wt"] forKey:@"gold_Oth_Wt"];
            [newStock setValue:[dict valueForKey:@"ItemType_Name"] forKey:@"itemType_Name"];
            [newStock setValue:[dict valueForKey:@"Img_url"] forKey:@"img_url"];
            [newStock setValue:@"missing" forKey:@"menu"];
        }
    }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error])
    {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

-(void)removeStockFileData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    [hud show:YES];
    
    
    _array=nil;
    [stockFileArray removeAllObjects];
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StockFile" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
        NSLog(@"%@ object deleted",@"StockFile");
    }
    if (![context save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",@"StockFile",error);
    }
    [hud hide:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;

    if([UIScreen mainScreen].bounds.size.width>=700)
    {
        _btnSend.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        _btnProcess.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        _btnClear.titleLabel.font = [UIFont boldSystemFontOfSize:30 ];
        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,90)];
    }
    else
    {
        _btnSend.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _btnProcess.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _btnClear.titleLabel.font = [UIFont boldSystemFontOfSize:18 ];
        
    }
}
-(void)removeAllPreviousScannedTag
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    [hud show:YES];
    
    _array=nil;
    [TagcountArray removeAllObjects];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TagsSC" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
        NSLog(@"%@ object deleted",@"TagsSC");
    }
    if (![context save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",@"TagsSC",error);
    }
    [hud hide:YES];
    [_btnTagCount setTitle:[NSString stringWithFormat:@"%ld",[_array count]] forState:UIControlStateNormal];
    
    
}


- (UIView *)createAlertView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 142)];
    
    UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 250, 30)];
    lblTitle.text=@"Tagit Ice";
    lblTitle.textAlignment=NSTextAlignmentLeft;
    lblTitle.font = [UIFont boldSystemFontOfSize:18 ];
    lblTitle.textColor=[UIColor redColor];
    [demoView addSubview:lblTitle];
    
    UILabel *lblLine=[[UILabel alloc]initWithFrame:CGRectMake(0, 38, 270, 1)];
    lblLine.backgroundColor=[UIColor redColor];
    lblLine.text=@"";
    [demoView addSubview:lblLine];
    
    UILabel *lblBody=[[UILabel alloc]initWithFrame:CGRectMake(0,42, 270, 30)];
    lblBody.text=@"Please select no. of THS Devices:";
    lblBody.textAlignment=NSTextAlignmentCenter;
    lblBody.font = [UIFont systemFontOfSize:14];

    lblBody.numberOfLines=2;
    lblBody.textColor=[UIColor blackColor];
    [demoView addSubview:lblBody];

    UIButton * btnSingle=[[UIButton alloc]initWithFrame:CGRectMake(10, 82, 115, 42)];
   // btnSingle.titleLabel.textColor=[UIColor redColor];
    [[btnSingle layer] setBorderWidth:0.8f];
    [[btnSingle layer] setBorderColor:[UIColor redColor].CGColor];
    [[btnSingle layer]setCornerRadius:3.5f];
    //btnSingle.titleLabel.text=@"Single";
    [btnSingle setTitle:@"Single" forState:UIControlStateNormal];
    [btnSingle addTarget:self action:@selector(singleClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //btnSingle.titleLabel.textColor=[UIColor redColor];
    [btnSingle setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    [demoView addSubview:btnSingle];
    
    UIButton * btnMult=[[UIButton alloc]initWithFrame:CGRectMake(135, 82, 120, 42)];
    [btnMult setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [[btnMult layer] setBorderWidth:0.8f];
    [[btnMult layer] setBorderColor:[UIColor redColor].CGColor];
    [[btnMult layer]setCornerRadius:3.5f];
    [btnMult setTitle:@"Multiple" forState:UIControlStateNormal];
    [btnMult addTarget:self action:@selector(multipleClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [demoView addSubview:btnMult];
    
    return demoView;
}


#pragma mark CustomIOSAlertViewDelegate & Button Actions
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    [alertView close];
}

-(void)multipleClicked:(id)sender
{
    isMultiple=YES;
    [alertview close];
    _btnBluetooth.hidden=NO;
    _btnFileSync.hidden=NO;
    _imgBluetooth.hidden=NO;
    _imgSyncFiles.hidden=NO;
}

-(void)singleClicked:(id)sender
{
    isMultiple=NO;
    [alertview close];
    _btnBluetooth.hidden=YES;
    _btnFileSync.hidden=YES;
    _imgSyncFiles.hidden=YES;
    _imgBluetooth.hidden=YES;
}

#pragma mark User Defined
-(void)setNavBar
{
    if([UIScreen mainScreen].bounds.size.width>=700)
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:203.0f/255.0f green:32.0f/255.0f blue:45.0f/255.0f alpha:1.0];
        self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:30.0];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor =[UIColor whiteColor];
        label.text=self.title;
        self.navigationItem.titleView = label;
    }
    else
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:203.0f/255.0f green:32.0f/255.0f blue:45.0f/255.0f alpha:1.0];
        self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)setStatusBarBackgroundColor:(UIColor *)color
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)])
    {
        statusBar.backgroundColor = color;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TSLInventoryCommandTransponderReceivedDelegate methods

//
// Each transponder received from the reader is passed to this method
//
// Parameters epc, crc, pc, and rssi may be nil
//
// Note: This is an asynchronous call from a separate thread
//
-(void)transponderReceived:(NSString *)epc crc:(NSNumber *)crc pc:(NSNumber *)pc rssi:(NSNumber *)rssi fastId:(NSData *)fastId moreAvailable:(BOOL)moreAvailable
{
    // Append the transponder EPC identifier and RSSI to the results
    _partialResultMessage = [_partialResultMessage stringByAppendingFormat:@"EPC_ID : %-28s  RSSI : %4d\n", [epc UTF8String], [rssi intValue]];
    
    processing=NO;
    
    
    NSData *epcdata=[TSLBinaryEncoding dataFromAsciiString:epc];
    NSString * epcfinal=[TSLBinaryEncoding asciiStringFromData:epcdata];
    
    [tagDict setObject:epcfinal forKey:@"srNumber"];
    [tagDict setObject:@"1" forKey:@"quantity"];
    
    [TagcountArray addObject:[tagDict valueForKey:@"srNumber"]];
    
    _array=[TagcountArray copy];
    
    NSSet *mySet = [NSSet setWithArray:_array];

    _array = [mySet allObjects];
    
    if( fastId != nil)
    {
        _partialResultMessage = [_partialResultMessage stringByAppendingFormat:@"%-6@  %@\n", @"TID:", [TSLBinaryEncoding toBase16String:fastId]];
    }
    
    // If this is the last transponder add a few blank lines
    if( !moreAvailable )
    {
        
    }
}



#pragma mark
#pragma mark Button Action Methods

- (IBAction)tagCountBtnClicked:(id)sender
{
    if (ProcessClicked==YES)
    {
        _btnMissingCount.hidden=YES;
        _btnFoundCount.hidden=YES;
        _btnExtraCount.hidden=YES;
        _imgCircleE.hidden=YES;
        _imgCircleF.hidden=YES;
        _imgCircleM.hidden=YES;
        ProcessClicked=!ProcessClicked;
    }
    else
    {
        _btnMissingCount.hidden=NO;
        _btnFoundCount.hidden=NO;
        _btnExtraCount.hidden=NO;
        _imgCircleE.hidden=NO;
        _imgCircleF.hidden=NO;
        _imgCircleM.hidden=NO;
        ProcessClicked=!ProcessClicked;
    }
}

- (IBAction)foundBtnClicked:(id)sender
{
    [self getFoundTagFromStockTable];
    TagViewController * tvc=[[TagViewController alloc]init];
    tvc.titleText=@"FOUND";

    if ([_btnTagCount.titleLabel.text isEqualToString:@"0"] ||  processing==NO || _foundTagArray==nil)
    {
        // Make toast with a title
        
        [self.navigationController.view makeToast:@"Please Process data to view FOUND tags!" duration:2.2 position:CSToastPositionBottom title:nil image:nil style:nil completion:^(BOOL didTap) {
            _btnTagCount.userInteractionEnabled=YES;
        }];
    }
    else
    {
        tvc.S_FoundArray=[[NSMutableArray alloc]init];
        tvc.S_FoundArray=_PassedFoundArray;
        [self.navigationController pushViewController:tvc animated:YES];

    }
}

- (IBAction)missingBtnClicked:(id)sender
{
    [self getMissingTagFromStockTable];
    
    TagViewController * tvc=[[TagViewController alloc]init];
    tvc.titleText=@"MISSING";
    
    if ([_btnTagCount.titleLabel.text isEqualToString:@"0"] ||  processing==NO || _missingTaggArray==nil)
    {
        // Make toast with a title
        
        [self.navigationController.view makeToast:@"Please Process data to view MISSING tags!" duration:2.2 position:CSToastPositionBottom title:nil image:nil style:nil completion:^(BOOL didTap) {
            _btnTagCount.userInteractionEnabled=YES;
        }];
    }
    else
    {
        tvc.S_MissingArray=[[NSMutableArray alloc]init];
        tvc.S_MissingArray=_PassedMissingArray;
        [self.navigationController pushViewController:tvc animated:YES];
    }
}

- (IBAction)extraBtnClicked:(id)sender
{
    [self getExtraTagFromStockTable];
    if ([_btnTagCount.titleLabel.text isEqualToString:@"0"] ||  processing==NO || _extraTagArray==nil)
    {
        // Make toast with a title
        
        [self.navigationController.view makeToast:@"Please Process data to view EXTRA tags!" duration:2.2 position:CSToastPositionBottom title:nil image:nil style:nil completion:^(BOOL didTap) {
            _btnTagCount.userInteractionEnabled=YES;
        }];
    }
    else
    {
        TagListViewController * tlvc=[[TagListViewController alloc]init];
        tlvc.getFunction=@"EXTRA";
        NSLog(@"%ld",(unsigned long)[_PassedExtraArray count]);
        
        tlvc.T_ExtraArray=_PassedExtraArray;
        [self.navigationController pushViewController:tlvc animated:YES];
    }
}

//Get All Found Tags from Stock File Core data table
-(void)getFoundTagFromStockTable
{
    _PassedFoundArray =[[NSMutableArray alloc]init];

    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (context == nil)
    {
        NSLog(@"Nil");
    }
    else
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"StockFile" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        for (int i=0; i<[_foundTagArray count]; i++)
        {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"item_Code==%@", [_foundTagArray objectAtIndex:i]];
            [fetchRequest setPredicate:predicate];
            
            NSError *error;
            
            
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
            for (StockFile *installProj in fetchedObjects)
            {
                
                
                NSMutableDictionary *tempTagObjectDict = [[ NSMutableDictionary alloc] init];
                [tempTagObjectDict setObject:installProj.item_Code forKey:@"item_Code"];
                [tempTagObjectDict setObject:installProj.qty forKey:@"qty"];
                [tempTagObjectDict setObject:installProj.gross_Wt forKey:@"gross_Wt"];
                [tempTagObjectDict setObject:installProj.category forKey:@"category"];
                [tempTagObjectDict setObject:installProj.item_Description forKey:@"item_Description"];
                [tempTagObjectDict setObject:installProj.tag_Price forKey:@"tag_Price"];
                [_PassedFoundArray addObject:tempTagObjectDict];
            }
        }
    }
}

//Get All Missing Tags from Stock File Core data table
-(void)getMissingTagFromStockTable
{
    _PassedMissingArray =[[NSMutableArray alloc]init];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (context == nil)
    {
        NSLog(@"Nil");
    }
    else
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"StockFile" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        for (int i=0; i<[_missingTaggArray count]; i++)
        {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"item_Code==%@", [_missingTaggArray objectAtIndex:i]];
            [fetchRequest setPredicate:predicate];
            
            NSError *error;
            
            
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
            for (StockFile *installProj in fetchedObjects)
            {
                
                
                NSMutableDictionary *tagObjectDict = [[ NSMutableDictionary alloc] init];
                [tagObjectDict setObject:installProj.item_Code forKey:@"item_Code"];
                [tagObjectDict setObject:installProj.qty forKey:@"qty"];
                [tagObjectDict setObject:installProj.gross_Wt forKey:@"gross_Wt"];
                [tagObjectDict setObject:installProj.category forKey:@"category"];
                [tagObjectDict setObject:installProj.item_Description forKey:@"item_Description"];
                [tagObjectDict setObject:installProj.tag_Price forKey:@"tag_Price"];
                [_PassedMissingArray addObject:tagObjectDict];
            }
        }
    }
}

//Get All Extra Tags from Stock File Core data table
-(void)getExtraTagFromStockTable
{
    _PassedExtraArray =[[NSMutableArray alloc]init];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (context == nil)
    {
        NSLog(@"Nil");
    }
    else
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"TagsSC" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSLog(@"%ld",(unsigned long)[_extraTagArray count]);
        
        
        for (int i=0; i<[_extraTagArray count]; i++)
        {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"srNumber==%@", [_extraTagArray objectAtIndex:i]];
            [fetchRequest setPredicate:predicate];
            
            NSError *error;
            
            
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
            NSMutableDictionary *tagObjectDict;
            for (TagsSC *installProj in fetchedObjects)
            {
                
                
                 tagObjectDict= [[ NSMutableDictionary alloc] init];
                [tagObjectDict setObject:installProj.srNumber forKey:@"srNumber"];
                [tagObjectDict setObject:installProj.quantity forKey:@"quantity"];
                [tagObjectDict setObject:installProj.scanDateTime forKey:@"scanDateTime"];
                
                [_PassedExtraArray addObject:tagObjectDict];
            }
        }
        NSLog(@"%ld",(unsigned long)[_PassedExtraArray count]);

    }
}


- (IBAction)bluetoothBtnClicked:(id)sender
{
    
}

- (IBAction)syncFileBtnClicked:(id)sender
{
    
}

- (IBAction)clearBtnClicked:(id)sender
{
    UIAlertController *alt=[UIAlertController alertControllerWithTitle:APP_NAME message:@"Confirm Clear !" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* no = [UIAlertAction
                         actionWithTitle:@"No"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alt dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    UIAlertAction* yes = [UIAlertAction
                          actionWithTitle:@"Yes"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              [_circularProgress setValue:0.0 animateWithDuration:0.8];

                              [self removeAllPreviousScannedTag];
                              
                              [_btnTagCount setTitle:[NSString stringWithFormat:@"0"     ] forState:UIControlStateNormal];
                              [_btnMissingCount setTitle:[NSString stringWithFormat:@"0\nMissing"] forState:UIControlStateNormal];
                              [_btnExtraCount setTitle:[NSString stringWithFormat:@"0\nExtra"] forState:UIControlStateNormal];
                              [_btnFoundCount setTitle:[NSString stringWithFormat:@"0\nFound"] forState:UIControlStateNormal];

                              processing=NO;
                          }];
    
    [alt addAction:no];
    [alt addAction:yes];
    
    [self presentViewController:alt animated:YES completion:nil];


}

- (IBAction)processBtnClicked:(id)sender
{
    isProcessed=YES;
    
    if (ProcessClicked==NO) {
        _btnMissingCount.hidden=NO;
        _btnFoundCount.hidden=NO;
        _btnExtraCount.hidden=NO;
        _imgCircleE.hidden=NO;
        _imgCircleF.hidden=NO;
        _imgCircleM.hidden=NO;
        ProcessClicked=!ProcessClicked;
        
    }

    _foundTagArray=[[NSMutableArray alloc]init];
    _missingTaggArray=[[NSMutableArray alloc]init];
    _extraTagArray=[[NSMutableArray alloc]init];

    def=[NSUserDefaults standardUserDefaults];
    NSString *str=[def valueForKey:@"isSkip"];
    
    if ([str isEqualToString:@"YES"])
    {
        
        [self.navigationController.view makeToast:@"Please Load Stock File to Process the Tags!" duration:2.2 position:CSToastPositionBottom title:nil image:nil style:nil completion:^(BOOL didTap) {

        }];

    }
    else
    {
        if ([_btnTagCount.titleLabel.text isEqualToString:@"0"])
        {
            
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Loading...";
            [hud show:YES];
            processing=YES;

        // Fetch the Tags from persistent data store
            NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TagsSC"];
            _scannedtags = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            
            for (int i=0; i<[_scannedtags count]; i++) {
                
                NSDictionary * dict=[_scannedtags objectAtIndex:i];
                NSString * str=[[NSString alloc]init];
                str=[dict valueForKey:@"srNumber"];
                [_extraTagArray addObject:str];
            }
            
        //Get FOUND Tags
            NSManagedObjectContext *managedObjectContextSF = [self managedObjectContext];
            NSFetchRequest *fetchRequestSF = [[NSFetchRequest alloc] initWithEntityName:@"StockFile"];
            _stockFiletags = [[managedObjectContextSF executeFetchRequest:fetchRequestSF error:nil] mutableCopy];
            
            NSMutableArray * tagSFName=[[NSMutableArray alloc]init];
            for (int i=0; i<[_stockFiletags count]; i++)
            {
                NSDictionary * dict=[_stockFiletags objectAtIndex:i];
                NSString * str=[[NSString alloc]init];
                str=[dict valueForKey:@"item_Code"];
                [tagSFName addObject:str];
            }

            for(int i = 0;i<[tagSFName count];i++)
            {
                for(int j= 0;j<[_extraTagArray count];j++)
                {
                    if([[tagSFName objectAtIndex:i] isEqualToString:[_extraTagArray objectAtIndex:j]])
                    {
                        [_foundTagArray addObject:[tagSFName objectAtIndex:i]];
                        break;
                    }
                }
            }
            
            [_circularProgress setValue:[_foundTagArray count] animateWithDuration:1.2];
            
            [_btnFoundCount setTitle:[NSString stringWithFormat:@"%ld\nFound",[_foundTagArray count]] forState:UIControlStateNormal  ];
            NSLog(@"FOUND TAGS : \n %@",_foundTagArray);
            
            
        //Get EXTRA Count
            
            
            for(int i = 0;i<[tagSFName count];i++)
            {
                for(int j= 0;j<[_extraTagArray count];j++)
                {
                    if([[tagSFName objectAtIndex:i] isEqualToString:[_extraTagArray objectAtIndex:j]])
                    {
                        [_extraTagArray removeObjectAtIndex:j];
                        break;
                    }
                }
            }
            
            [_btnExtraCount setTitle:[NSString stringWithFormat:@"%ld\nExtra",[_extraTagArray count]] forState:UIControlStateNormal  ];
            NSLog(@"EXTRA TAGS : \n %@",_extraTagArray);

            
        //Get MISSING Count
           
            NSMutableArray * ScannedTagName=[[NSMutableArray alloc]init];
            for (int i=0; i<[_scannedtags count]; i++) {
                
                NSDictionary * dict=[_scannedtags objectAtIndex:i];
                NSString * str=[[NSString alloc]init];
                str=[dict valueForKey:@"srNumber"];
                [ScannedTagName addObject:str];
            }
            
            for (int i=0; i<[_stockFiletags count]; i++)
            {
                
                NSDictionary * dict=[_stockFiletags objectAtIndex:i];
                NSString * str=[[NSString alloc]init];
                str=[dict valueForKey:@"item_Code"];
                [_missingTaggArray addObject:str];
            }
            [_missingTaggArray removeObjectsInArray:ScannedTagName];

            [_btnMissingCount setTitle:[NSString stringWithFormat:@"%ld\nMissing",[_missingTaggArray count]] forState:UIControlStateNormal  ];
            NSLog(@"MISSING TAGS : \n %@",_missingTaggArray);
            
            [hud hide:YES];
            
        }
    }
}

- (IBAction)sendBtnClicked:(id)sender
{
    def=[NSUserDefaults standardUserDefaults];
    NSString *str=[def valueForKey:@"isSkip"];
    
    if (isProcessed==NO)
    {
        [self.navigationController.view makeToast:@"Please Process data to Send the Stock File(s)!" duration:2.2 position:CSToastPositionBottom title:nil image:nil style:nil completion:^(BOOL didTap) {
            
        }];
    }
    else if ([str isEqualToString:@"YES"])
    {
        [self.navigationController.view makeToast:@"Please Load Stock File to Send the Stock File(s)!" duration:2.2 position:CSToastPositionBottom title:nil image:nil style:nil completion:^(BOOL didTap) {
            
            
        }];
    }
    else
    {
        [self createCSV];
    }
}



-(void)createCSV
{
    [self getFoundTagFromStockTable];
    [self getMissingTagFromStockTable];
    [self getExtraTagFromStockTable];
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSMutableArray *resultsSRD = [[NSMutableArray alloc]init];
    //Create Stock .csv file
    
    [results addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",@"Stock Menu",@"Serial No",@"Description",@"Category",@"Qty",@"Weight",@"Price"]];
    NSDictionary * tempDictF;
    
    for (int i=0; i<[_PassedFoundArray count]; i++)
    {
        tempDictF=[_PassedFoundArray objectAtIndex:i];

        [results addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",@"found",[tempDictF valueForKey:@"item_Code"],[tempDictF valueForKey:@"item_Description"],[tempDictF valueForKey:@"category"],[tempDictF valueForKey:@"qty"],[tempDictF valueForKey:@"gross_Wt"],[tempDictF valueForKey:@"tag_Price"]]];
    }
    
    NSDictionary * tempDictM;

    for (int i=0; i<[_PassedMissingArray count]; i++)
    {
        tempDictM=[_PassedMissingArray objectAtIndex:i];
        
        [results addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",@"missing",[tempDictM valueForKey:@"item_Code"],[tempDictM valueForKey:@"item_Description"],[tempDictM valueForKey:@"category"],[tempDictM valueForKey:@"qty"],[tempDictM valueForKey:@"gross_Wt"],[tempDictM valueForKey:@"tag_Price"]]];
    }

    NSDictionary * tempDictE;
    
    for (int i=0; i<[_PassedExtraArray count]; i++)
    {
        tempDictE=[_PassedExtraArray objectAtIndex:i];
        
        [results addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",@"extra",[tempDictE valueForKey:@"srNumber"],@"",@"",@"",@"",@""]];
    }
    NSString *resultString = [results componentsJoinedByString:@" \n"];
    
    //create SRD file
    NSManagedObjectContext *moc = [self managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"TagsSC" inManagedObjectContext:moc]];
    
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"quantity" ascending:YES]]];
    NSError *error = nil;
    NSArray *tagItems = [moc executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"Error fetching the Tags entities: %@", error);
    }
    else
    {
        for (TagsSC *tagitem in tagItems)
        {
            [resultsSRD addObject:[NSString stringWithFormat:@"%@:%@", tagitem.srNumber,tagitem.scanDateTime]];
        }
    }
    
    NSString *resultStringSRD = [resultsSRD componentsJoinedByString:@",\n"];
    
    if ( [MFMailComposeViewController canSendMail] )
    {
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        NSData *myData = [resultString dataUsingEncoding:NSUTF8StringEncoding];

        NSData *myDataSRD = [resultStringSRD dataUsingEncoding:NSUTF8StringEncoding];

        //Set Subject
        [mailComposer setSubject:@"Stock Check Report"];
        
        //set attachment
        NSDateFormatter *formatter;
        NSString        *dateString;
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd_MM_yyyy_HH:mm:ss"];
        dateString = [formatter stringFromDate:[NSDate date]];
        NSString * deviceID=[utilees GetDeviceID];
        NSString *strFileNameDateTime=[NSString stringWithFormat:@"Stock_Check_Summary_report_%@.csv",dateString];
        NSString *strFileNameDateTimeSRD=[NSString stringWithFormat:@"SRD_%@_%@.srd",deviceID,dateString];

        if (isMultiple==YES)
        {
            // Fill out the email body text
            NSString *emailBody = @"Hi,\n\nPlease find the Stock Check Summary Report and SRD file.\n\n";
            [mailComposer setMessageBody:emailBody isHTML:NO];
            [mailComposer addAttachmentData:myData mimeType:@"text/cvs" fileName:strFileNameDateTime];
            [mailComposer addAttachmentData:myDataSRD mimeType:@"text/srd" fileName:strFileNameDateTimeSRD];
        }
        else
        {
            // Fill out the email body text
            NSString *emailBody = @"Hi,\n\nPlease find the Stock Check Summary Report.\n\n";
            [mailComposer setMessageBody:emailBody isHTML:NO];
            [mailComposer addAttachmentData:myData mimeType:@"text/cvs" fileName:strFileNameDateTime];
        }
        [self presentViewController:mailComposer animated:YES completion:NULL];
        
    }
}

#pragma mark MFMailComposerDelegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
