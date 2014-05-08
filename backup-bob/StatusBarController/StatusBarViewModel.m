//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import "StatusBarViewModel.h"
#import "BackupModel.h"

@interface StatusBarViewModel ()
@property (nonatomic, strong) NSString *nextBackupString;
@property (nonatomic, strong) NSString *lastBackupString;
@end
@implementation StatusBarViewModel

- (id)init
{
    if (!(self = [super init])) return nil;

    self.nextBackupString = @"Never";
    self.lastBackupString = @"Never";

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