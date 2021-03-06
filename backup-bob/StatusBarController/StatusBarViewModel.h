//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import <Foundation/Foundation.h>


@interface StatusBarViewModel : NSObject
@property (nonatomic, readonly) NSString *nextBackupString;
@property (nonatomic, readonly) NSString *lastBackupString;
@property (nonatomic, getter=isStatusBarVisible) BOOL statusBarVisible;
@property (nonatomic, strong) RACCommand *backupNowCommand;
@end