//
//  Tags+CoreDataProperties.h
//  tagitICE
//
//  Created by suhas on 18/07/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tags.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tags (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *quantity;
@property (nullable, nonatomic, retain) NSString *srNumber;

@end

NS_ASSUME_NONNULL_END
