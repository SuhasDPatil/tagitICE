//
//  CategoryWiseTagListViewController.m
//  tagitICE
//
//  Created by RAC on 27/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "CategoryWiseTagListViewController.h"

@interface CategoryWiseTagListViewController ()

@end

@implementation CategoryWiseTagListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TagCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self setNavBar];
    [self.navigationController setNavigationBarHidden:NO];

    self.title=_CL_categoryName;
    _CategoryWiseTags=[[NSMutableArray alloc]init];
    
    for (int i=0; i<[_CL_tagArray count]; i++)
    {
        NSMutableDictionary * tempDict=[_CL_tagArray objectAtIndex:i];
        NSString * strCat=[tempDict valueForKey:@"category"];
        if ([strCat isEqualToString:_CL_categoryName])
        {
            [_CategoryWiseTags addObject:[_CL_tagArray objectAtIndex:i]];
        }
    }
    
    //Calculate Total of Price,Quantity and Weight
    NSNumber * totalQty = 0, * totalPrice = 0;
    float totalWeight=0.0f;
    int Quantitytotal=0, PriceTotal=0;
    double WeightTotal=0;
    
    for (int i=0; i<[_CategoryWiseTags count]; i++)
    {
        NSMutableDictionary * tempDict=[_CategoryWiseTags objectAtIndex:i];
        totalQty=[tempDict objectForKey:@"qty"];
        totalPrice=[tempDict objectForKey:@"tag_Price"];
        totalWeight=[[tempDict objectForKey:@"gross_Wt"]floatValue];
        
        Quantitytotal=Quantitytotal+[totalQty intValue];
        PriceTotal=PriceTotal+[totalPrice intValue];
        WeightTotal=WeightTotal+totalWeight;
    }
    _lblTotalQty.text=[NSString stringWithFormat:@"%d",Quantitytotal];
    _lblTotalPrice.text=[NSString stringWithFormat:@"%d",PriceTotal];
    _lblTotalWeight.text=[NSString stringWithFormat:@"%.2f",WeightTotal];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
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
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(10, 5, 12, 20);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UICollectioViewDelegate and Datatsource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_CategoryWiseTags count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TagCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSMutableDictionary * tempDict =[_CategoryWiseTags objectAtIndex:indexPath.row];
    
    cell.lblTagName.text=[NSString stringWithFormat:@"%@",(NSString *)[tempDict valueForKey:@"item_Code"]];
    cell.lblPrice.text=[NSString stringWithFormat:@"%@",(NSString *)[tempDict valueForKey:@"tag_Price"]];
    cell.lblGrossWt.text=[NSString stringWithFormat:@"%@g",(NSString *)[tempDict valueForKey:@"gross_Wt"]];
    cell.lblCategory.text=[NSString stringWithFormat:@"%@",(NSString *)[tempDict valueForKey:@"category"]];
    cell.lblQuantity.text=[NSString stringWithFormat:@"%@",(NSString *)[tempDict valueForKey:@"qty"]];
    cell.lblDescription.text=[NSString stringWithFormat:@"%@",(NSString *)[tempDict valueForKey:@"item_Description"]];

    return cell;
}


@end
