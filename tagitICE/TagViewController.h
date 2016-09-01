//
//  TagViewController.h
//  tagitICE
//
//  Created by RAC on 23/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPSPageMenu.h"

#import "AllTagListViewController.h"
#import "CategoryTagListViewController.h"

@interface TagViewController : UIViewController




@property(nonatomic,strong)NSString * titleText;


@property(nonatomic,strong)NSMutableArray * S_FoundArray;
@property(nonatomic,strong)NSMutableArray * S_MissingArray;

@property (nonatomic) CAPSPageMenu *pageMenu;



@end
