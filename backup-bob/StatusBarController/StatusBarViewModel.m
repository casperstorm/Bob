//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import "StatusBarViewModel.h"
#import "BackupModel.h"
#import "SORelativeDateTransformer.h"

@interface StatusBarViewModel ()
@property (nonatomic, strong) NSString *nextBackupString;
@property (nonatomic, strong) NSString *lastBackupString;
@end
@implementation StatusBarViewModel

- (id)init
{
    if (!(self = [super init])) return nil;

    /*
        Listen to last lastBackupDateSignal, and a timer which fires every 0.1 sec.
        If we have no lastBackupDate, we haven't had any backups yet. Else we print the relativeDate.
    */
    RACSignal *checkBackupTimer = [[RACSignal interval:0.1 onScheduler:[RACScheduler currentScheduler]] startWith:nil];
    RACSignal *lastBackupDateSignal = RACObserve([BackupModel sharedInstance], lastBackupDate);
    RAC(self, lastBackupString) = [[RACSignal combineLatest:@[lastBackupDateSignal, checkBackupTimer ]] map:^id(RACTuple *tuple) {
        RACTupleUnpack(NSDate *date) = tuple;
        if(date == nil) {
            return @"No backups yet";
        } else {
            NSString *relativeDate = [[SORelativeDateTransformer registeredTransformer] transformedValue:date];
            return [NSString stringWithFormat:@"Last backup %@", relativeDate];
        }
    }];

    /*
        Listen to last nextBackupDateSignal, a timer which fires every 0.1 sec and if a backup is in progress.
        If a backup is in progress, we write it. Else we write the relative time until the next backup
    */
    RACSignal *nextBackupDateSignal = RACObserve([BackupModel sharedInstance], nextBackupDate);
    RACSignal *backupInProgressSignal = RACObserve([BackupModel sharedInstance], backupInProgress);
    RAC(self, nextBackupString) = [[RACSignal combineLatest:@[nextBackupDateSignal, backupInProgressSignal, checkBackupTimer]] map:^id(RACTuple *tuple) {
        RACTupleUnpack(NSDate *nextBackupDate, NSNumber *backupInProgress) = tuple;
        if([backupInProgress boolValue]) {
            return @"Backup in progress..";
        } else {
            NSString *relativeDate = [[SORelativeDateTransformer registeredTransformer] transformedValue:nextBackupDate];
            return [NSString stringWithFormat:@"Next backup %@", relativeDate];
        }
    }];

    return self;
}

#pragma mark - Properties

- (RACCommand *)backupNowCommand
{
    if (!_backupNowCommand) {
        _backupNowCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [[[BackupModel sharedInstance] backupNowCommand] execute:input];
        }];
    }

    return _backupNowCommand;
}


@end