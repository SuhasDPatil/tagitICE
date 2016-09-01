//
//  TagsSC+CoreDataProperties.h
//  tagitICE
//
//  Created by RAC on 19/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TagsSC.h"

NS_ASSUME_NONNULL_BEGIN

@interface TagsSC (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *quantity;
@property (nullable, nonatomic, retain) NSString *srNumber;
@property (nullable, nonatomic, retain) NSString *scanDateTime;

@end

NS_ASSUME_NONNULL_END
