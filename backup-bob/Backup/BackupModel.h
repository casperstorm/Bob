//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import <Foundation/Foundation.h>


@interface BackupModel : NSObject
+ (BackupModel *)sharedInstance;

- (void)addFolders:(NSArray *)folders;

@property (nonatomic, strong) RACCommand *backupNowCommand;
@property (nonatomic, readonly) NSDate *nextBackupDate;
@property (nonatomic, readonly) NSDate *lastBackupDate;
@property (nonatomic, readonly) BOOL backupInProgress;
@property (nonatomic, readonly) NSArray *folders;
@end
