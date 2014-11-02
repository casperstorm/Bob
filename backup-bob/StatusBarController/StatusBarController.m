//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import "StatusBarController.h"
#import "StatusBarViewModel.h"
#import "MASPreferencesWindowController.h"
#import "GeneralPreferencesViewController.h"
#import "FolderPreferencesViewController.h"
#import "LogPreferencesViewController.h"

@interface StatusBarController ()
@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSMenuItem *lastBackupMenuItem;
@property (nonatomic, strong) NSMenuItem *nextBackupMenuItem;
@property (nonatomic, readonly) StatusBarViewModel *viewModel;
@end
@implementation StatusBarController
{
    StatusBarViewModel *_viewModel;
    MASPreferencesWindowController *_preferencesWindowController;
}

- (id)init
{
    if (!(self = [super init])) return nil;
    [self setupPreferences];
    [self setupMenu];
    [self setupBindings];

    return self;
}


- (void)setupPreferences {
    GeneralPreferencesViewController *generalPreferencesViewController = [GeneralPreferencesViewController new];
    FolderPreferencesViewController *folderPreferencesViewController = [FolderPreferencesViewController new];
    LogPreferencesViewController *logPreferencesViewController = [LogPreferencesViewController new];
    NSArray *controllers = @[generalPreferencesViewController, folderPreferencesViewController, logPreferencesViewController];

    NSString *title = @"Preferences";
    _preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
    [_preferencesWindowController.window setLevel:NSFloatingWindowLevel];
}

- (void)setupBindings
{
    RAC(self, lastBackupMenuItem.title) = RACObserve(self.viewModel, lastBackupString);
    RAC(self, nextBackupMenuItem.title) = RACObserve(self.viewModel, nextBackupString);

    RACSignal *showSignal = [[self rac_signalForSelector:@selector(menuWillOpen:)] mapReplace:@(YES)];
    RACSignal *hideSignal = [[self rac_signalForSelector:@selector(menuDidClose:)] mapReplace:@(NO)];
    RAC(self.viewModel, statusBarVisible) = [RACSignal merge:@[showSignal, hideSignal]];

    NSDistributedNotificationCenter *notificationCenter = [NSDistributedNotificationCenter defaultCenter];
    RACSignal *styleSignal = [[notificationCenter rac_addObserverForName:@"AppleInterfaceThemeChangedNotification" object:nil] takeUntil:[self rac_willDeallocSignal]];
    
    RACSignal *statusBarCreationSignal = [RACObserve(self, statusItem) take:1];
    RACSignal *isDarkModeStatusBarSignal = [[RACSignal merge:@[statusBarCreationSignal, styleSignal]] map:^id(id value) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:NSGlobalDomain];
        id style = [dict objectForKey:@"AppleInterfaceStyle"];
        BOOL darkModeOn = ( style && [style isKindOfClass:[NSString class]] && NSOrderedSame == [style caseInsensitiveCompare:@"dark"] );
        return @(darkModeOn);
    }];
    
    RAC(self.statusItem, image) = [isDarkModeStatusBarSignal map:^id(NSNumber *isDarkModeNumber) {
        BOOL isDarkMode = [isDarkModeNumber boolValue];
        return isDarkMode ? [NSImage imageNamed:@"bob-darkmode-normal_360.png"] : [NSImage imageNamed:@"bob-normal_360.png"];
    }];
}

- (void)setupMenu
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.alternateImage = [NSImage imageNamed:@"bob-selected_360.png"];
    self.statusItem.title = @"";
    self.statusItem.highlightMode = YES;

    NSMenu *menu = [NSMenu new];
    [menu addItem:self.lastBackupMenuItem];
    [menu addItem:self.nextBackupMenuItem];
    [menu addItem:[NSMenuItem separatorItem]];
    [[menu addItemWithTitle:@"Backup now" action:@selector(backupNowClicked:) keyEquivalent:@""] setTarget:self];
    [menu addItem:[NSMenuItem separatorItem]];
    [[menu addItemWithTitle:@"Preferences..." action:@selector(preferencesClicked:) keyEquivalent:@""] setTarget:self];
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    self.statusItem.menu = menu;
    [menu setDelegate:self];
}

- (void)preferencesClicked:(id)preferencesClicked {
    [_preferencesWindowController showWindow:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)backupNowClicked:(id)backupNowClicked
{
    [self.viewModel.backupNowCommand execute:nil];
}

#pragma mark - NSMenu delegate

- (void)menuWillOpen:(NSMenu *)menu {
}

- (void)menuDidClose:(NSMenu *)menu {
}


#pragma mark - Properties

- (NSMenuItem *)lastBackupMenuItem
{
    if (!_lastBackupMenuItem) {
        _lastBackupMenuItem = [NSMenuItem new];
    }

    return _lastBackupMenuItem;
}

- (NSMenuItem *)nextBackupMenuItem
{
    if (!_nextBackupMenuItem) {
        _nextBackupMenuItem = [NSMenuItem new];
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
