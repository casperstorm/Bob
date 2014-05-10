//
// Created by Casper Storm Larsen on 10/05/14.
// SHAPE A/S
//


#import "LogPreferencesViewModel.h"
#import "BackupModel.h"

@implementation LogPreferencesViewModel
- (id)init
{
    if (!(self = [super init])) return nil;

    [self setupBindings];

    return self;
}

- (void)setupBindings
{
    RAC(self, logString) = [RACObserve([BackupModel sharedInstance], backupLog) scanWithStart:@"" reduce:^id(id running, id next) {
        if(running) {
            return [next stringByAppendingString:running];
        }
        return next;
    }];
}

@end