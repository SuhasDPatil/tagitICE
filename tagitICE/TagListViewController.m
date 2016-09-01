//
//  TagListViewController.m
//  tagitICE
//
//  Created by suhas on 07/07/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "TagListViewController.h"

@interface TagListViewController ()

@end

@implementation TagListViewController

#pragma mark Core Data method
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    [hud show:YES];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:203.0f/255.0f green:32.0f/255.0f blue:45.0f/255.0f alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 10, 16);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;

    if ([_getFunction isEqualToString:@"CONSIGNMENT"])
    {
        self.title=@"CONSIGNMENT";
    }
    else if ([_getFunction isEqualToString:@"EXTRA"])
    {
        self.title=@"EXTRA";
    }

    [self.collectionView registerNib:[UINib nibWithNibName:@"TagViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [hud show:YES];

    // Fetch the Tags from persistent data store
    if ([_getFunction isEqualToString:@"CONSIGNMENT"])
    {

        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tags"];
        
        self.tags = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        
        [self.collectionView reloadData];
    }
    else if ([_getFunction isEqualToString:@"EXTRA"])
    {

    }

    [hud hide:YES];

}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectioViewDelegate and Datatsource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count;
    if ([_getFunction isEqualToString:@"CONSIGNMENT"])
    {
        count=[_tags count];
    }
    else if ([_getFunction isEqualToString:@"EXTRA"])
    {
        count=[_T_ExtraArray count];
    }
    return count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [hud show:YES];

    TagViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if ([_getFunction isEqualToString:@"CONSIGNMENT"])
    {

        NSManagedObject *tags = [self.tags objectAtIndex:indexPath.row];

        cell.lblTagText.text=[NSString stringWithFormat:@"%@", [tags valueForKey:@"srNumber"]];
        
        cell.lblTagCount.text=[NSString stringWithFormat:@"%@", [tags valueForKey:@"quantity"]];
    }
    else if ([_getFunction isEqualToString:@"EXTRA"])
    {
        
        NSMutableDictionary* tempDict=[_T_ExtraArray objectAtIndex:indexPath.row];

        cell.lblTagText.text=[NSString stringWithFormat:@"%@", [tempDict valueForKey:@"srNumber"]];
        
        cell.lblTagCount.text=[NSString stringWithFormat:@"%@", [tempDict valueForKey:@"quantity"]];

    }
    return cell;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
