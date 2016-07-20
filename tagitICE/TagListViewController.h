//
//  TagListViewController.h
//  tagitICE
//
//  Created by suhas on 07/07/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagViewCell.h"

#import "Tags.h"

@interface TagListViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong) NSMutableArray *tags;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@end
