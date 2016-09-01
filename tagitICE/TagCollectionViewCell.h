//
//  TagCollectionViewCell.h
//  tagitICE
//
//  Created by RAC on 23/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTagName;

@property (weak, nonatomic) IBOutlet UILabel *lblCategory;

@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblQuantity;

@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblGrossWt;

@property (weak, nonatomic) IBOutlet UIImageView *imgTag;





@end
