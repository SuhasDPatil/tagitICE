 //
//  BluetoothScanViewController.m
//  tagitICE
//
//  Created by suhas on 20/06/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "BluetoothScanViewController.h"

@interface BluetoothScanViewController ()
{
    NSArray * _accessoryList;
    NSInteger _selectedRow;
    UIView *nomatchesView;
    
    
    EAAccessory *_currentAccessory;
    TSLAsciiCommander *_commander;
    TSLInventoryCommand *_inventoryResponder;
    TSLBarcodeCommand *_barcodeResponder;
    
    int _transpondersSeen;
    NSString *_partialResultMessage;

}

@end

@implementation BluetoothScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //New Methods
    
    // Listen for accessory connect/disconnects
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    
    _accessoryList = [[EAAccessoryManager sharedAccessoryManager] connectedAccessories];
    
    _selectedRow = 0;
    
    
    
    // Create the TSLAsciiCommander used to communicate with the TSL Reader
    _commander = [[TSLAsciiCommander alloc] init];
    
    // TSLAsciiCommander requires TSLAsciiResponders to handle incoming reader responses
    
    // Add a logger to the commander to output all reader responses to the log file
    [_commander addResponder:[[TSLLoggerResponder alloc] init]];
    
    // Some synchronous commands will be used in the app
    [_commander addSynchronousResponder];
    
    
    nomatchesView.hidden=YES;
    _tableView.hidden=NO;
    
    
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    self.title=@"Tagit ICE";

    [[self.btnScan layer] setBorderWidth:5.0f];
    [[self.btnScan layer] setBorderColor:[UIColor clearColor].CGColor];
    [[self.btnScan layer]setCornerRadius:4.5f];

    [[self.viewBorder1 layer] setBorderWidth:5.0f];
    [[self.viewBorder1 layer] setBorderColor:[UIColor clearColor].CGColor];
    [[self.viewBorder1 layer]setCornerRadius:4.5f];
    
    [self setNavBar];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ScanViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    
    // Listen for change in TSLAsciiCommander state
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commanderChangedState) name:TSLCommanderStateChangedNotification object:_commander];
    
    // Update list of connected accessories
    _accessoryList = [[EAAccessoryManager sharedAccessoryManager] connectedAccessories];

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidConnect:) name:EAAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidDisconnect:) name:EAAccessoryDidDisconnectNotification object:nil];
    
    if([UIScreen mainScreen].bounds.size.width>=700)
    {
      
        _btnScan.titleLabel.font = [UIFont boldSystemFontOfSize:30 ];
        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,90)];
    }
    else
    {
        
        _btnScan.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)scanClicked:(id)sender
{
    // start scanning button
    
    _accessoryList = [[EAAccessoryManager sharedAccessoryManager] connectedAccessories];

    
    [[EAAccessoryManager sharedAccessoryManager] showBluetoothAccessoryPickerWithNameFilter:nil completion:^(NSError *error)
     {
         NSLog(@"%@",UIApplicationLaunchOptionsBluetoothPeripheralsKey);
         
         if( error == nil )
         {
             // Inform the user that the device is being connected
             //             _hud = [TSLProgressHUD updateHUD:_hud inView:self.view forBusyState:YES withMessage:@"Waiting for device..."];
         }
         else
         {
             NSString *errorMessage = nil;
             switch (error.code)
             {
                 case EABluetoothAccessoryPickerAlreadyConnected:
                 {
                     NSLog(@"AlreadyConnected");
                     errorMessage = @"That device is already paired!\n\nTry again and wait a few seconds before choosing. Already paired devices will disappear from the list!";
                 }
                     break;
                     
                 case EABluetoothAccessoryPickerResultFailed:
                     
                 case EABluetoothAccessoryPickerResultNotFound:
                     NSLog(@"NotFound");
                     errorMessage = @"Unable to find that device!\n\nEnsure the device is powered on and that the blue LED is flashing.";
                     break;
                     
                 case EABluetoothAccessoryPickerResultCancelled:
                     NSLog(@"Cancelled");
                     break;
                     
                 default:
                     break;
             }
             if( errorMessage )
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pairing failed..." message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil ];
                 [alert show];
             }
         }
     }];
}





