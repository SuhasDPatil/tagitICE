//
//  SelectReaderInfo.h
//  tagitICE
//
//  Created by rac on 29/07/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <TSLAsciiCommands/TSLAsciiCommands.h>

@interface SelectReaderInfo : TSLAsciiCommander

+(SelectReaderInfo *)sharedInstance;


+ (void)setSelectedReader:(SelectReaderInfo *)selectedCommander;

+(SelectReaderInfo *)getSelectedReader;


@end