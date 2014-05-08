//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import "StatusBarViewModel.h"

@interface StatusBarViewModel ()
@property (nonatomic, strong) NSString *nextBackupString;
@property (nonatomic, strong) NSString *lastBackupString;
@end
@implementation StatusBarViewModel

- (id)init
{
    if (!(self = [super init])) return nil;

    self.nextBackupString = @"Never";
    self.lastBackupString = @"Never";

    return self;
}


@end