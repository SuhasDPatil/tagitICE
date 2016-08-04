//
//  CommoninventoryCommand.h
//  tagitICE
//
//  Created by rac on 03/08/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <TSLAsciiCommands/TSLAsciiCommands.h>

@interface CommoninventoryCommand : TSLInventoryCommand

+(CommoninventoryCommand *)sharedInstance;

//+ (void)setSelectedReader:(CommoninventoryCommand *)selectedCommander;
//
//+(CommoninventoryCommand *)getSelectedReader;


@end
