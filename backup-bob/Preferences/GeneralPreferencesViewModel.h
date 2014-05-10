//
//  Created by Peter Gammelgaard on 09/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BackupModel.h"

NS_ENUM(NSInteger , AutoUpdateInterval) {
    AutoUpdateIntervalThreeHour = 0,
    AutoUpdateIntervalFiveHour,
    AutoUpdateIntervalSevenHour,
};


@interface GeneralPreferencesViewModel : NSObject
@property (nonatomic, strong) RACCommand *startAtLaunchCommand;
@property (nonatomic, strong) RACCommand *updateIntervalCommand;
@property (nonatomic, readonly) BOOL startAppAtLaunch;
@property (nonatomic, readonly) enum AutoUpdateInterval updateInterval;
@end