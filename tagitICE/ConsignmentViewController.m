//
//  ConsignmentViewController.m
//  tagitICE
//
//  Created by suhas on 06/07/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "ConsignmentViewController.h"

@interface ConsignmentViewController ()
{
    NSArray * _accessoryList;
    
    EAAccessory *_currentAccessory;

    TSLInventoryCommand *_inventoryResponder;
//    TSLBarcodeCommand *_barcodeResponder;
    
    int _transpondersSeen;
    NSString *_partialResultMessage;

}
@end

@implementation ConsignmentViewController


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
    
    
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:203.0f/255.0f green:32.0f/255.0f blue:45.0f/255.0f alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;

    //Back Button
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    //    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 0, 0);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;

    
    self.title=@"Consignment";

    
    // Create the TSLAsciiCommander used to communicate with the TSL Reader
        

    
    

    // Create a TSLInventoryCommand
    _inventoryResponder = [[TSLInventoryCommand alloc] init];
    
    // Add self as the transponder delegate
    _inventoryResponder.transponderReceivedDelegate = self;
    
    // Pulling the Reader trigger will generate inventory responses that are not from the library.
    // To ensure these are also seen requires explicitly requesting handling of non-library command responses
    _inventoryResponder.captureNonLibraryResponses = YES;
    
    
    
    
    // Use the responseBeganBlock and responseEndedBlock to change the colour of the reader label while a response is being received
    //
    // Note: the weakSelf is used to avoid warning of retain cycles when self is used
    __weak typeof(self) weakSelf = self;
    
    _inventoryResponder.responseBeganBlock = ^
    {
        dispatch_async(dispatch_get_main_queue(),^
                       {
//                           weakSelf.selectReaderButton.backgroundColor = [UIColor blueColor];
//                           weakSelf.selectReaderButton.titleLabel.textColor = [UIColor whiteColor];

                       });
    };
    _inventoryResponder.responseEndedBlock = ^
    {
        dispatch_async(dispatch_get_main_queue(),^
                       {
//                           weakSelf.selectReaderButton.backgroundColor = weakSelf.defaultSelectReaderBackgroundColor;
//                           weakSelf.selectReaderButton.titleLabel.textColor = weakSelf.defaultSelectReaderTextColor;

                       
                       });
    };
    
    
    
    // Add the inventory responder to the commander's responder chain
    [_commander addResponder:_inventoryResponder];
    
    
    // No transponders seen yet
    _transpondersSeen = 0;
    
    _partialResultMessage = @"";
    
    
    //Check For Inventory
    if( _commander.isConnected )
    {
        // Use the TSLInventoryCommand
        TSLInventoryCommand *invCommand = [[TSLInventoryCommand alloc] init];
        
        invCommand.includeTransponderRSSI = TSL_TriState_NO;
        
        
        // See if Impinj FastId is to be used
//        invCommand.useFastId = self.fastIdSwitch.isOn ? TSL_TriState_YES : TSL_TriState_NO;
//        
//        int value = [self outputPowerFromSliderValue:self.outputPowerSlider.value];
//        invCommand.outputPower = value;
        
        [_commander executeCommand:invCommand];
    }


    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commanderChangedState) name:TSLCommanderStateChangedNotification object:_commander];
//    _accessoryList = [[EAAccessoryManager sharedAccessoryManager] connectedAccessories];

}

-(void)commanderChangedState
{
    // Update the 'select reader' button
    if( !_commander.isConnected )
    {
//        [self.selectReaderButton setTitle:@"Tap to select reader..." forState:UIControlStateNormal];
    }
    else
    {
        [self setReaderOutputPower];
    }
}
-(void)setReaderOutputPower
{
    if( _commander.isConnected )
    {
//        int value = [self outputPowerFromSliderValue:self.outputPowerSlider.value];
        int value = 27;
        TSLInventoryCommand *command = [TSLInventoryCommand synchronousCommand];
        command.takeNoAction = TSL_TriState_YES;
        command.outputPower = value;
        [_commander executeCommand:command];
    }
}


- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)didReceiveMemoryWarning {
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
    
    NSString *str=[NSString stringWithFormat:@"%-28s",[epc UTF8String]];
    
    

    // The hex codes should all be two characters.

    
    for (NSInteger i = 0; i < [epc length]; i += 2)
    {
        
        NSString *hex = [epc substringWithRange:NSMakeRange(i, 2)];
        
        NSLog(@"%@",hex);

        NSMutableString * newString = [[NSMutableString alloc] init] ;
        int i = 0;
        while (i < [hex length])
        {
            NSString * hexChar = [hex substringWithRange: NSMakeRange(i, 2)];
            int value = 0;
            sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
            [newString appendFormat:@"%c", (char)value];
            i+=2;
        }
        NSLog(@"%@",newString);

    }
    

    NSLog(@"Particular Message: %@",_partialResultMessage);
    
    
    //Save to Core Data
    NSManagedObjectContext *context = [self managedObjectContext];
    // Create a new managed object
    Tags *newtag = [NSEntityDescription insertNewObjectForEntityForName:@"Tags" inManagedObjectContext:context];
    
    [newtag setValue:str forKey:@"srNumber"];
    [newtag setValue:@"1" forKey:@"quantity"];
    
    
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error])
    {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    
    
    
    if( fastId != nil)
    {
        _partialResultMessage = [_partialResultMessage stringByAppendingFormat:@"%-6@  %@\n", @"TID:", [TSLBinaryEncoding toBase16String:fastId]];
    }
    
    _transpondersSeen++;
    
    // If this is the last transponder add a few blank lines
    if( !moreAvailable )
    {
        _partialResultMessage = [_partialResultMessage stringByAppendingFormat:@"\nTransponders seen: %4d\n\n", _transpondersSeen];
        
        [_btnTagCount setTitle:[NSString stringWithFormat:@"%d",_transpondersSeen] forState:UIControlStateNormal];

    }
    
    NSLog(@"Updated Particular Message: %@",_partialResultMessage);

    // This changes UI elements so perform it on the UI thread
    // Avoid sending too many screen updates as it can stall the display
    if( _transpondersSeen < 3 || _transpondersSeen % 10 == 0 )
    {
        [self performSelectorOnMainThread: @selector(updateResults:) withObject:_partialResultMessage waitUntilDone:NO];
        _partialResultMessage = @"";
    }
}


-(void)updateResults:(NSString *)message
{
//    self.resultsTextView.text = [self.resultsTextView.text stringByAppendingString:message];
    
//    NSLog(@"***************************");
//
//    NSLog(@"Updated Result : %@",message);
//    
//    NSLog(@"***************************");

}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clearClicked:(id)sender
{
    [_btnTagCount setTitle:@"0" forState:UIControlStateNormal];
}

- (IBAction)processClicked:(id)sender
{
    
}

- (IBAction)sendClicked:(id)sender
{
    if ([_btnTagCount.titleLabel.text isEqualToString:@"0"]) {
        
    }
    else
    {
        
    }

}

- (IBAction)tagCountClicked:(id)sender
{
    
    if ([_btnTagCount.titleLabel.text isEqualToString:@"0"]) {
        
    }
    else
    {
        TagListViewController * tlvc=[[TagListViewController alloc]init];
        [self.navigationController pushViewController:tlvc animated:YES];
    }
}
-(void)downloadCSV
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SendCVSEMail:) name:@"csv" object:nil];
    
//    NSLog(@"%@", params);
//    NSString *roleString = role==GascReportRoleEmployer?@"employers":@"employees";
//    NSString *URLString = [[NSString alloc] initWithFormat:@"%@/%@/job-report-csv", [APIClient contentAPIBaseURL], roleString];
    
    // prepare file path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathToFile = [documentsDirectory stringByAppendingPathComponent:@"report.csv"];
    NSLog(@"path: %@", pathToFile);
    
    // operation
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"" parameters:@"" error:nil];
    
    // progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeAnnularDeterminate];
    [hud setLabelText:@"Loading.."];
    [self.navigationController.view setUserInteractionEnabled:NO];
    [hud show:YES];
    
    AFHTTPRequestOperation *requestOperation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"operation success: %@\n %@", operation, responseObject);
        NSData *data = [[NSData alloc] initWithData:responseObject];
        [data writeToFile:pathToFile atomically:YES];
        [self.navigationController.view setUserInteractionEnabled:YES];
        [hud hide:YES];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setObject:pathToFile forKey:@"csv"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"csv" object:[dict copy]];
        [[NSNotificationCenter defaultCenter] removeObserver:@"csv"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.navigationController.view setUserInteractionEnabled:YES];
        [hud hide:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:@"csv"];
        
    }];
    
    [requestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        double percentDone = (double)totalBytesRead / (double)totalBytesExpectedToRead;
        NSLog(@"progress updated(percentDone) : %f", percentDone);
        hud.progress = percentDone;
        hud.labelText = [[NSString alloc] initWithFormat:@"%@ %.2f %%",@"Loading..", percentDone * 100];
    }];
    
    [requestOperation start];

}


-(void)SendCVSEMail:(NSNotification*)Notification
{
    NSString * Path = [Notification.object objectForKey:@"csv"];
    NSString *emailTitle = @"";
    NSString *messageBody = @"Dear Grabber,\n\nKindly find attached your dedicated Job Report in CSV format.\n\n Yours sincerely,\nYour friendly GrabCrew team";
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:@[]];
    
    NSMutableString *csv = [NSMutableString stringWithString:@""];
    //add your content to the csv
    [csv appendFormat:@""];
    
    // NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // NSString* fileName = @"CSV.csv";
    // NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:Path]) {
        return;
    }else{
        [mc addAttachmentData:[NSData dataWithContentsOfFile:Path]
                     mimeType:@"text/csv"
                     fileName:@"CSV.csv"];
    }
    if (mc==nil) {
        
        NSLog(@"Login to Mail App");
        
    }
    else
    {
        [self presentViewController:mc animated:YES completion:nil];
        return;
    }
}

@end
