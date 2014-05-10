//
//  Created by Peter Gammelgaard on 09/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import "GeneralPreferencesViewModel.h"
#import "SettingsModel.h"
#import "BackupModel.h"

@interface GeneralPreferencesViewModel ()
@property (nonatomic, assign) BOOL startAppAtLaunch;
@end
@implementation GeneralPreferencesViewModel

- (id)init
{
    if (!(self = [super init])) return nil;

    [self setupBindings];

    return self;
}

- (void)setupBindings
{
    /*
        startAppAtLaunch binding to SettingsModel.
    */
    RAC([SettingsModel sharedInstance], startAppAtLaunch) = [[[self.startAtLaunchCommand.executionSignals flatten] ignore:nil] map:^id(NSNumber *value) {
        return @([value boolValue]);
    }];

    RAC(self, startAppAtLaunch) = RACObserve([SettingsModel sharedInstance], startAppAtLaunch);

    /*
        updateInterval binding to BackupModel.
    */
    RAC([BackupModel sharedInstance], updateIntervalHours) = [[[[self.updateIntervalCommand.executionSignals flatten] ignore:nil] distinctUntilChanged] map:^id(NSNumber *autoUpdateIntervalObject) {
        enum AutoUpdateInterval autoUpdateInterval = (enum AutoUpdateInterval) [autoUpdateIntervalObject intValue];
        switch (autoUpdateInterval) {
            case AutoUpdateIntervalThreeHour: return @3;
            case AutoUpdateIntervalFiveHour: return @5;
            case AutoUpdateIntervalSevenHour: return @7;
        }

        return nil;
    }];

    RAC(self, updateInterval) = [RACObserve([BackupModel sharedInstance], updateIntervalHours) map:^id(NSNumber *hours) {
        if([hours intValue] == 3 ) {
            return @(AutoUpdateIntervalThreeHour);
        }else if ([hours intValue] == 5 ) {
            return @(AutoUpdateIntervalFiveHour);
        }else if([hours intValue] == 7 ) {
            return @(AutoUpdateIntervalSevenHour);
        }

        return @(AutoUpdateIntervalThreeHour);
    }];
}

#pragma mark - Properties

- (RACCommand *)startAtLaunchCommand
{
    if (!_startAtLaunchCommand) {
        _startAtLaunchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal return:input];
        }];
    }

    return _startAtLaunchCommand;
}

- (RACCommand *)updateIntervalCommand
{
    if (!_updateIntervalCommand) {
        _updateIntervalCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal return:input];
        }];
    }

    return _updateIntervalCommand;
}


@end