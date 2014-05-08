//
//  AppDelegate.m
//  backup-bob
//
//  Created by Casper Storm Larsen on 08/05/14.
//

#import "AppDelegate.h"
@interface AppDelegate ()
@property (strong, nonatomic) NSStatusItem *statusItem;
@end
@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setupStatusItem];
    [self setupMenu];
}
- (void)setupStatusItem
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.title = @"Bob";
    self.statusItem.highlightMode = YES;

// The image that will be shown in the menu bar, a 16x16 black png works best
//    self.statusItem.image = [NSImage imageNamed:@"status_bar_test.png"];
//    self.statusItem.alternateImage = [NSImage imageNamed:@"status_bar_test.png"];
}

- (void)setupMenu
{
    NSMenu *menu = [NSMenu new];
    [menu addItemWithTitle:@"Something" action:@selector(something:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Something else" action:@selector(something:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Something something" action:@selector(something:) keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItemWithTitle:@"Quit Backup Bob" action:@selector(terminate:) keyEquivalent:@""];
    self.statusItem.menu = menu;
}


@end
