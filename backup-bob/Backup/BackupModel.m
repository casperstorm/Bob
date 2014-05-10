//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import "BackupModel.h"
#import "TarsnapClient.h"
#import "Folder.h"

static NSString *const BackupModelFoldersKey = @"BackupModelFoldersKey";
static NSString *const BackupModelAutoUpdateIntervalKey = @"BackupModelAutoUpdateIntervalKey";
static NSString *const BackupModelLastBackupDateKey = @"BackupModelLastBackupDateKey";

@interface BackupModel ()
@property (nonatomic, strong) TarsnapClient *tarsnapClient;
@property (nonatomic, strong) NSTimer *backupTimer;
@property (nonatomic, assign) BOOL backupInProgress;
@property (nonatomic, strong) NSDate *nextBackupDate;
@property (nonatomic, strong) NSDate *lastBackupDate;
@property (nonatomic, strong) NSArray *folders;
@property (nonatomic, assign) BOOL anyActiveFolders;
@property (nonatomic, assign) NSTimeInterval backupTimeInterval;
@end
@implementation BackupModel {
    NSArray *_folders;
}

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

    _folders = [NSMutableArray new];

    [self setupBindings];
    [self startTimer:nil];

    return self;
}

- (void)setupBindings
{
    /*
        Binds the fireDate of the timer to the nextBackupDate
    */
    RAC(self, nextBackupDate) = RACObserve(self, backupTimer.fireDate);

    /*
        Binds the executing signal of the backupNowCommand so we know when we are backing up.
    */
    RAC(self, backupInProgress) = self.backupNowCommand.executing;

    /*
        Listen to when a backup was completed. When it is done, it will set the lastBackupDate.
    */
    RACSignal *backupDoneSignal = [[[RACObserve(self, backupInProgress) distinctUntilChanged] ignore:@YES] skip:1];
    RAC(self, lastBackupDate) = [backupDoneSignal map:^id(id value) {
        return [NSDate date];
    }];

    /*
        When backup is done, it starts the timer again
    */
    [self rac_liftSelector:@selector(startTimer:) withSignals:backupDoneSignal, nil];

    /*
        Listens to the updateIntervalHours.
        If it change, it will map it to our private backupTimeInterval (which is hours).
        It will also stop the backupTimer and start it again.
    */
    RACSignal *updateIntervalSignal = [[RACObserve(self, updateIntervalHours) ignore:nil] distinctUntilChanged];
    [self rac_liftSelector:@selector(endTimer:) withSignals:updateIntervalSignal, nil];
    [self rac_liftSelector:@selector(startTimer:) withSignals:updateIntervalSignal, nil];

    RAC(self, backupTimeInterval) = [updateIntervalSignal map:^id(id value) {
        NSInteger hours = [value integerValue];
        return @(hours * 3602);
    }];

    /*
        Handles saving to NSUserDefaults
        * Folders selected for backup
        * Autoupdate timer
    */
    [self persistentFolders];
    [self persistentAutoUpdate];
    [self persistentLastBackupDate];
}

- (void)persistentLastBackupDate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    RACChannelTerminal *lastBackupDateTerminal = RACChannelTo(self, lastBackupDate);
    RACChannelTerminal *defaultsAutoUpdateIntervalTerminal = [defaults rac_channelTerminalForKey:BackupModelLastBackupDateKey];

    [[lastBackupDateTerminal skip:1] subscribe:defaultsAutoUpdateIntervalTerminal];
    [defaultsAutoUpdateIntervalTerminal subscribe:lastBackupDateTerminal];
}

- (void)persistentAutoUpdate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    RACChannelTerminal *autoUpdateIntervalTerminal = RACChannelTo(self, updateIntervalHours);
    RACChannelTerminal *defaultsAutoUpdateIntervalTerminal = [defaults rac_channelTerminalForKey:BackupModelAutoUpdateIntervalKey];

    [[autoUpdateIntervalTerminal skip:1] subscribe:defaultsAutoUpdateIntervalTerminal];
    [defaultsAutoUpdateIntervalTerminal subscribe:autoUpdateIntervalTerminal];
}

- (void)persistentFolders
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    RACChannelTerminal *currentFolderTerminal = RACChannelTo(self, folders);
    RACChannelTerminal *defaultsTerminal = [defaults rac_channelTerminalForKey:BackupModelFoldersKey];

    [[defaultsTerminal map:^id(NSData *data) {
        if (!data) return nil;
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }] subscribe:currentFolderTerminal];

    [[[currentFolderTerminal skip:1] map:^id(Folder *folder){
        return [NSKeyedArchiver archivedDataWithRootObject:folder];
    }] subscribe:defaultsTerminal];



    /*
        Binds to the backupLog
    */

    RAC(self, backupLog) = [self.backupNowCommand.executionSignals flatten];
}

- (void)backupTimeFired:(id)backupTimeFired {
    [self.backupNowCommand execute:nil];
}

#pragma mark - Timer

- (void)startTimer:(id)_
{
    // Timer which will launch the backup
    self.backupTimer = [NSTimer timerWithTimeInterval:self.backupTimeInterval target:self selector:@selector(backupTimeFired:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.backupTimer forMode:NSRunLoopCommonModes];
}

- (void)endTimer:(id)_
{
    if([self.backupTimer isValid]) {
        [self.backupTimer invalidate];
    }
}

#pragma mark - Properties

- (RACCommand *)backupNowCommand
{
    if (!_backupNowCommand) {
        _backupNowCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            [self endTimer:nil];
            if(self.folders.count > 0) {
                return [self.tarsnapClient makeWithDeltas:nil folders:self.folders];
            }
            return [RACSignal return:nil];
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

- (void)addFolders:(NSArray *)folders {
    NSMutableArray *allFolders = [NSMutableArray arrayWithArray:_folders];
    [allFolders addObjectsFromArray:folders];
    self.folders = allFolders;
}

- (void)removeFoldersInIndexSet:(NSIndexSet *)set {
    NSMutableArray *folders = [self.folders mutableCopy];
    [folders removeObjectsAtIndexes:set];
    self.folders = folders;
}

@end
