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

    RAC(self, nextBackupString) = [RACObserve([BackupModel sharedInstance], nextBackupDate) map:^id(NSDate *nextBackupDate) {
        NSString *relativeDate = [[SORelativeDateTransformer registeredTransformer] transformedValue:nextBackupDate];
        return [NSString stringWithFormat:@"Next backup %@", relativeDate];
    }];

    RAC(self, lastBackupString) = [RACObserve([BackupModel sharedInstance], lastBackupDate) map:^id(NSDate *nextBackupDate) {
        NSString *relativeDate = [[SORelativeDateTransformer registeredTransformer] transformedValue:nextBackupDate];
        return [NSString stringWithFormat:@"Last backup %@", relativeDate];
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