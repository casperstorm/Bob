//
//  Created by Peter Gammelgaard on 09/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import "GeneralPreferencesViewModel.h"

static NSString *const GeneralPreferencesStartAppAtLaunchKey = @"GeneralPreferencesStartAppAtLaunchKey";

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
        startAppAtLaunch binding and saving.
    */
    RAC(self, startAppAtLaunch) = [[[self.startAtLaunchCommand.executionSignals flatten] ignore:nil] map:^id(NSNumber *value) {
        return @([value boolValue]);
    }];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    RACChannelTerminal *currentUserTerminal = RACChannelTo(self, startAppAtLaunch);
    RACChannelTerminal *defaultsTerminal = [defaults rac_channelTerminalForKey:GeneralPreferencesStartAppAtLaunchKey];

    [[[defaultsTerminal map:^id(NSNumber *startAtLaunch) {
        return startAtLaunch;
    }] ignore:nil] subscribe:currentUserTerminal];

    [[[currentUserTerminal skip:1] map:^id(NSNumber *startAtLaunch) {
        return startAtLaunch;
    }] subscribe:defaultsTerminal];
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