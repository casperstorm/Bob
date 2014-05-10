//
// Created by Casper Storm Larsen on 09/05/14.
// SHAPE A/S
//


#import "NotificationsManager.h"
#import "BackupModel.h"


@implementation NotificationsManager

+ (NotificationsManager *)sharedInstance
{
    static NotificationsManager *sharedInstance = nil;
    if (sharedInstance) return sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[NotificationsManager alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    if (!(self = [super init])) return nil;

    [self setupBindings];

    return self;
}

- (void)setupBindings
{
    RACSignal *backupDoneSignal = [[[RACObserve([BackupModel sharedInstance], backupInProgress) distinctUntilChanged] ignore:@YES] skip:1];
    RACSignal *backupStartingSignal = [[[RACObserve([BackupModel sharedInstance], backupInProgress) distinctUntilChanged] ignore:@NO] skip:1];

    [self rac_liftSelector:@selector(displayCompletedBackupNotification:) withSignals:backupDoneSignal, nil];
    [self rac_liftSelector:@selector(displayStartingBackupNotification:) withSignals:backupStartingSignal, nil];
}

- (void)displayCompletedBackupNotification:(id)_
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserNotification *notification = [NSUserNotification new];
        notification.title = @"Backup done!";
        notification.soundName = NSUserNotificationDefaultSoundName;

        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    });
}

- (void)displayStartingBackupNotification:(id)_
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserNotification *notification = [NSUserNotification new];
        notification.title = @"Starting backup...";
        notification.soundName = NSUserNotificationDefaultSoundName;

        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    });
}


@end