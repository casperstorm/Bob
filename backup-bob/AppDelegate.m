//
//  AppDelegate.m
//  backup-bob
//
//  Created by Casper Storm Larsen on 08/05/14.
//  Copyright (c) 2014 Shape A/S. All rights reserved.
//

#import "AppDelegate.h"
#import "TarsnapClient.h"
#import "StatusBarController.h"

@interface AppDelegate ()
@property (nonatomic, strong) StatusBarController *statusBarController;
@end
@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.statusBarController = [StatusBarController new];
}

@end
