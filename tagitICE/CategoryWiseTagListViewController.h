//
//  CategoryWiseTagListViewController.h
//  tagitICE
//
//  Created by RAC on 27/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagCollectionViewCell.h"

#import "StockFile.h"

@interface CategoryWiseTagListViewController : UIViewController

@property(strong,nonatomic)NSMutableArray * CategoryWiseTags;

@property(strong,nonatomic)NSMutableArray *CL_tagArray;
@property(strong,nonatomic)NSString *CL_categoryName;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalQty;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalWeight;

@property (weak, nonatomic) IBOutlet UIView *viewTotalCounts;




@end
