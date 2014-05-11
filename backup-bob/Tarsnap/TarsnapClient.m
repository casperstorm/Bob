//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import "TarsnapClient.h"
#import "Folder.h"
#import "NSObject+NotificationSignal.h"
#import "NSError+ConvenienceCreatorAdditions.h"

@interface TarsnapClient ()
@end

@implementation TarsnapClient {
    NSTask *_task;
}

- (id)init
{
    if (!(self = [super init])) return nil;


    return self;
}

- (RACSignal *)makeWithDeltas:(NSArray *)deltas folders:(NSArray *)folders  {
    NSMutableArray *arguments = [NSMutableArray new];
    [arguments addObjectsFromArray:@[@"--deltas", @"3h", @"1d", @"7d", @"30d"]];
    [arguments addObject:@"--sources"];
    for (Folder *folder in folders) {
        if([folder isActive]) {
            [arguments addObject:folder.path];
        }
    }

    [arguments addObject:@"--target"];
    [arguments addObject:@"Backup-$date"];

    [arguments addObject:@"-"];
    [arguments addObject:@"make"];

    return [self performCommandWithLaunchPath:@"/usr/local/bin/tarsnapper" arguments:arguments environment:@{}];
}

- (RACSignal *)sleep {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        float delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [subscriber sendNext:@""];
            [subscriber sendCompleted];
        });

        return nil;
    }];
}

- (RACSignal *)performCommandWithLaunchPath:(NSString *)launchPath arguments:(NSArray *)arguments environment:(NSDictionary *)environment {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        _task = [[NSTask alloc] init];
        [_task setLaunchPath:launchPath];
        [_task setArguments:arguments];
        [_task setEnvironment:environment];

        NSPipe *pipe = [NSPipe pipe];
        [_task setStandardOutput:pipe];

        NSPipe *errorPipe = [NSPipe pipe];
        [_task setStandardError:errorPipe];

        NSFileHandle *errorFile = [errorPipe fileHandleForReading];

        __block NSObject *observer = [NSObject new];
        RACSignal *dataSignal = [observer rac_notifyUntilDealloc:NSFileHandleDataAvailableNotification];

        [dataSignal subscribeNext:^(NSNotification *notification) {
            NSFileHandle *fileHandle = notification.object;
            NSData *data = [fileHandle availableData];
            NSString *output = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
            [subscriber sendNext:output];
            if(output.length != 0) {
                [fileHandle waitForDataInBackgroundAndNotify];
            } else {
                observer = nil;
                int status = [_task terminationStatus];

                if (status == 0) {
                    [subscriber sendCompleted];
                } else {
                    NSError *error = [NSError errorWithDescription:@"Backup failed" code:status];
                    [subscriber sendError:error];
                }
            }
        }];

        [errorFile waitForDataInBackgroundAndNotify];
        [_task launch];

        return nil;
    }];
}

- (void)terminate {
    [_task terminate];
}
@end