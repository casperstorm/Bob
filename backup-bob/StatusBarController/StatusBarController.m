//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import "StatusBarController.h"
#import "StatusBarViewModel.h"

@interface StatusBarController ()
@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSMenuItem *lastBackupMenuItem;
@property (nonatomic, strong) NSMenuItem *nextBackupMenuItem;
@property (nonatomic, readonly) StatusBarViewModel *viewModel;
@end
@implementation StatusBarController
{
    StatusBarViewModel *_viewModel;
}

- (id)init
{
    if (!(self = [super init])) return nil;

    [self setupMenu];
    [self setupBindings];

    return self;
}

- (void)setupBindings
{
    RAC(self, lastBackupMenuItem.title) = RACObserve(self.viewModel, lastBackupString);
    RAC(self, nextBackupMenuItem.title) = RACObserve(self.viewModel, nextBackupString);
}

- (void)setupMenu
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.title = @"Bob";
    self.statusItem.highlightMode = YES;

    NSMenu *menu = [NSMenu new];
    [menu addItem:self.lastBackupMenuItem];
    [menu addItem:self.nextBackupMenuItem];
    [menu addItem:[NSMenuItem separatorItem]];
    [[menu addItemWithTitle:@"Backup now" action:@selector(backupNowClicked:) keyEquivalent:@""] setTarget:self];
    [menu addItem:[NSMenuItem separatorItem]];
    [[menu addItemWithTitle:@"Preferences..." action:@selector(backupNowClicked:) keyEquivalent:@""] setTarget:self];
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    self.statusItem.menu = menu;
}

- (void)backupNowClicked:(id)backupNowClicked
{
    [self.viewModel.backupNowCommand execute:nil];
}

#pragma mark - Properties

- (NSMenuItem *)lastBackupMenuItem
{
    if (!_lastBackupMenuItem) {
        _lastBackupMenuItem = [NSMenuItem new];
        _lastBackupMenuItem.title = @"Never";
    }

    return _lastBackupMenuItem;
}

- (NSMenuItem *)nextBackupMenuItem
{
    if (!_nextBackupMenuItem) {
        _nextBackupMenuItem = [NSMenuItem new];
        _nextBackupMenuItem.title = @"Never";
    }

    return _nextBackupMenuItem;
}

- (StatusBarViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [StatusBarViewModel new];
    }

    return _viewModel;
}


@end
