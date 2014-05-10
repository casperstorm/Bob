//
//  Created by Peter Gammelgaard on 09/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import "GeneralPreferencesViewController.h"
#import "GeneralPreferencesViewModel.h"
#import "View+MASAdditions.h"
#import "BackupModel.h"
#import "NSComboBox+RACAdditions.h"

@interface GeneralPreferencesViewController () <NSComboBoxDelegate>
@property (nonatomic, readonly) GeneralPreferencesViewModel *viewModel;
@property (nonatomic, strong) NSButton *startAtLaunchSwitchButton;
@property (nonatomic, strong) NSTextField *versionTextField;
@property (nonatomic, strong) NSTextField *informationTextField;
@property (nonatomic, strong) NSTextField *autobackupTextField;
@property (nonatomic, strong) NSComboBox *backupTimerComboBox;
@property (nonatomic, strong) NSArray *comboBoxArray;
@end
@implementation GeneralPreferencesViewController {
    GeneralPreferencesViewModel *_viewModel;
}

- (id)init {
    self = [super init];
    if (self) {
        NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 300, 130)];
        self.comboBoxArray = @[ @"3 hours", @"5 hours", @"7 hours" ];

        [self setView:view];
        [self setupBindings];
        [self setupSubViews];
        [self setupLayout];
    }

    return self;
}

- (void)setupLayout {
    [self.startAtLaunchSwitchButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.right.equalTo(@-10);
        make.top.equalTo(self.view).with.offset(10.f);
        make.centerX.equalTo(self.view);
    }];

    [self.versionTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(@-15);
    }];

    [self.informationTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.versionTextField);
        make.bottom.equalTo(self.versionTextField.mas_top);
    }];

    [self.backupTimerComboBox mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.autobackupTextField);
        make.width.equalTo(@100);
        make.left.equalTo(self.autobackupTextField.mas_right).offset(5.0f);
    }];

    [self.autobackupTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(self.startAtLaunchSwitchButton.mas_bottom).offset(10.f);
    }];
}

- (void)setupSubViews {
    [self.view addSubview:self.startAtLaunchSwitchButton];
    [self.view addSubview:self.versionTextField];
    [self.view addSubview:self.informationTextField];
    [self.view addSubview:self.backupTimerComboBox];
    [self.view addSubview:self.autobackupTextField];
}

- (void)setupBindings
{
    RAC(self, startAtLaunchSwitchButton.state) = RACObserve(self.viewModel, startAppAtLaunch);
    RAC(self.backupTimerComboBox, selectedIndex) = RACObserve(self.viewModel, updateInterval);
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier {
    return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return @"General";
}

- (BOOL)hasResizableWidth {
    return NO;
}

- (BOOL)hasResizableHeight {
    return NO;
}

#pragma mark - Views

- (NSButton *)startAtLaunchSwitchButton {
    if (!_startAtLaunchSwitchButton) {
        _startAtLaunchSwitchButton = [NSButton new];
        _startAtLaunchSwitchButton.title = @"Start Backup Bob on system startup";
        [_startAtLaunchSwitchButton setButtonType:NSSwitchButton];
        [_startAtLaunchSwitchButton setAction:@selector(startAtLaunchButtonClicked:)];
        [_startAtLaunchSwitchButton setTarget:self];
    }

    return _startAtLaunchSwitchButton;
}

- (void)startAtLaunchButtonClicked:(id)startAtLaunchButtonClicked
{
    NSButton *button = startAtLaunchButtonClicked;
    [self.viewModel.startAtLaunchCommand execute:@(button.state)];
}

- (NSTextField *)versionTextField {
    if(!_versionTextField) {
        _versionTextField = [NSTextField new];
        [_versionTextField setBezeled:NO];
        [_versionTextField setDrawsBackground:NO];
        [_versionTextField setEditable:NO];
        [_versionTextField setSelectable:NO];
        [_versionTextField setFont:[NSFont systemFontOfSize:11]];
        [_versionTextField setTextColor:[NSColor grayColor]];
        [_versionTextField setStringValue:[self versionNumber]];
    }

    return _versionTextField;
}

- (NSTextField *)informationTextField
{
    if (!_informationTextField) {
        _informationTextField = [NSTextField new];
        [_informationTextField setBezeled:NO];
        [_informationTextField setDrawsBackground:NO];
        [_informationTextField setEditable:NO];
        [_informationTextField setSelectable:NO];
        [_informationTextField setFont:[NSFont systemFontOfSize:11]];
        [_informationTextField setTextColor:[NSColor grayColor]];
        [_informationTextField setStringValue:@"Built for Tarsnap"];
    }

    return _informationTextField;
}

- (NSComboBox *)backupTimerComboBox
{
    if (!_backupTimerComboBox) {
        _backupTimerComboBox = [NSComboBox new];
        _backupTimerComboBox.delegate = self;
        [_backupTimerComboBox setEditable:NO];
        [_backupTimerComboBox addItemsWithObjectValues:self.comboBoxArray];
    }

    return _backupTimerComboBox;
}

- (NSTextField *)autobackupTextField
{
    if (!_autobackupTextField) {
        _autobackupTextField = [NSTextField new];
        [_autobackupTextField setBezeled:NO];
        [_autobackupTextField setDrawsBackground:NO];
        [_autobackupTextField setEditable:NO];
        [_autobackupTextField setSelectable:NO];
        [_autobackupTextField setStringValue:@"Auto backup each"];
    }

    return _autobackupTextField;
}


- (GeneralPreferencesViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [GeneralPreferencesViewModel new];
    }

    return _viewModel;
}

#pragma mark - NSComboBoxDelegate methods

- (void)comboBoxSelectionDidChange:(NSNotification *)notification
{
    NSComboBox *comboBox = [notification object];
    enum AutoUpdateInterval updateInterval = (enum AutoUpdateInterval) comboBox.indexOfSelectedItem;
    [self.viewModel.updateIntervalCommand execute:@(updateInterval)];
}

#pragma mark - Helpers

- (NSString *)versionNumber
{
    NSString *marketingVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *buildNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];

    return [NSString stringWithFormat:@"Version %@ (%@)", marketingVersion, buildNumber];
}


@end