//
//  StockFile+CoreDataProperties.h
//  tagitICE
//
//  Created by RAC on 19/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "StockFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface StockFile (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *item_Code;
@property (nullable, nonatomic, retain) NSNumber *qty;
@property (nullable, nonatomic, retain) NSNumber *gross_Wt;
@property (nullable, nonatomic, retain) NSNumber *net_Wt;
@property (nullable, nonatomic, retain) NSNumber *dia_Wt;
@property (nullable, nonatomic, retain) NSNumber *st_Wt;
@property (nullable, nonatomic, retain) NSNumber *gold_Oth_Wt;
@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSString *itemType_Name;
@property (nullable, nonatomic, retain) NSString *location_Name;
@property (nullable, nonatomic, retain) NSString *item_Description;
@property (nullable, nonatomic, retain) NSNumber *tag_Price;
@property (nullable, nonatomic, retain) NSString *img_url;
@property (nullable, nonatomic, retain) NSString *menu;

@end

NS_ASSUME_NONNULL_END
