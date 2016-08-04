//
//  CommoninventoryCommand.m
//  tagitICE
//
//  Created by rac on 03/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "CommoninventoryCommand.h"

@implementation CommoninventoryCommand

static CommoninventoryCommand * inventory=nil;

+(CommoninventoryCommand *)sharedInstance
{
    if (inventory == nil)
    {
        inventory=[[super allocWithZone:NULL]init];
    }
    return inventory;
}




@end
