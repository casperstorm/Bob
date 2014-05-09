//
//  Created by Peter Gammelgaard on 09/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import "GeneralPreferencesViewController.h"
#import "GeneralPreferencesViewModel.h"
#import "View+MASAdditions.h"

@interface GeneralPreferencesViewController ()
@property (nonatomic, readonly) GeneralPreferencesViewModel *viewModel;
@end
@implementation GeneralPreferencesViewController {
    GeneralPreferencesViewModel *_viewModel;
    NSButton *_startAtLaunchSwitchButton;
}

- (id)init {
    self = [super init];
    if (self) {
        NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 300, 300)];
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
}

- (void)setupSubViews {
    [self.view addSubview:self.startAtLaunchSwitchButton];
}

- (void)setupBindings {

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
    }

    return _startAtLaunchSwitchButton;
}

- (GeneralPreferencesViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [GeneralPreferencesViewModel new];
    }

    return _viewModel;
}


@end