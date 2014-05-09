//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import "TarsnapClient.h"
#import "NSError+ConvenienceCreatorAdditions.h"

@interface TarsnapClient ()
@end

@implementation TarsnapClient

- (id)init
{
    if (!(self = [super init])) return nil;

    return self;
}

- (RACSignal *)start {
    return [self performCommandWithLaunchPath:@"/usr/local/bin/tarsnapper" arguments:@[@"-c", @" /Users/peter/.backup/backup.config", @"make"]];
}

- (RACSignal *)sleep {
    return [self performCommandWithLaunchPath:@"/bin/sleep" arguments:@[@"5"]];
}

- (RACSignal *)performCommandWithLaunchPath:(NSString *)launchPath arguments:(NSArray *)arguments {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSTask *task;
            task = [[NSTask alloc] init];
            [task setLaunchPath:launchPath];
            [task setArguments: arguments];

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