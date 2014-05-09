//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import "BackupModel.h"
#import "TarsnapClient.h"

@interface BackupModel ()
@property (nonatomic, strong) TarsnapClient *tarsnapClient;
@property (nonatomic, strong) NSTimer *backupTimer;
@property (nonatomic, assign) BOOL backupInProgress;
@property (nonatomic, strong) NSDate *nextBackupDate;
@property (nonatomic, strong) NSDate *lastBackupDate;
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

    [self startTimer:nil];
    [self setupBindings];

    return self;
}

- (void)setupBindings
{
    RAC(self, nextBackupDate) = RACObserve(self, backupTimer.fireDate);

    // Binds the executing signal of the backupNowCommand so we know when we are backing up.
    RAC(self, backupInProgress) = self.backupNowCommand.executing;

    RACSignal *backupDoneSignal = [[[RACObserve(self, backupInProgress) distinctUntilChanged] ignore:@YES] skip:1];
    RAC(self, lastBackupDate) = [backupDoneSignal map:^id(id value) {
        return [NSDate date];
    }];

    // When backup is done, it fires startTimer: again.
    [self rac_liftSelector:@selector(startTimer:) withSignals:backupDoneSignal, nil];
}

- (void)backupTimeFired:(id)backupTimeFired
{
    [self.backupNowCommand execute:nil];
}

#pragma mark - Timer

- (void)startTimer:(id)_
{
    // Timer which will launch the backup
    self.backupTimer = [NSTimer timerWithTimeInterval:(10) target:self selector:@selector(backupTimeFired:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.backupTimer forMode:NSRunLoopCommonModes];
}

#pragma mark - Properties

- (RACCommand *)backupNowCommand
{
    if (!_backupNowCommand) {
        _backupNowCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            [self.backupTimer invalidate];
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