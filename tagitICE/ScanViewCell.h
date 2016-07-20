//
//  ScanViewCell.h
//  tagitICE
//
//  Created by suhas on 20/06/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblDeviceName;

@property (strong, nonatomic) IBOutlet UILabel *lblDeviceNumber;

@property (strong, nonatomic) IBOutlet UILabel *lblPaired;

@property (strong, nonatomic) IBOutlet UIImageView *imgBluetooth;


@end
