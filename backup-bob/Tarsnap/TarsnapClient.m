//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import "TarsnapClient.h"
#import "NSError+ConvenienceCreatorAdditions.h"
#import "Folder.h"

@interface TarsnapClient ()
@end

@implementation TarsnapClient

- (id)init
{
    if (!(self = [super init])) return nil;

    return self;
}

- (RACSignal *)makeWithDeltas:(NSArray *)deltas folders:(NSArray *)folders  {
    if(folders.count==0) return nil;

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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
            NSFileHandle *file = [pipe fileHandleForReading];

            [task launch];

            NSData *outputData = [file readDataToEndOfFile];
            NSData *errorOutputData = [errorFile readDataToEndOfFile];

            NSString *output = [[NSString alloc] initWithData:outputData encoding: NSUTF8StringEncoding];
            NSString *errorString = [[NSString alloc] initWithData:errorOutputData encoding: NSUTF8StringEncoding];

            [subscriber sendNext:output];

            if(errorString.length) {
                NSError *error = [NSError errorWithDescription:errorString code:1000];
                [subscriber sendError:error];
            } else {
                [subscriber sendCompleted];
            }
        });

        return nil;
    }];
}

@end