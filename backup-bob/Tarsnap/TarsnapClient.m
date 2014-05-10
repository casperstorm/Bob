//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import "TarsnapClient.h"
#import "NSError+ConvenienceCreatorAdditions.h"
#import "Folder.h"
#import "NSObject+NotificationSignal.h"

@interface TarsnapClient ()
@end

@implementation TarsnapClient

- (id)init
{
    if (!(self = [super init])) return nil;

    return self;
}

- (RACSignal *)makeWithDeltas:(NSArray *)deltas folders:(NSArray *)folders  {
//    if(folders.count==0) return nil;

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

//    return [self performCommandWithLaunchPath:@"/bin/sleep" arguments:@[@"5"]];
}

- (RACSignal *)performCommandWithLaunchPath:(NSString *)launchPath arguments:(NSArray *)arguments environment:(NSDictionary *)environment {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        NSTask *task;
        task = [[NSTask alloc] init];
        [task setLaunchPath:launchPath];
        [task setArguments:arguments];
        [task setEnvironment:environment];

        NSPipe *pipe = [NSPipe pipe];
        [task setStandardOutput:pipe];

        NSPipe *errorPipe = [NSPipe pipe];
        [task setStandardError:errorPipe];

        NSFileHandle *errorFile = [errorPipe fileHandleForReading];

        RACSignal *dataSignal =[[NSNotificationCenter defaultCenter] rac_notifyUntilDealloc:NSFileHandleDataAvailableNotification];

        [dataSignal subscribeNext:^(NSNotification *notification) {
            NSFileHandle *fileHandle = notification.object;
            NSData *data = [fileHandle availableData];
            NSString *output = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
            [subscriber sendNext:output];
            if(output.length == 0) {
                [subscriber sendCompleted];
            }else {
                [fileHandle waitForDataInBackgroundAndNotify];
            }
        }];

        [errorFile waitForDataInBackgroundAndNotify];
        [task launch];

        return nil;
    }];
}

@end