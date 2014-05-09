//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import <Foundation/Foundation.h>


@interface BackupModel : NSObject
+ (BackupModel *)sharedInstance;
@property (nonatomic, strong) RACCommand *backupNowCommand;
@property (nonatomic, strong) NSDate *nextBackupDate;
@property (nonatomic, strong) NSDate *lastBackupDate;
@end