#pragma mark UITableViewDelegate and UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ( _accessoryList.count == 0 ) ? 1 : _accessoryList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScanViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    cell.layoutMargins = UIEdgeInsetsZero;
    
    if( _accessoryList.count == 0 )
    {
  
        
        nomatchesView = [[UIView alloc] initWithFrame:self.view.frame];
        nomatchesView.backgroundColor = [UIColor clearColor];
        
        UILabel *matchesLabel;
        if ([[UIScreen mainScreen] bounds].size.width ==320)
        {
            matchesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,65)];
        }
        else if ([[UIScreen mainScreen] bounds].size.width ==375)
        {
            matchesLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 375, 70)];
        }
        else if ([[UIScreen mainScreen] bounds].size.width ==621)
        {
            matchesLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 621, 80)];
        }
        
        matchesLabel.font = [UIFont boldSystemFontOfSize:18];
        matchesLabel.minimumFontSize = 12.0f;
        matchesLabel.numberOfLines = 3;
        matchesLabel.lineBreakMode = UILineBreakModeWordWrap;
        matchesLabel.shadowColor = [UIColor lightTextColor];
        matchesLabel.textColor = [UIColor darkGrayColor];
        matchesLabel.shadowOffset = CGSizeMake(0, 1);
        matchesLabel.backgroundColor = [UIColor clearColor];
        matchesLabel.textAlignment =  UITextAlignmentCenter;
        
        //Here is the text for when there are no results
        matchesLabel.text = @"Not Found";
        
        nomatchesView.hidden = NO;
        _tableView.hidden = YES;
        [nomatchesView addSubview:matchesLabel];
        [self.view insertSubview:nomatchesView aboveSubview:self.tableView];

        
    }
    else if( indexPath.row >= 0 )
    {
        nomatchesView.hidden = YES;
        _tableView.hidden=NO;
        EAAccessory * accessory = [_accessoryList objectAtIndex:indexPath.row];
        cell.lblDeviceName.text=accessory.serialNumber;
//        cell.lblDeviceNumber.text=[NSString stringWithFormat:@"FW: v%@    HW: v%@", accessory.firmwareRevision, accessory.hardwareRevision];
        
        cell.lblDeviceNumber.text=[NSString stringWithFormat:@"%d", (int)accessory.connectionID];

        if (accessory.isConnected==YES)
        {
            cell.lblPaired.text=@"paired";
        }
        else
        {
            cell.lblPaired.text=@"New";
        }
        NSLog(@"Accessory Details : %@", accessory);

    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    [hud show:YES];

    if( _accessoryList.count > 0 )
    {
        _selectedRow = indexPath.row;
//        [self.delegate didSelectReaderForRow:_selectedRow];
        
        [self didSelectReaderForRow:_selectedRow];
    }
    
}

-(void)didSelectReaderForRow:(NSInteger)row
{
    // Disconnect from the current reader, if any
    [_commander disconnect];
    
    // Connect to the chosen TSL Reader
    if( _accessoryList.count > 0 )
    {
        // The row is the offset into the list of connected accessories
        _currentAccessory = [_accessoryList objectAtIndex:row];
        [_commander connect:_currentAccessory];
    }
    
    // Prepare and show the connected reader
    [self initAndShowConnectedReader];
}

-(void)initAndShowConnectedReader
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    [hud show:YES];

    // Prepare and show the connected reader
    if( _commander.isConnected )
    {
        // Display the serial number of the successfully connected unit
        NSLog(@"Selected Reader : %@",_currentAccessory.serialNumber);
        // Ensure the reader is in a known (default) state
        // No information is returned by the reset command
        TSLFactoryDefaultsCommand * resetCommand = [TSLFactoryDefaultsCommand synchronousCommand];
        [_commander executeCommand:resetCommand];
        
        // Notify user device has been reset
        if( resetCommand.isSuccessful )
        {
        }
        else
        {
        }
        
        // Get version information for the reader
        // Use the TSLVersionInformationCommand synchronously as the returned information is needed below
        TSLVersionInformationCommand * versionCommand = [TSLVersionInformationCommand synchronousCommand];
        [_commander executeCommand:versionCommand];
        TSLBatteryStatusCommand *batteryCommand = [TSLBatteryStatusCommand synchronousCommand];
        [_commander executeCommand:batteryCommand];
        
        
        // Display some of the values obtained
        
        NSLog(@"\nManufacturer:  %@\nSerial Number:  %@\nASCII Protocl:  %@\nBattery Level:  %@\n\n",
              versionCommand.manufacturer,
              versionCommand.serialNumber,
              versionCommand.asciiProtocol,
              [NSString stringWithFormat:@"%d%%", batteryCommand.batteryLevel]);
        
    
        ConsignmentViewController *cvc=[[ConsignmentViewController alloc]init];
        
        cvc.commander=_commander;
        
        [self.navigationController pushViewController:cvc animated:YES];

//        MainVC * mvc=[[MainVC alloc]init];
//        
//        mvc.commander=_commander;
//        
//        [self.navigationController pushViewController:mvc animated:YES];

        
        
        
//        [self.navigationController pushViewController:cvc animated:YES];
        
        // Ensure new information is visible
        //        [self.resultsTextView scrollRangeToVisible:NSMakeRange(self.resultsTextView.text.length - 1, 1)];
        
    }
    else
    {
        //        [self.selectReaderButton setTitle:@"Tap to select reader..." forState:UIControlStateNormal];
        NSLog(@"Select Reader");
    }
    [hud hide:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}



#pragma mark New Methods
#pragma mark Keep the list of connected devices up-to-date

-(void) _accessoryDidConnect:(NSNotification *)notification
{
    EAAccessory *connectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    // Only notify of change if the accessory added has valid protocol strings
    if( connectedAccessory.protocolStrings.count != 0 )
    {
        _accessoryList = [[EAAccessoryManager sharedAccessoryManager] connectedAccessories];
        
        [self.tableView reloadData];
    }
}

- (void)_accessoryDidDisconnect:(NSNotification *)notification
{
    //    EAAccessory *disconnectedAccessory = (EAAccessory *)[notification.userInfo objectForKey:@"EAAccessorySelectedKey"];
    
    _accessoryList = [[EAAccessoryManager sharedAccessoryManager] connectedAccessories];
    
    [self.tableView reloadData];
}


-(void)commanderChangedState
{
    // Update the 'select reader' button
    if( !_commander.isConnected )
    {
        NSLog(@"**********************************************");
    }
}




#pragma mark User Defined

-(void)setNavBar
{
    UIApplication *app = [UIApplication sharedApplication];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -app.statusBarFrame.size.height, self.view.bounds.size.width, app.statusBarFrame.size.height)];
    statusBarView.backgroundColor = [UIColor blackColor];

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
    //Back Button
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"b"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 10, 16);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
