//
//  LoadStockViewController.m
//  tagitICE
//
//  Created by RAC on 25/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "LoadStockViewController.h"

@interface LoadStockViewController ()

@end

static NSString *const kKeychainItemName = @"AIzaSyBtHyNDgvPUr0P6i4XON6G6vLb62cSEkWE";//API Key

static NSString *const kClientID = @"812491798886-djnvpg3tpu1deqrtepu3vi0fj2tdpvfm.apps.googleusercontent.com";//Client ID

@implementation LoadStockViewController

@synthesize service = _service;
@synthesize output = _output;
@synthesize isAuthorized = _isAuthorized;



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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    self.title=@"Tagit ICE";
    stockFileArray=[[NSMutableArray alloc]init];
    [self removeStockFileData];
    
//    [self loadStockFile];
    
    [[self.btnLoadCloud layer] setBorderWidth:5.0f];
    [[self.btnLoadCloud layer] setBorderColor:[UIColor clearColor].CGColor];
    [[self.btnLoadCloud layer]setCornerRadius:4.5f];

    [[self.btnLoadFDevice layer] setBorderWidth:5.0f];
    [[self.btnLoadFDevice layer] setBorderColor:[UIColor clearColor].CGColor];
    [[self.btnLoadFDevice layer]setCornerRadius:4.5f];

    //Logout from Google Drive Code
    
//    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
//    [[self driveService] setAuthorizer:nil];
//    self.isAuthorized = NO;

    // Do any additional setup after loading the view from its nib.
}
- (GTLServiceDrive *)driveService {
    static GTLServiceDrive *service = nil;
    
    if (!service) {
        service = [[GTLServiceDrive alloc] init];
        
        // Have the service object set tickets to fetch consecutive pages
        // of the feed so we do not need to manually fetch them.
        service.shouldFetchNextPages = YES;
        
        // Have the service object set tickets to retry temporary error conditions
        // automatically.
        service.retryEnabled = YES;
    }
    return service;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cloudClicked:(id)sender
{
    def=[NSUserDefaults standardUserDefaults];
    [def setObject:@"NO" forKey:@"isSkip"];
    [def synchronize];
    
//    [self checkForAlreadyAccountDetailsExist];
    
    
}

- (IBAction)deviceStorageClicked:(id)sender
{

    def=[NSUserDefaults standardUserDefaults];
    [def setObject:@"NO" forKey:@"isSkip"];
    [def synchronize];

    [self loadStockFile];
    
    MainVC * mvc=[[MainVC alloc]init];
    [self.navigationController pushViewController:mvc animated:YES];
}

- (IBAction)skipClicked:(id)sender
{
    def=[NSUserDefaults standardUserDefaults];
    [def setObject:@"0" forKey:@"LoadStockCount"];
    [def setObject:@"YES" forKey:@"isSkip"];
    [def synchronize];

    MainVC * mvc=[[MainVC alloc]init];
    
    [self.navigationController pushViewController:mvc animated:YES];

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
    //Back Button
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"b"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    //    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 0, 0);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;

}

-(void)loadStockFile
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    [hud show:YES];

    //Get Data from Stock_File.txt
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Stock_File" ofType:@"txt"];
    
    NSLog(@"%@",filePath);
    
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
    
    stockFileArray=[NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    
    def=[NSUserDefaults standardUserDefaults];
    NSString * str=[NSString stringWithFormat:@"%ld",(unsigned long)[stockFileArray count]];
    
    [def setObject:str forKey:@"LoadStockCount"];
    
    [def synchronize];
    
    //Save into Local Database
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
        
        NSString * category=[dict valueForKey:@"Category"];
        
        NSLog(@"Category : %@",category);
        
        if ([[mutableFetchResults valueForKey:@"item_Code"]
             containsObject:[dict objectForKey:@"Item_Code"]])
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

    [hud hide:YES];

}


-(void)removeStockFileData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    [hud show:YES];
    
    
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

#pragma mark Load from Google Drive

-(void)checkForAlreadyAccountDetailsExist
{
    
    // Create a UITextView to display output.
    self.output = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.output.editable = false;
    self.output.contentInset = UIEdgeInsetsMake(20.0, 0.0, 20.0, 0.0);
    self.output.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //    [self.view addSubview:self.output];
    
    // Initialize the Drive API service & load existing credentials from the keychain if available.
    self.service = [[GTLServiceDrive alloc] init];
    self.service.authorizer =[GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName clientID:kClientID clientSecret:nil];
    
    
    // When the view appears, ensure that the Drive API service is authorized, and perform API calls.
    
    if (!self.service.authorizer.canAuthorize) {
        // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
        //        [self presentViewController:[self createAuthController] animated:YES completion:nil];
        [self.navigationController pushViewController:[self createAuthController] animated:YES];
        
        
    } else {
        [self fetchFiles];
    }
    
}

// Construct a query to get names and IDs of 10 files using the Google Drive API.
- (void)fetchFiles {
    self.output.text = @"Getting files...";
    GTLQueryDrive *query =
    [GTLQueryDrive queryForFilesList];
    query.pageSize = 10;
    query.fields = @"nextPageToken, files(id, name)";
    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}

// Process the response and display output.
- (void)displayResultWithTicket:(GTLServiceTicket *)ticket
             finishedWithObject:(GTLDriveFileList *)response
                          error:(NSError *)error {
    if (error == nil)
    {
        NSMutableString *filesString = [[NSMutableString alloc] init];
        NSMutableArray * fileListArray=[[NSMutableArray alloc]init];
        
        if (response.files.count > 0)
        {
            [filesString appendString:@"Files:\n"];
            for (GTLDriveFile *file in response.files)
            {
                [filesString appendFormat:@"%@ (%@)\n", file.name, file.identifier];
                [fileListArray addObject:[NSString stringWithFormat:@"%@",file.name]];
            }
        }
        else
        {
            [filesString appendString:@"No files found."];
        }
        self.output.text = filesString;
        NSLog(@"Files in Array : %@",fileListArray);
        
        GoogleDriveFileListController * gdflvc=[[GoogleDriveFileListController alloc]init];
        gdflvc.P_fileArray=fileListArray;
        [self.navigationController pushViewController:gdflvc animated:YES];
    }
    else
    {
        [self showAlert:@"Error" message:error.localizedDescription];
    }
}

// Creates the auth controller for authorizing access to Drive API.
- (GTMOAuth2ViewControllerTouch *)createAuthController {
    GTMOAuth2ViewControllerTouch *authController;
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    NSArray *scopes = [NSArray arrayWithObjects:kGTLAuthScopeDriveMetadataReadonly, nil];
    authController = [[GTMOAuth2ViewControllerTouch alloc]
                      initWithScope:[scopes componentsJoinedByString:@" "]
                      clientID:kClientID
                      clientSecret:nil
                      keychainItemName:kKeychainItemName
                      delegate:self
                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

// Handle completion of the authorization process, and update the Drive API
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    }
    else {
        self.service.authorizer = authResult;
        //        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         //         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
