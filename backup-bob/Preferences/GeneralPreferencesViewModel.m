//
//  Created by Peter Gammelgaard on 09/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import "GeneralPreferencesViewModel.h"
#import "SettingsModel.h"

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


@end