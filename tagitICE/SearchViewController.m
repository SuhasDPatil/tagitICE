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

    [_txtSearch setTextFieldPlaceholderText:@"Search Tags"];
    _txtSearch.btmLineSelectionColor = [UIColor clearColor];
    _txtSearch.placeHolderTextColor = [UIColor redColor];
    _txtSearch.selectedPlaceHolderTextColor = [UIColor redColor];
    _txtSearch.btmLineColor = [UIColor clearColor];

    
    
    AddTagArray=[[NSArray alloc]init];
    
    [self setNavBar];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SearchTagViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    searchTagArray=[[NSMutableArray alloc]init];
    tagDict=[[NSMutableDictionary alloc]init];

    _commander=[SelectReaderInfo sharedInstance];
    
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    
    _inventoryResponder = [CommoninventoryCommand sharedInstance] ;    // Create a TSLInventoryCommand
    _inventoryResponder.transponderReceivedDelegate = self;    // Add self as the transponder delegate
    
    _inventoryResponder.includeTransponderRSSI=TSL_TriState_NO;

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
                       });
    };
    
    [_commander addResponder:_inventoryResponder];    // Add the inventory responder to the commander's responder chain
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commanderChangedState) name:TSLCommanderStateChangedNotification object:_commander];
    
    _inventoryResponder.transponderReceivedDelegate = self;    // Add self as the transponder delegate
    
    _inventoryResponder.captureNonLibraryResponses = YES;

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
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [(ACFloatingTextField *)textField textFieldDidBeginEditing];
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [(ACFloatingTextField *)textField textFieldDidEndEditing];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
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
- (IBAction)additemClicked:(id)sender
{
    NSString *myString = _txtSearch.text;
    
    AddTagArray = [myString componentsSeparatedByString:@","];
    
    NSLog(@"%@",AddTagArray);
    [_collectionView reloadData];
    
}

- (IBAction)clearClicked:(id)sender
{
    
    AddTagArray=nil;
    [self.collectionView reloadData];
    
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
    
    cell.lblTagName.text=[AddTagArray objectAtIndex:indexPath.row];
    
    return cell;
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
    
    NSData *epcdata=[TSLBinaryEncoding dataFromAsciiString:epc];
    NSString * epcfinal=[TSLBinaryEncoding asciiStringFromData:epcdata];
    
    [tagDict setObject:epcfinal forKey:@"srNumber"];
    
    [searchTagArray addObject:epcfinal];

    _arrayCopy=[searchTagArray copy];
    
    NSSet *mySet = [NSSet setWithArray:_arrayCopy];
    
    _arrayCopy = [mySet allObjects];
    
    NSLog(@"%@",searchTagArray);
    NSLog(@"%@",_arrayCopy);
}

@end
