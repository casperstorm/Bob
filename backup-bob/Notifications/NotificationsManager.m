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

    self.notificationsEnabled = YES;
    [self setupBindings];

    return self;
}

- (void)setupBindings
{
    RACSignal *backupDoneSignal = [[[RACObserve([BackupModel sharedInstance], backupInProgress) distinctUntilChanged] ignore:@YES] skip:1];
    RACSignal *backupStartingSignal = [[[RACObserve([BackupModel sharedInstance], backupInProgress) distinctUntilChanged] ignore:@NO] skip:1];
    RACSignal *notificationsEnabledSignal = RACObserve(self, notificationsEnabled);

    RACSignal *combinedCompletedBackupSignal = [[RACSignal combineLatest:@[ notificationsEnabledSignal, backupDoneSignal ]] map:^id(RACTuple *tuple) {
        RACTupleUnpack(NSNumber *notificationsEnabled) = tuple;
        return notificationsEnabled;
    }];

    RACSignal *combinedStartingBackupSignal = [[RACSignal combineLatest:@[ notificationsEnabledSignal, backupStartingSignal ]] map:^id(RACTuple *tuple) {
        RACTupleUnpack(NSNumber *notificationsEnabled) = tuple;
        return notificationsEnabled;
    }];

    [self rac_liftSelector:@selector(displayCompletedBackupNotification:) withSignals:combinedCompletedBackupSignal, nil];
    [self rac_liftSelector:@selector(displayStartingBackupNotification:) withSignals:combinedStartingBackupSignal, nil];

}

- (void)displayCompletedBackupNotification:(BOOL)display
{
    if(display) {
        NSUserNotification *notification = [NSUserNotification new];
        notification.title = @"Backup done!";
        notification.informativeText = @"What is this sorcery?";
        notification.soundName = NSUserNotificationDefaultSoundName;

        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    }
}

- (void)displayStartingBackupNotification:(BOOL)display
{
    if(display) {
        NSUserNotification *notification = [NSUserNotification new];
        notification.title = @"Starting backup...";
        notification.informativeText = @"What is this sorcery?";
        notification.soundName = NSUserNotificationDefaultSoundName;

        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    }
}


@end