//
//  SearchTagViewCell.h
//  tagitICE
//
//  Created by rac on 03/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAColourfulProgressView.h"

@interface SearchTagViewCell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet EAColourfulProgressView *progressview;

@property (strong, nonatomic) IBOutlet UILabel *lblTagName;

@property (strong, nonatomic) IBOutlet UIImageView *imgTick;







@end
