//
//  Created by Peter Gammelgaard on 09/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "FolderPreferencesViewController.h"
#import "FolderPreferencesViewModel.h"
#import "BackupModel.h"
#import "Folder.h"


@implementation FolderPreferencesViewController {
    FolderPreferencesViewModel *_viewModel;

    NSTableView *_folderTableView;
    NSButton *_addButton;
    NSButton *_removeButton;
    NSScrollView *_containerScrollView;
}

- (id)init {
    self = [super init];
    if (self) {
        NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 300, 300)];

        _viewModel = [FolderPreferencesViewModel new];

        [self setView:view];
        [self setupBindings];
        [self setupSubViews];
        [self setupLayout];
    }

    return self;
}

- (void)setupBindings {

    [self.folderTableView rac_liftSelector:@selector(reloadData:) withSignals:[RACObserve(_viewModel, folders) distinctUntilChanged], nil];
}

- (void)setupLayout {
    [self.containerScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@-50);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
    }];

    [self.folderTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerScrollView);
    }];

    [self.addButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerScrollView.mas_bottom);
        make.left.equalTo(self.containerScrollView);
        make.width.equalTo(@30);
        make.height.equalTo(@20);
    }];

    [self.removeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerScrollView.mas_bottom);
        make.left.equalTo(self.addButton.mas_right);
        make.width.equalTo(self.addButton);
        make.height.equalTo(self.addButton);
    }];
}

- (void)setupSubViews {
    [self.view addSubview:self.containerScrollView];
    [self.containerScrollView setDocumentView:self.folderTableView];
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.removeButton];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier {
    return @"FolderPreferences";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:NSImageNameFolder];
}

- (NSString *)toolbarItemLabel
{
    return @"Folders";
}

- (BOOL)hasResizableWidth {
    return YES;
}

- (BOOL)hasResizableHeight {
    return YES;
}

#pragma mark - Actions

- (void)addFilePressed:(id)sender{

    NSOpenPanel* openDlg = [NSOpenPanel openPanel];

    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:YES];
    [openDlg setPrompt:@"Select"];

    if ( [openDlg runModal] == NSOKButton ) {
        NSArray* files = [openDlg URLs];

        NSMutableArray *folders = [NSMutableArray new];
        for (NSURL *url in files) {
            NSLog(@"%@", [url path]);
            Folder *folder = [[Folder alloc] initWithPath:[url path] active:YES];
            [folders addObject:folder];
        }

//        for( int i = 0; i < [files count]; i++ ) {
//            NSString* fileName = [files objectAtIndex:i];
//            Folder *folder = [[Folder alloc] initWithPath:fileName active:YES];
//            [folders addObject:folder];
//        }

        [[BackupModel sharedInstance] addFolders:folders];
    }
}

#pragma mark - TableView delegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _viewModel.folders.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    Folder *folder = [_viewModel.folders objectAtIndex:(NSUInteger) row];

    if ([tableColumn.identifier isEqualToString:ColumnActiveIdentifier]) {
        NSString *activeIdentifier = @"ActiveIdentifier";
        NSButton *activeButton = [tableView makeViewWithIdentifier:activeIdentifier owner:self];

        if(activeButton == nil) {
            activeButton = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            [activeButton setButtonType:NSSwitchButton];
            [activeButton setTitle:@""];

        }

        [activeButton setState:[folder isActive]];

        return activeButton;

    } else if([tableColumn.identifier isEqualToString:ColumnPathIdentifier]) {
        NSString *pathIdentifier = @"PathIdentifier";
        NSTextField *pathTextField = [tableView makeViewWithIdentifier:pathIdentifier owner:self];
        if (pathTextField == nil) {
            pathTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
            [pathTextField setBezeled:NO];
            [pathTextField setDrawsBackground:NO];
            [pathTextField setEditable:NO];
            [pathTextField setSelectable:NO];
            pathTextField.identifier = pathIdentifier;
        }

        pathTextField.stringValue = folder.path;

        return pathTextField;
    }

    return nil;
}

#pragma mark - Views

- (NSTableView *)folderTableView {
    if(!_folderTableView) {
        _folderTableView = [[NSTableView alloc] init];
        _folderTableView.delegate = self;
        _folderTableView.dataSource = self;
        [_folderTableView setUsesAlternatingRowBackgroundColors:YES];

        NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:ColumnActiveIdentifier];
        [[column1 headerCell] setStringValue:@"Active"];
        NSTableColumn * column2 = [[NSTableColumn alloc] initWithIdentifier:ColumnPathIdentifier];
        [[column2 headerCell] setStringValue:@"Path"];
        [column1 setWidth:35];
        [column2 setWidth:60];
        [_folderTableView addTableColumn:column1];
        [_folderTableView addTableColumn:column2];
        [_folderTableView reloadData];
    }

    return _folderTableView;
}

- (NSScrollView *)containerScrollView {
    if(!_containerScrollView) {
        _containerScrollView = [NSScrollView new];
        [_containerScrollView setHasVerticalScroller:YES];
    }

    return _containerScrollView;
}

- (NSButton *)addButton {
    if(!_addButton) {
        _addButton = [NSButton new];
        _addButton.image = [NSImage imageNamed:NSImageNameAddTemplate];
        [_addButton setButtonType:NSMomentaryPushInButton];
        [_addButton setBezelStyle:NSSmallSquareBezelStyle];
        [_addButton setAction:@selector(addFilePressed:)];
    }

    return _addButton;
}

- (NSButton *)removeButton {
    if(!_removeButton) {
        _removeButton = [NSButton new];
        _removeButton.image = [NSImage imageNamed:NSImageNameRemoveTemplate];
        [_removeButton setButtonType:NSMomentaryPushInButton];
        [_removeButton setBezelStyle:NSSmallSquareBezelStyle];
    }

    return _removeButton;
}

@end