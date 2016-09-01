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

    CommoninventoryCommand *_inventoryResponder;
//    TSLBarcodeCommand *_barcodeResponder;
    
    SelectReaderInfo * _commander;
    int _transpondersSeen;
    NSString *_partialResultMessage;
    BOOL processing;

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

    [self removeAllPreviousScannedTag];
    processing=NO;

    [self setProcess:NO];
    
    processing=[self isProcessed];
    

    self.title=@"Consignment";
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
                       });
    };
    
    [_commander addResponder:_inventoryResponder];    // Add the inventory responder to the commander's responder chain
    
    _transpondersSeen = 0;    // No transponders seen yet
    
    _partialResultMessage = @"";
    
//    Check For Inventory
//    if( _commander.isConnected )
//    {
//        TSLInventoryCommand *invCommand = [[TSLInventoryCommand alloc] init]; // Use the TSLInventoryCommand
//
//        invCommand.includeTransponderRSSI = TSL_TriState_NO;
//
//        [_commander executeCommand:invCommand];
//    }
    [_btnTagCount setTitle:@"0" forState:UIControlStateNormal];
    
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commanderChangedState) name:TSLCommanderStateChangedNotification object:_commander];
    
    _inventoryResponder.transponderReceivedDelegate = self;    // Add self as the transponder delegate
    
    _inventoryResponder.captureNonLibraryResponses = YES;

    
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

-(void)commanderChangedState
{
    // Update the 'select reader' button
    if( !_commander.isConnected )
    {
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
    
    processing=NO;

    NSString *str=[NSString stringWithFormat:@"%-28s",[epc UTF8String]];
    
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
    _transpondersSeen++;
    
    // If this is the last transponder add a few blank lines
    if( !moreAvailable )
    {
        _partialResultMessage = [_partialResultMessage stringByAppendingFormat:@"\nTransponders seen: %4d\n\n", _transpondersSeen];
    }
    
    [_btnTagCount setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[_array count]] forState:UIControlStateNormal];

}


#pragma mark User Defined methods

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



#pragma mark Button CLick methods

- (IBAction)clearClicked:(id)sender
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
                             [self removeAllPreviousScannedTag];
                             processing=NO;
                         }];

    [alt addAction:no];
    [alt addAction:yes];

    [self presentViewController:alt animated:YES completion:nil];
}

-(void)removeAllPreviousScannedTag
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    [hud show:YES];
    
    
    _array=nil;
    [TagcountArray removeAllObjects];
    
    
    
    //    [_btnTagCount setTitle:@"0" forState:UIControlStateNormal];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tags" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
        NSLog(@"%@ object deleted",@"Tags");
    }
    if (![context save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",@"Tags",error);
    }
    [hud hide:YES];
    [_btnTagCount setTitle:[NSString stringWithFormat:@"%ld",[_array count]] forState:UIControlStateNormal];

}
- (IBAction)processClicked:(id)sender
{
//    _btnProcess.userInteractionEnabled=NO;
    
    if ([_btnTagCount.titleLabel.text isEqualToString:@"0"])
    {
        
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
        [hud show:YES];
        [self checkForDuplicates];
        processing=YES;
        [hud hide:YES];
    }
}


-(void)checkForDuplicates
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tags"
                                              inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"srNumber" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *Fetcherror;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&Fetcherror] mutableCopy];
    
    if (!mutableFetchResults)
    {
        // error handling code.
    }
    
    for (int i=0; i<[_array count]; i++)
    {
        if ([[mutableFetchResults valueForKey:@"srNumber"] containsObject:[_array objectAtIndex:i]])
        {
            NSLog(@"Duplicate Found");
            
        }
        else
        {
            //write your code to add data
            Tags *newtag = [NSEntityDescription insertNewObjectForEntityForName:@"Tags" inManagedObjectContext:context];
            [newtag setValue:[_array objectAtIndex:i] forKey:@"srNumber"];
            [newtag setValue:@"1" forKey:@"quantity"];
        }
    }
     NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error])
    {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    [_btnTagCount setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[_array count]] forState:UIControlStateNormal];
}

- (IBAction)sendClicked:(id)sender
{
    if ([_btnTagCount.titleLabel.text isEqualToString:@"0"] ||  processing==NO)
    {
        // Make toast with a title
        _btnSend.userInteractionEnabled=NO;
        [self.navigationController.view makeToast:@"Please Process data to send tags!" duration:2.2 position:CSToastPositionBottom title:nil image:nil style:nil completion:^(BOOL didTap) {
            _btnSend.userInteractionEnabled=YES;
        }];
    }
    else
    {
        [self createCSV];
    }
}

- (IBAction)tagCountClicked:(id)sender
{
    if ([_btnTagCount.titleLabel.text isEqualToString:@"0"] ||  processing==NO)
    {
        // Make toast with a title
        _btnTagCount.userInteractionEnabled=NO;
        [self.navigationController.view makeToast:@"Please Process data to view tags!" duration:2.2 position:CSToastPositionBottom title:nil image:nil style:nil completion:^(BOOL didTap) {
            _btnTagCount.userInteractionEnabled=YES;
        }];
    }
    else
    {
        TagListViewController * tlvc=[[TagListViewController alloc]init];
        tlvc.getFunction=@"CONSIGNMENT";
        [self.navigationController pushViewController:tlvc animated:YES];
    }
}

-(void)createCSV
{
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Tags" inManagedObjectContext:moc]];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"quantity" ascending:YES]]];
    NSError *error = nil;
    NSArray *tagItems = [moc executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"Error fetching the Tags entities: %@", error);
    }
    else
    {
        [results addObject:[NSString stringWithFormat:@"%@ ,%@",@"Serial No",@"Qty"]];
        
        for (Tags *tagitem in tagItems)
        {
            [results addObject:[NSString stringWithFormat:@"%@ ,%@ ", tagitem.srNumber,tagitem.quantity]];
        }
    }
    NSString *resultString = [results componentsJoinedByString:@" \n"];
    
    if ( [MFMailComposeViewController canSendMail] )
    {
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        NSData *myData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
        //Set Subject
        [mailComposer setSubject:@"Consignment Report"];
        // Fill out the email body text
        NSString *emailBody = @"Hi,\n\nPlease find the Consignment Summary Report.\n\n";
        [mailComposer setMessageBody:emailBody isHTML:NO];
        
        //set attachment
        NSDateFormatter *formatter;
        NSString        *dateString;
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd_MM_yyyy_HH:mm:ss"];
        dateString = [formatter stringFromDate:[NSDate date]];
        NSString *strFileNameDateTime=[NSString stringWithFormat:@"Consignment_report_%@.csv",dateString];
        [mailComposer addAttachmentData:myData mimeType:@"text/cvs" fileName:strFileNameDateTime];
        
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
