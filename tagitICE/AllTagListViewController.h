//
//  AllTagListViewController.h
//  tagitICE
//
//  Created by RAC on 23/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagCollectionViewCell.h"

#import "StockFile.h"

@interface AllTagListViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalQty;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalWeight;

@property (weak, nonatomic) IBOutlet UIView *viewTotalCounts;

@property(nonatomic,strong)NSMutableArray * T_FoundArray;
@property(nonatomic,strong)NSMutableArray * T_MissingArray;

@property(nonatomic,strong)NSString * GetFunction;
@end
