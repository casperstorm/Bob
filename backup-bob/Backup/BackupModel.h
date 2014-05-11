//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import <Foundation/Foundation.h>


@interface BackupModel : NSObject

@property (nonatomic, strong) RACCommand *backupNowCommand;
@property (nonatomic) NSNumber *updateIntervalHours;
@property (nonatomic, readonly) NSDate *nextBackupDate;
@property (nonatomic, readonly) NSDate *lastBackupDate;
@property (nonatomic, readonly) BOOL backupInProgress;
@property (nonatomic, readonly) NSArray *folders;
@property (nonatomic, readonly) NSString *backupLog;

+ (BackupModel *)sharedInstance;
- (void)addFolders:(NSArray *)folders;
- (void)removeFoldersInIndexSet:(NSIndexSet *)set;

- (void)terminate;
@end
