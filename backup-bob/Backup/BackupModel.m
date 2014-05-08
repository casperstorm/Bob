//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import "BackupModel.h"


@implementation BackupModel
+ (BackupModel *)sharedInstance
{
    static BackupModel *sharedInstance = nil;
    if (sharedInstance) return sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[BackupModel alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    if (!(self = [super init])) return nil;

    return self;
}

- (RACCommand *)backupNowCommand
{
    if (!_backupNowCommand) {
        _backupNowCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // Call tarclient here.
            return nil;
        }];
    }

    return _backupNowCommand;
}


@end