//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import "BackupModel.h"
#import "TarsnapClient.h"

@interface BackupModel ()
@property (nonatomic, strong) TarsnapClient *tarsnapClient;
@property (nonatomic, strong) NSTimer *backupTimer;
@property (nonatomic, strong) RACSignal *checkBackupTimer;
@end
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

    NSLog(@"Init..");
    [self setupBindings];

    return self;
}

- (void)setupBindings
{
    self.backupTimer = [NSTimer scheduledTimerWithTimeInterval:(8) target:self selector:@selector(backupTimeFired:) userInfo:nil repeats:YES];
    self.checkBackupTimer = [[RACSignal interval:1.0 onScheduler:[RACScheduler currentScheduler]] startWith:nil];

    RAC(self, nextBackupDate) = [self.checkBackupTimer map:^id(id _) {
        return [self.backupTimer.fireDate copy];
    }];

    RAC(self, lastBackupDate) = [[[[[self.backupNowCommand.executionSignals flatten] materialize] filter:^BOOL(RACEvent *event) {
        return event.eventType == RACEventTypeNext;
    }] dematerialize] map:^id(id value) {
        return [NSDate date];
    }];
}

- (void)backupTimeFired:(id)backupTimeFired
{
    [self.backupNowCommand execute:nil];
}

#pragma mark - Properties

- (RACCommand *)backupNowCommand
{
    if (!_backupNowCommand) {
        _backupNowCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return self.tarsnapClient.sleep;
        }];
    }

    return _backupNowCommand;
}

- (TarsnapClient *)tarsnapClient
{
    if (!_tarsnapClient) {
        _tarsnapClient = [TarsnapClient new];
    }

    return _tarsnapClient;
}

@end