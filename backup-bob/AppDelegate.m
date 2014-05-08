//
//  AppDelegate.m
//  backup-bob
//
//  Created by Casper Storm Larsen on 08/05/14.
//  Copyright (c) 2014 Shape A/S. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate ()
@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSMenuItem *lastBackupMenuItem;
@property (nonatomic, strong) NSMenuItem *nextBackupMenuItem;
@end
@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{    
    [self setupStatusItem];
    [self setupMenu];

    [self setupBindings];
}

- (void)setupBindings
{

}

- (void)setupStatusItem
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.title = @"Bob";
    self.statusItem.highlightMode = YES;
}

- (void)setupMenu
{
    NSMenu *menu = [NSMenu new];

    [menu addItem:self.lastBackupMenuItem];
    [menu addItem:self.nextBackupMenuItem];
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    self.statusItem.menu = menu;
}

#pragma mark - Properties

- (NSMenuItem *)lastBackupMenuItem
{
    if (!_lastBackupMenuItem) {
        _lastBackupMenuItem = [NSMenuItem new];
        _lastBackupMenuItem.title = @"Last backup:";
    }

    return _lastBackupMenuItem;
}

- (NSMenuItem *)nextBackupMenuItem
{
    if (!_nextBackupMenuItem) {
        _nextBackupMenuItem = [NSMenuItem new];
        _nextBackupMenuItem.title = @"Next backup:";
    }

    return _nextBackupMenuItem;
}


@end
