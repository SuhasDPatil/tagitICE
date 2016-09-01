//
//  SearchViewController.m
//  tagitICE
//
//  Created by rac on 28/07/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
{
    CommoninventoryCommand *_inventoryResponder;
    //    TSLBarcodeCommand *_barcodeResponder;
    
    SelectReaderInfo * _commander;

}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Search";

    addItemClicked=NO;
    isSoundPlayed=NO;
    
    spliStringArray=[[NSArray alloc]init];
    [_txtSearch setTextFieldPlaceholderText:@"Search Tags"];
    _txtSearch.btmLineSelectionColor = [UIColor clearColor];
    _txtSearch.placeHolderTextColor = [UIColor redColor];
    _txtSearch.selectedPlaceHolderTextColor = [UIColor redColor];
    _txtSearch.btmLineColor = [UIColor clearColor];

    _btntxtClear.hidden=YES;
    _imgClear.hidden=YES;

    
    AddTagArray=[[NSMutableArray alloc]init];
    
    matchedTags=[[NSMutableArray alloc]init];
    
    
    [self setNavBar];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SearchTagViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    scanTagArray=[[NSMutableArray alloc]init];
    scanDict=[[NSMutableDictionary alloc]init];

    _commander=[SelectReaderInfo sharedInstance];
    
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    
    _inventoryResponder = [CommoninventoryCommand sharedInstance] ;    // Create a TSLInventoryCommand
    _inventoryResponder.transponderReceivedDelegate = self;    // Add self as the transponder delegate
    
    _inventoryResponder.includeTransponderRSSI=TSL_TriState_YES;

    _inventoryResponder.captureNonLibraryResponses = YES;
    
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
                           [self.collectionView reloadData];
                       });
    };
    
    [_commander addResponder:_inventoryResponder];    // Add the inventory responder to the commander's responder chain
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commanderChangedState) name:TSLCommanderStateChangedNotification object:_commander];
    
    _inventoryResponder.transponderReceivedDelegate = self;    // Add self as the transponder delegate
    
    _inventoryResponder.captureNonLibraryResponses = YES;
    self.timer = nil;


}
- (void)viewWillDisappear:(BOOL)animated
{
    self.timer = nil;
    
    [super viewWillDisappear:animated];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark UITextfield Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [(ACFloatingTextField *)textField textFieldDidBeginEditing];
    if ([_txtSearch.text isEqualToString:@""])
    {
        
        _btntxtClear.hidden=YES;
        _imgClear.hidden=YES;
    }
    else
    {
        _btntxtClear.hidden=NO;
        _imgClear.hidden=NO;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [(ACFloatingTextField *)textField textFieldDidEndEditing];
    if ([_txtSearch.text isEqualToString:@""])
    {
        
        _btntxtClear.hidden=YES;
        _imgClear.hidden=YES;
    }
    else
    {
        _btntxtClear.hidden=NO;
        _imgClear.hidden=NO;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    if ([_txtSearch.text isEqualToString:@""])
    {
        
        _btntxtClear.hidden=YES;
        _imgClear.hidden=YES;
    }
    else
    {
        _btntxtClear.hidden=NO;
        _imgClear.hidden=NO;
    }
    return YES;
}


#pragma mark User Defined

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

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

#pragma mark Button click methods
- (IBAction)textClearClicked:(id)sender
{
    _txtSearch.text=@"";
    _btntxtClear.hidden=YES;
    _imgClear.hidden=YES;
    
}

- (IBAction)additemClicked:(id)sender
{
    addItemClicked=YES;
    

    NSString *myString = _txtSearch.text;
    myString=[myString uppercaseString];
    
    spliStringArray=nil;
    isSoundPlayed=NO;
    [AddTagArray removeAllObjects];
    if (myString==nil || [myString isEqualToString:@""])
    {
        
        
    }
    else
    {
        spliStringArray = [myString componentsSeparatedByString:@","];
        
        NSMutableArray * tempArray = [spliStringArray mutableCopy];
        
        for (int i=0;i<[tempArray count];i++)
        {
            if ([tempArray[i] isEqualToString: @""])
            {
                [tempArray removeObject: tempArray[i]];
            }
            else if ([tempArray[i] isEqualToString: @" "])
            {
                [tempArray removeObject: tempArray[i]];
            }
            else if ([tempArray[i] isEqualToString: @"  "])
            {
                [tempArray removeObject: tempArray[i]];
            }
            else if ([tempArray[i] isEqualToString: @"   "])
            {
                [tempArray removeObject: tempArray[i]];
            }
            else if ([tempArray[i] isEqualToString: @"    "])
            {
                [tempArray removeObject: tempArray[i]];
            }
        }
        spliStringArray = tempArray;

        for (int i=0; i<= spliStringArray.count-1; i++)
        {
            NSString * str=[spliStringArray objectAtIndex:i];
            SearTagDict=[[NSMutableDictionary alloc]init];
            
            [SearTagDict setObject:str forKey:@"tag"];
            [SearTagDict setObject:@"0" forKey:@"status"];
            [SearTagDict setObject:@"0" forKey:@"rssi"];
            [SearTagDict setObject:@"0" forKey:@"soundPlay"];
            
            [AddTagArray addObject:SearTagDict];
        }
        [_collectionView reloadData];
    }
}

- (IBAction)clearClicked:(id)sender
{
    addItemClicked=NO;
    isSoundPlayed=NO;
    
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
                              [AddTagArray removeAllObjects];
                              [self.collectionView reloadData];
                          }];
    
    [alt addAction:no];
    [alt addAction:yes];
    
    [self presentViewController:alt animated:YES completion:nil];
    
}

