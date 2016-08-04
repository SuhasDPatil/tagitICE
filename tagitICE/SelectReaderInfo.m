//
//  SelectReaderInfo.m
//  tagitICE
//
//  Created by rac on 29/07/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "SelectReaderInfo.h"

@implementation SelectReaderInfo

static SelectReaderInfo * commander=nil;

static SelectReaderInfo * selectedReader;

+(SelectReaderInfo *)sharedInstance
{
    if (commander == nil) {
        commander=[[super allocWithZone:NULL]init];
        
    }
    return commander;
}

+(void)setSelectedReader:(SelectReaderInfo *)selectedCommander
{
    selectedReader=selectedCommander;
    
    NSLog(@"%@",selectedReader);
}

+(SelectReaderInfo *)getSelectedReader
{
    return selectedReader;
}

@end

