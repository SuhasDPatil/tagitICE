//
//  AllTagListViewController.m
//  tagitICE
//
//  Created by RAC on 23/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "AllTagListViewController.h"

@interface AllTagListViewController ()

@end

@implementation AllTagListViewController

#pragma mark CoreData Method for reuse

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;

    NSLog(@"%@",_GetFunction);
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TagCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    // Do any additional setup after loading the view from its nib.
    //Calculate Total Quantity
    
    NSNumber * totalQty = 0, * totalPrice = 0;
    float totalWeight=0.0f;
    int Quantitytotal=0, PriceTotal=0;
    double WeightTotal=0;
    
    
    if ([_GetFunction isEqualToString:@"FOUND"])
    {
        for (int i=0; i<[_T_FoundArray count]; i++) {
            
            NSMutableDictionary * tempDict=[_T_FoundArray objectAtIndex:i];
            totalQty=[tempDict objectForKey:@"qty"];
            totalPrice=[tempDict objectForKey:@"tag_Price"];
            totalWeight=[[tempDict objectForKey:@"gross_Wt"]floatValue];
            
            Quantitytotal=Quantitytotal+[totalQty intValue];
            PriceTotal=PriceTotal+[totalPrice intValue];
            WeightTotal=WeightTotal+totalWeight;
            
        }
    }
    else if ([_GetFunction isEqualToString:@"MISSING"])
    {
        for (int i=0; i<[_T_MissingArray count]; i++) {
            
            NSMutableDictionary * tempDict=[_T_MissingArray objectAtIndex:i];
            totalQty=[tempDict objectForKey:@"qty"];
            totalPrice=[tempDict objectForKey:@"tag_Price"];
            totalWeight=[[tempDict objectForKey:@"gross_Wt"]floatValue];
            
            Quantitytotal=Quantitytotal+[totalQty intValue];
            PriceTotal=PriceTotal+[totalPrice intValue];
            WeightTotal=WeightTotal+totalWeight;
            
        }
    }
    _lblTotalQty.text=[NSString stringWithFormat:@"%d",Quantitytotal];
    _lblTotalPrice.text=[NSString stringWithFormat:@"%d",PriceTotal];
    _lblTotalWeight.text=[NSString stringWithFormat:@"%.2f",WeightTotal];

    _collectionView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.viewTotalCounts.frame.size.height);

}



-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    _viewTotalCounts.frame=CGRectMake(0, self.view.frame.origin.y+400, self.view.frame.size.width,60);
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
#pragma mark UICollectioViewDelegate and Datatsource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count;
    if ([_GetFunction isEqualToString:@"FOUND"])
    {
        count=[_T_FoundArray count];
    }
    else if ([_GetFunction isEqualToString:@"MISSING"])
    {
        count=[_T_MissingArray count];
    }
    return count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TagCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSMutableDictionary * tempDict;
    if ([_GetFunction isEqualToString:@"FOUND"])
    {
        tempDict=[_T_FoundArray objectAtIndex:indexPath.row];
    }
    else if ([_GetFunction isEqualToString:@"MISSING"])
    {
        tempDict=[_T_MissingArray objectAtIndex:indexPath.row];
    }
    
    cell.lblTagName.text=[NSString stringWithFormat:@"%@",(NSString *)[tempDict valueForKey:@"item_Code"]];
    cell.lblPrice.text=[NSString stringWithFormat:@"%@",(NSString *)[tempDict valueForKey:@"tag_Price"]];
    cell.lblGrossWt.text=[NSString stringWithFormat:@"%@g",(NSString *)[tempDict valueForKey:@"gross_Wt"]];
    cell.lblCategory.text=[NSString stringWithFormat:@"%@",(NSString *)[tempDict valueForKey:@"category"]];
    cell.lblQuantity.text=[NSString stringWithFormat:@"%@",(NSString *)[tempDict valueForKey:@"qty"]];
    cell.lblDescription.text=[NSString stringWithFormat:@"%@",(NSString *)[tempDict valueForKey:@"item_Description"]];
    
    return cell;
    
}



@end