#pragma mark - TSLInventoryCommandTransponderReceivedDelegate methods

-(void)transponderReceived:(NSString *)epc crc:(NSNumber *)crc pc:(NSNumber *)pc rssi:(NSNumber *)rssi fastId:(NSData *)fastId moreAvailable:(BOOL)moreAvailable
{
    // Append the transponder EPC identifier and RSSI to the results
    
    NSData *epcdata=[TSLBinaryEncoding dataFromAsciiString:epc];
    NSString * epcfinal=[TSLBinaryEncoding asciiStringFromData:epcdata];
        
    NSLog(@"%@",epcfinal);
    
    BOOL isTheObjectMatches = [spliStringArray containsObject:epcfinal];
    
    

    if (isTheObjectMatches)
    {
        
        NSUInteger indexOfTheObject = [spliStringArray indexOfObject:epcfinal];
        
        dicttObject = [AddTagArray objectAtIndex: indexOfTheObject];

        [dicttObject setObject:@"1" forKey:@"status"];
        
        NSString * sound=[dicttObject valueForKey:@"soundPlay"];
        
        if ([sound isEqualToString:@"1"])
        {
            [self playSoundTwice];
        }
        else
        {
            [self playAudioOnce];
        }
        
        NSString * str=[dicttObject valueForKey:@"tag"];
        
//        if (rssi==nil)
//        {
//            [dictt setObject:@"0" forKey:@"rssi"];
//        }
//        else
//        {
//            [dictt setObject:rssi forKey:@"rssi"];
//        }
//        NSLog(@"%@",dictt);
        
    }
    else
    {
        NSLog(@"Scanned tag not matches");
    }
    
}

- (void)playAudioOnce
{
    [dicttObject setObject:@"1" forKey:@"soundPlay"];

    [self playSound:@"beep-08b" :@"mp3"];
}
-(void)playSoundTwice
{
    [self playSound:@"beep-02" :@"wav"];

}
- (void)playSound :(NSString *)fName :(NSString *) ext
{
    SystemSoundID audioEffect;
    NSString *path = [[NSBundle mainBundle] pathForResource : fName ofType :ext];
    if ([[NSFileManager defaultManager] fileExistsAtPath : path])
    {
        NSURL *pathURL = [NSURL fileURLWithPath: path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
    }
    else
    {
        NSLog(@"error, file not found: %@", path);
    }
}

#pragma mark - Helpers

- (void)updateProgressView:(NSTimer *)timer
{
    NSInteger newCurrentValue;
    SearchTagViewCell *cell;
    
    if (cell.progressview.currentValue == 0) {
        newCurrentValue = cell.progressview.maximumValue;
    } else {
        newCurrentValue = cell.progressview.currentValue - 1;
    }
    
    [cell.progressview updateToCurrentValue:newCurrentValue animated:YES];
    return;
}

#pragma mark CollectionViewDelegate and CollectionviewDatasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return AddTagArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTagViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary * dict =[AddTagArray objectAtIndex:indexPath.row];
    cell.lblTagName.text=[dict valueForKey:@"tag"];
    NSString *str=[dict objectForKey:@"status"];
    
    if ([str isEqualToString:@"1"])
    {
        cell.imgTick.image=[UIImage imageNamed:@"tick.png"];
    }
    else
    {
        cell.imgTick.image=[UIImage imageNamed:@"ti.png"];
    }
    return cell;
}


@end
