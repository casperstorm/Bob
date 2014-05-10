//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import <Foundation/Foundation.h>

NS_ENUM(NSInteger , AutoUpdateInterval) {
    AutoUpdateIntervalThreeHour = 0,
    AutoUpdateIntervalFiveHour,
    AutoUpdateIntervalSevenHour,
};

@interface BackupModel : NSObject
+ (BackupModel *)sharedInstance;

- (void)addFolders:(NSArray *)folders;

@property (nonatomic, strong) RACCommand *backupNowCommand;

- (void)removeFoldersInIndexSet:(NSIndexSet *)set;

@property (nonatomic) enum AutoUpdateInterval updateInterval;
@property (nonatomic, readonly) NSDate *nextBackupDate;
@property (nonatomic, readonly) NSDate *lastBackupDate;
@property (nonatomic, readonly) BOOL backupInProgress;
@property (nonatomic, readonly) NSArray *folders;
@end
