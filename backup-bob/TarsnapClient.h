//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import <Foundation/Foundation.h>


@interface TarsnapClient : NSObject
@property (nonatomic, readonly) NSString *nextBackupString;
@property (nonatomic, readonly) NSString *lastBackupString;
@end